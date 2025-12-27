import 'package:flutter/material.dart';
import '../theme/colors.dart';

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

class _SongsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final songs = List.generate(
      15,
      (index) => {
        'title': 'Song Title ${index + 1}',
        'artist': 'Artist Name',
        'duration': '3:${(index + 15).toString().padLeft(2, '0')}',
      },
    );

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: songs.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final song = songs[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: Container(
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
          title: Text(
            song['title']!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          subtitle: Text(
            song['artist']!,
            style: const TextStyle(color: AppColors.textMuted),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                song['duration']!,
                style: const TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.more_vert_rounded, color: AppColors.textMuted),
            ],
          ),
        );
      },
    );
  }
}

class _AlbumsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
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
            const SizedBox(height: 12),
            Text(
              'Album ${index + 1}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Artist Name',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
}

class _ArtistsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: 10,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Container(
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
              Container(
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
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Artist ${index + 1}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(index + 1) * 5} songs',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.more_vert_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        );
      },
    );
  }
}
