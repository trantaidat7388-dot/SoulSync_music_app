class Track {
  final String id;
  final String name;
  final String artistName;
  final String artistId;
  final String albumName;
  final String albumId;
  final String imageUrl;
  final String? previewUrl;
  final int durationMs;
  final int popularity;

  Track({
    required this.id,
    required this.name,
    required this.artistName,
    required this.artistId,
    required this.albumName,
    required this.albumId,
    required this.imageUrl,
    this.previewUrl,
    required this.durationMs,
    required this.popularity,
  });

  factory Track.fromSpotifyJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      artistName: json['artists'] != null && json['artists'].isNotEmpty
          ? json['artists'][0]['name']
          : 'Unknown Artist',
      artistId: json['artists'] != null && json['artists'].isNotEmpty
          ? json['artists'][0]['id']
          : '',
      albumName: json['album']?['name'] ?? 'Unknown Album',
      albumId: json['album']?['id'] ?? '',
      imageUrl: json['album']?['images'] != null &&
              json['album']['images'].isNotEmpty
          ? json['album']['images'][0]['url']
          : '',
      previewUrl: json['preview_url'],
      durationMs: json['duration_ms'] ?? 0,
      popularity: json['popularity'] ?? 0,
    );
  }

  factory Track.fromDeezerJson(Map<String, dynamic> json) {
    return Track(
      id: json['id']?.toString() ?? '',
      name: json['title'] ?? 'Unknown',
      artistName: json['artist']?['name'] ?? 'Unknown Artist',
      artistId: json['artist']?['id']?.toString() ?? '',
      albumName: json['album']?['title'] ?? 'Unknown Album',
      albumId: json['album']?['id']?.toString() ?? '',
      imageUrl: json['album']?['cover_medium'] ?? '',
      previewUrl: json['preview'],
      durationMs: (json['duration'] ?? 0) * 1000,
      popularity: json['rank'] ?? 0,
    );
  }

  String get duration {
    final minutes = (durationMs / 60000).floor();
    final seconds = ((durationMs % 60000) / 1000).floor();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> genres;
  final int followers;
  final int popularity;

  Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.genres,
    required this.followers,
    required this.popularity,
  });

  factory Artist.fromSpotifyJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      imageUrl: json['images'] != null && json['images'].isNotEmpty
          ? json['images'][0]['url']
          : '',
      genres: json['genres'] != null
          ? List<String>.from(json['genres'])
          : [],
      followers: json['followers']?['total'] ?? 0,
      popularity: json['popularity'] ?? 0,
    );
  }
}

class Album {
  final String id;
  final String name;
  final String artistName;
  final String imageUrl;
  final String releaseDate;
  final int totalTracks;

  Album({
    required this.id,
    required this.name,
    required this.artistName,
    required this.imageUrl,
    required this.releaseDate,
    required this.totalTracks,
  });

  factory Album.fromSpotifyJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      artistName: json['artists'] != null && json['artists'].isNotEmpty
          ? json['artists'][0]['name']
          : 'Unknown Artist',
      imageUrl: json['images'] != null && json['images'].isNotEmpty
          ? json['images'][0]['url']
          : '',
      releaseDate: json['release_date'] ?? '',
      totalTracks: json['total_tracks'] ?? 0,
    );
  }
}

class Playlist {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int tracksCount;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.tracksCount,
  });

  factory Playlist.fromSpotifyJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? '',
      imageUrl: json['images'] != null && json['images'].isNotEmpty
          ? json['images'][0]['url']
          : '',
      tracksCount: json['tracks']?['total'] ?? 0,
    );
  }
}
