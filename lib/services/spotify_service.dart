import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/music_models.dart';

class SpotifyService {
  static const String _baseUrl = 'https://api.spotify.com/v1';
  static const String _authUrl = 'https://accounts.spotify.com/api/token';
  
  // TODO: Thay bằng credentials thật từ Spotify Dashboard
  static const String _clientId = 'YOUR_CLIENT_ID_HERE';
  static const String _clientSecret = 'YOUR_CLIENT_SECRET_HERE';
  
  String? _accessToken;
  DateTime? _tokenExpiry;

  static final SpotifyService _instance = SpotifyService._internal();
  factory SpotifyService() => _instance;
  SpotifyService._internal();

  // Lấy access token từ Spotify
  Future<void> _getAccessToken() async {
    if (_accessToken != null && 
        _tokenExpiry != null && 
        DateTime.now().isBefore(_tokenExpiry!)) {
      return; // Token còn hiệu lực
    }

    try {
      final credentials = base64Encode(utf8.encode('$_clientId:$_clientSecret'));
      
      final response = await http.post(
        Uri.parse(_authUrl),
        headers: {
          'Authorization': 'Basic $credentials',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'grant_type': 'client_credentials'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access_token'];
        final expiresIn = data['expires_in'] as int;
        _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
      } else {
        throw Exception('Failed to get access token: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting access token: $e');
    }
  }

  // Helper để gọi API với token
  Future<Map<String, dynamic>> _makeRequest(String endpoint) async {
    await _getAccessToken();

    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('API request failed: ${response.statusCode} - ${response.body}');
    }
  }

  // Tìm kiếm bài hát
  Future<List<Track>> searchTracks(String query, {int limit = 20}) async {
    try {
      final data = await _makeRequest('/search?q=$query&type=track&limit=$limit');
      final tracks = data['tracks']['items'] as List;
      return tracks.map((json) => Track.fromSpotifyJson(json)).toList();
    } catch (e) {
      print('Error searching tracks: $e');
      return [];
    }
  }

  // Lấy top tracks (featured playlists)
  Future<List<Track>> getFeaturedTracks({int limit = 20}) async {
    try {
      final data = await _makeRequest('/browse/featured-playlists?limit=1');
      final playlists = data['playlists']['items'] as List;
      
      if (playlists.isEmpty) return [];
      
      final playlistId = playlists[0]['id'];
      final playlistData = await _makeRequest('/playlists/$playlistId/tracks?limit=$limit');
      final items = playlistData['items'] as List;
      
      return items
          .where((item) => item['track'] != null)
          .map((item) => Track.fromSpotifyJson(item['track']))
          .toList();
    } catch (e) {
      print('Error getting featured tracks: $e');
      return [];
    }
  }

  // Lấy thông tin chi tiết track
  Future<Track?> getTrack(String trackId) async {
    try {
      final data = await _makeRequest('/tracks/$trackId');
      return Track.fromSpotifyJson(data);
    } catch (e) {
      print('Error getting track: $e');
      return null;
    }
  }

  // Lấy thông tin artist
  Future<Artist?> getArtist(String artistId) async {
    try {
      final data = await _makeRequest('/artists/$artistId');
      return Artist.fromSpotifyJson(data);
    } catch (e) {
      print('Error getting artist: $e');
      return null;
    }
  }

  // Lấy top tracks của artist
  Future<List<Track>> getArtistTopTracks(String artistId) async {
    try {
      final data = await _makeRequest('/artists/$artistId/top-tracks?market=US');
      final tracks = data['tracks'] as List;
      return tracks.map((json) => Track.fromSpotifyJson(json)).toList();
    } catch (e) {
      print('Error getting artist top tracks: $e');
      return [];
    }
  }

  // Lấy gợi ý dựa trên track
  Future<List<Track>> getRecommendations(String seedTrackId, {int limit = 20}) async {
    try {
      final data = await _makeRequest(
        '/recommendations?seed_tracks=$seedTrackId&limit=$limit'
      );
      final tracks = data['tracks'] as List;
      return tracks.map((json) => Track.fromSpotifyJson(json)).toList();
    } catch (e) {
      print('Error getting recommendations: $e');
      return [];
    }
  }

  // Lấy new releases
  Future<List<Album>> getNewReleases({int limit = 20}) async {
    try {
      final data = await _makeRequest('/browse/new-releases?limit=$limit');
      final albums = data['albums']['items'] as List;
      return albums.map((json) => Album.fromSpotifyJson(json)).toList();
    } catch (e) {
      print('Error getting new releases: $e');
      return [];
    }
  }

  // Lấy playlists theo category
  Future<List<Playlist>> getCategoryPlaylists(String categoryId, {int limit = 20}) async {
    try {
      final data = await _makeRequest(
        '/browse/categories/$categoryId/playlists?limit=$limit'
      );
      final playlists = data['playlists']['items'] as List;
      return playlists.map((json) => Playlist.fromSpotifyJson(json)).toList();
    } catch (e) {
      print('Error getting category playlists: $e');
      return [];
    }
  }
}
