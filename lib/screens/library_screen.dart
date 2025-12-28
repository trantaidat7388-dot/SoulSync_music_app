import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/deezer_service.dart';
import '../models/music_models.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // Background Gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.secondary.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: const _Header(),
                  ),
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 4,
                    child: Column(
                      children: [
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: const _TabBar(),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _PlaylistsTab(),
                              _SongsTab(),
                              _AlbumsTab(),
                              _ArtistsTab(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Library',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          Icon(
            Icons.add_circle_outline_rounded,
            color: AppColors.primary,
            size: 28,
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: TabBar(
        isScrollable: true,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Playlists'),
          Tab(text: 'Songs'),
          Tab(text: 'Albums'),
          Tab(text: 'Artists'),
        ],
      ),
    );
  }
}

class _PlaylistsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playlists = [
      {'name': 'My Favorites', 'count': '42 songs', 'color': AppColors.primary},
      {'name': 'Workout Mix', 'count': '28 songs', 'color': const Color(0xFFE85D75)},
      {'name': 'Chill Vibes', 'count': '35 songs', 'color': const Color(0xFF6B8CFF)},
      {'name': 'Study Focus', 'count': '51 songs', 'color': const Color(0xFF4CAF50)},
      {'name': 'Party Time', 'count': '39 songs', 'color': const Color(0xFFFF9800)},
      {'name': 'Road Trip', 'count': '46 songs', 'color': const Color(0xFF9C27B0)},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: playlists.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 80)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: child,
              ),
            );
          },
          child: _PlaylistItem(playlist: playlist),
        );
      },
    );
  }
}

class _PlaylistItem extends StatefulWidget {
  final Map<String, Object> playlist;

  const _PlaylistItem({required this.playlist});

  @override
  State<_PlaylistItem> createState() => _PlaylistItemState();
}

class _PlaylistItemState extends State<_PlaylistItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {},
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isPressed ? 0.02 : 0.05),
                blurRadius: _isPressed ? 5 : 10,
                offset: Offset(0, _isPressed ? 2 : 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: (widget.playlist['color'] as Color).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.music_note_rounded,
                  color: widget.playlist['color'] as Color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.playlist['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.playlist['count'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.more_vert_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SongsTab extends StatefulWidget {
  const _SongsTab();

  @override
  State<_SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends State<_SongsTab> {
  final DeezerService _deezerService = DeezerService();
  List<Track> _tracks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    setState(() => _isLoading = true);
    try {
      final tracks = await _deezerService.getChartTracks(limit: 30);
      if (mounted) {
        setState(() {
          _tracks = tracks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading tracks: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_tracks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_off_rounded,
              size: 80,
              color: AppColors.textMuted.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No songs found',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTracks,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: _tracks.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final track = _tracks[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 50)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: track.imageUrl.isNotEmpty
                  ? Image.network(
                      track.imageUrl,
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.music_note_rounded,
                            color: AppColors.primary,
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.music_note_rounded,
                        color: AppColors.primary,
                      ),
                    ),
            ),
            title: Text(
              track.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              track.artistName,
              style: const TextStyle(color: AppColors.textMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  track.duration,
                  style: const TextStyle(color: AppColors.textMuted),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.play_circle_filled),
                  color: AppColors.primary,
                  onPressed: () {
                    if (track.previewUrl != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Playing ${track.name}...'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No preview available'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AlbumsTab extends StatefulWidget {
  const _AlbumsTab();

  @override
  State<_AlbumsTab> createState() => _AlbumsTabState();
}

class _AlbumsTabState extends State<_AlbumsTab> {
  final DeezerService _deezerService = DeezerService();
  List<Album> _albums = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlbums();
  }

  Future<void> _loadAlbums() async {
    setState(() => _isLoading = true);
    try {
      // Get chart tracks and extract unique albums
      final tracks = await _deezerService.getChartTracks(limit: 50);
      final Map<String, Album> albumMap = {};
      
      for (var track in tracks) {
        if (!albumMap.containsKey(track.albumId)) {
          albumMap[track.albumId] = Album(
            id: track.albumId,
            name: track.albumName,
            artistName: track.artistName,
            imageUrl: track.imageUrl,
            releaseDate: '',
            totalTracks: 0,
          );
        }
      }

      if (mounted) {
        setState(() {
          _albums = albumMap.values.take(20).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading albums: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_albums.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.album_rounded,
              size: 80,
              color: AppColors.textMuted.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No albums found',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAlbums,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: _albums.length,
      itemBuilder: (context, index) {
        final album = _albums[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 50)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: album.imageUrl.isNotEmpty
                      ? Image.network(
                          album.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.album_rounded,
                                size: 48,
                                color: AppColors.primary,
                              ),
                            );
                          },
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.album_rounded,
                            size: 48,
                            color: AppColors.primary,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                album.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                album.artistName,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ArtistsTab extends StatefulWidget {
  const _ArtistsTab();

  @override
  State<_ArtistsTab> createState() => _ArtistsTabState();
}

class _ArtistsTabState extends State<_ArtistsTab> {
  final DeezerService _deezerService = DeezerService();
  List<Artist> _artists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArtists();
  }

  Future<void> _loadArtists() async {
    setState(() => _isLoading = true);
    try {
      // Get chart tracks and extract unique artists
      final tracks = await _deezerService.getChartTracks(limit: 50);
      final Map<String, Artist> artistMap = {};
      
      for (var track in tracks) {
        if (!artistMap.containsKey(track.artistId)) {
          artistMap[track.artistId] = Artist(
            id: track.artistId,
            name: track.artistName,
            imageUrl: track.imageUrl,
            genres: [],
            followers: 0,
            popularity: 0,
          );
        }
      }

      if (mounted) {
        setState(() {
          _artists = artistMap.values.take(20).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading artists: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_artists.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off_rounded,
              size: 80,
              color: AppColors.textMuted.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No artists found',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadArtists,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: _artists.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final artist = _artists[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 50)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipOval(
                  child: artist.imageUrl.isNotEmpty
                      ? Image.network(
                          artist.imageUrl,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: AppColors.primary,
                                size: 32,
                              ),
                            );
                          },
                        )
                      : Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: AppColors.primary,
                            size: 32,
                          ),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artist.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Artist',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.play_circle_filled),
                  color: AppColors.primary,
                  iconSize: 32,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Playing ${artist.name}\'s top tracks...'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
