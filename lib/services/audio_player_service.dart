import 'dart:async';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../models/music_models.dart';

class AudioPlayerService {
  AudioPlayerService._internal();
  static final AudioPlayerService instance = AudioPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();

  bool _initialized = false;
  bool _busy = false;
  static const Duration _loadTimeout = Duration(seconds: 20);
  static const Duration _downloadTimeout = Duration(minutes: 3);
  static const Duration _playTimeout = Duration(seconds: 5);

  final Dio _dio = Dio();

  String? _extensionFromContentType(String? contentType) {
    if (contentType == null) return null;
    final ct = contentType.toLowerCase();
    if (ct.contains('audio/mpeg') || ct.contains('audio/mp3')) return '.mp3';
    if (ct.contains('audio/wav') || ct.contains('audio/x-wav')) return '.wav';
    if (ct.contains('audio/mp4') || ct.contains('audio/m4a') || ct.contains('audio/aac')) return '.m4a';
    if (ct.contains('audio/ogg')) return '.ogg';
    return null;
  }

  Future<String> _cacheRemoteUrlToFile(String url) async {
    final uri = Uri.parse(url);
    final tmpDir = await getTemporaryDirectory();
    final cacheDir = Directory('${tmpDir.path}/audio_cache');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    // Try to build a stable-ish filename from the URL path.
    final segments = uri.pathSegments;
    final rawName = segments.isNotEmpty ? segments.last : 'audio.mp3';
    final baseName = rawName.isEmpty ? 'audio.mp3' : rawName;
    String safeName = baseName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    if (!safeName.contains('.')) {
      try {
        final head = await _dio
            .head(
              url,
              options: Options(followRedirects: true),
            )
            .timeout(const Duration(seconds: 10));
        final ext = _extensionFromContentType(head.headers.value('content-type'));
        if (ext != null) safeName = '$safeName$ext';
      } catch (_) {
        // Best-effort only; fall back to name without extension.
      }
    }

    final file = File('${cacheDir.path}/$safeName');

    if (await file.exists() && await file.length() > 0) {
      return file.path;
    }

    await _dio
        .download(
      url,
      file.path,
      options: Options(
        followRedirects: true,
        // Keep defaults for responseType; Dio will stream to file.
      ),
    )
        .timeout(_downloadTimeout);

    if (!await file.exists()) {
      throw StateError('Download failed: file not created');
    }
    final len = await file.length();
    if (len <= 0) {
      throw StateError('Download failed: empty file');
    }

    return file.path;
  }

  // Simple reactive state
  final StreamController<Track?> _trackController = StreamController.broadcast();
  final StreamController<bool> _playingController = StreamController.broadcast();
  final StreamController<double> _progressController = StreamController.broadcast();

  Track? _currentTrack;

  Stream<Track?> get trackStream => _trackController.stream;
  Stream<bool> get playingStream => _playingController.stream;
  Stream<double> get progressStream => _progressController.stream;

  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _player.playing;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    _player.positionStream.listen((pos) {
      final dur = _player.duration ?? Duration.zero;
      final pct = dur.inMilliseconds == 0
          ? 0.0
          : pos.inMilliseconds / dur.inMilliseconds;
      _progressController.add(pct.clamp(0.0, 1.0));
    });

    _player.playingStream.listen((playing) {
      _playingController.add(playing);
    });
  }

  Future<void> setTrack(Track track) async {
    if (_busy) {
      throw StateError('Player is busy. Please try again.');
    }

    _busy = true;
    _currentTrack = track;
    _trackController.add(track);

    final localPath = track.localPath?.trim();
    final url = track.previewUrl?.trim();

    debugPrint('▶️ setTrack: id=${track.id} name="${track.name}" url=${url ?? "(null)"} localPath=${localPath ?? "(null)"}');

    try {
      // Ensure any previous playback is stopped before swapping sources.
      await _player.stop();

      if (localPath != null && localPath.isNotEmpty) {
        debugPrint('📁 Using localPath: $localPath');
        await _player.setFilePath(localPath).timeout(_loadTimeout);
        return;
      }

      if (url != null && url.isNotEmpty) {
        final uri = Uri.tryParse(url);
        if (uri == null || !uri.hasScheme) {
          throw StateError('Invalid audio URL: $url');
        }

        // Windows-specific reliability fallback:
        // Some remote streams can cause the Windows backend to hang. If the URL is reachable
        // (as verified by the user in the browser) but the player freezes, caching locally
        // first avoids that code path.
        if (!kIsWeb && Platform.isWindows) {
          try {
            debugPrint('⬇️ Windows cache: downloading/caching $url');
            final cachedPath = await _cacheRemoteUrlToFile(url);
            try {
              final f = File(cachedPath);
              final size = await f.length();
              debugPrint('✅ Cached file: $cachedPath (${(size / 1024 / 1024).toStringAsFixed(2)} MB)');
            } catch (_) {}
            await _player.setFilePath(cachedPath).timeout(_loadTimeout);
            return;
          } catch (e, st) {
            debugPrint('⚠️ Windows cache fallback failed, trying direct URL: $e');
            debugPrintStack(stackTrace: st);
            // Fall through to direct URL source.
          }
        }

        // On Windows, preloading some remote sources can block for a while.
        // Using preload:false helps keep the UI responsive; playback will start on play().
        await _player
            .setAudioSource(
              AudioSource.uri(uri),
              preload: false,
            )
            .timeout(_loadTimeout);
        debugPrint('🌐 Using direct URL AudioSource (preload:false)');
        return;
      }

      throw StateError('Track has no playable audio URL (previewUrl/localPath are empty).');
    } on PlayerException catch (e, st) {
      debugPrint('❌ Audio load failed (PlayerException): ${e.code} - ${e.message}');
      debugPrintStack(stackTrace: st);
      rethrow;
    } on PlayerInterruptedException catch (e, st) {
      debugPrint('⚠️ Audio load interrupted: ${e.message}');
      debugPrintStack(stackTrace: st);
      rethrow;
    } on TimeoutException catch (e, st) {
      debugPrint('⏳ Audio load timed out: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    } catch (e, st) {
      debugPrint('❌ Audio load failed: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    } finally {
      _busy = false;
    }
  }

  Future<void> play() async {
    if (_player.audioSource == null) {
      throw StateError('No audio source loaded. Call setTrack() first.');
    }
    await _player.play().timeout(_playTimeout);
  }

  /// Convenience helper used by UI: load track (url/path) then start playback.
  Future<void> playTrack(Track track) async {
    await setTrack(track);
    await play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> dispose() async {
    await _player.dispose();
    await _trackController.close();
    await _playingController.close();
    await _progressController.close();
  }
}
