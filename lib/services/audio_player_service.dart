import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../models/music_models.dart';

class AudioPlayerService {
  AudioPlayerService._internal();
  static final AudioPlayerService instance = AudioPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();

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
    _currentTrack = track;
    _trackController.add(track);

    final url = track.previewUrl ?? track.imageUrl; // fallback to some URL if preview is null
    try {
      if (track.localPath != null && track.localPath!.isNotEmpty) {
        await _player.setFilePath(track.localPath!);
      } else if (url.isNotEmpty) {
        await _player.setUrl(url);
      }
    } catch (_) {
      // ignore load errors for now
    }
  }

  Future<void> play() async {
    await _player.play();
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
