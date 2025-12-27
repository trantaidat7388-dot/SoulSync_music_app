import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'now_playing_screen.dart';
import 'genre_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimations = List.generate(
      6,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.1,
            0.6 + (index * 0.1),
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _slideAnimations = List.generate(
      6,
      (index) => Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.1,
            0.6 + (index * 0.1),
            curve: Curves.easeOutCubic,
          ),
        ),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _fadeAnimations[0],
                    child: SlideTransition(
                      position: _slideAnimations[0],
                      child: const _HeaderSection(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _fadeAnimations[1],
                    child: SlideTransition(
                      position: _slideAnimations[1],
                      child: const _SearchBar(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _fadeAnimations[2],
                    child: SlideTransition(
                      position: _slideAnimations[2],
                      child: const _HeroCard(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _fadeAnimations[3],
                    child: SlideTransition(
                      position: _slideAnimations[3],
                      child: const _GenresSection(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _fadeAnimations[4],
                    child: SlideTransition(
                      position: _slideAnimations[4],
                      child: const _DailyMixSection(),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Các Widget con (Components) ---

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Hey, Alex!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Ready to vibe today?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.accentPeach,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                )
              ],
              image: const DecorationImage(
                image: NetworkImage('https://i.pravatar.cc/150?img=32'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              offset: const Offset(0, 10),
              blurRadius: 40,
              spreadRadius: -10,
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.textMuted),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search songs, artists, or playlists',
                  hintStyle: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatefulWidget {
  const _HeroCard();

  @override
  State<_HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<_HeroCard> with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const NowPlayingScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: child,
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        },
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8A598),
                  Color(0xFFFFD6A5),
                  Color(0xFFB8CBE3),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(0, 20),
                  blurRadius: 40,
                  spreadRadius: -12,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Nội dung Text & Button
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.3)),
                                ),
                                child: const Text(
                                  'FEATURED',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Lo-Fi\nBeats',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Relax & Focus',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GenresSection extends StatelessWidget {
  const _GenresSection();

  @override
  Widget build(BuildContext context) {
    final genres = [
      {'name': 'Pop', 'color': AppColors.accentPeach, 'icon': Icons.music_note},
      {
        'name': 'Chill',
        'color': AppColors.accentBlue,
        'icon': Icons.self_improvement
      },
      {
        'name': 'EDM',
        'color': AppColors.accentLavender,
        'icon': Icons.equalizer
      },
      {'name': 'Jazz', 'color': AppColors.accentYellow, 'icon': Icons.piano},
      {'name': 'Indie', 'color': AppColors.accentIndie, 'icon': Icons.park},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Browse Genres',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              Text(
                'See All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: genres.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = genres[index];
              return _GenreItem(
                name: item['name'] as String,
                color: item['color'] as Color,
                icon: item['icon'] as IconData,
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GenreItem extends StatefulWidget {
  final String name;
  final Color color;
  final IconData icon;
  final int index;

  const _GenreItem({
    required this.name,
    required this.color,
    required this.icon,
    required this.index,
  });

  @override
  State<_GenreItem> createState() => _GenreItemState();
}

class _GenreItemState extends State<_GenreItem> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GenreDetailScreen(
              genreName: widget.name,
              genreColor: widget.color,
              genreIcon: widget.icon,
            ),
          ),
        );
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 300 + (widget.index * 80)),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Column(
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.4),
                  shape: BoxShape.circle,
                  boxShadow: _isPressed
                      ? [
                          BoxShadow(
                            color: widget.color.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  widget.icon,
                  color: AppColors.textMain,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textMain,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _DailyMixSection extends StatelessWidget {
  const _DailyMixSection();

  @override
  Widget build(BuildContext context) {
    final mixes = [
      {
        'title': 'Morning Coffee',
        'subtitle': 'Soft acoustics & jazz',
        'image': 'https://picsum.photos/id/10/300/300'
      },
      {
        'title': 'Neon Drive',
        'subtitle': 'Synthwave mix',
        'image': 'https://picsum.photos/id/15/300/300'
      },
      {
        'title': 'Study Session',
        'subtitle': 'Deep focus beats',
        'image': 'https://picsum.photos/id/20/300/300'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Daily Mix',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: mixes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              final item = mixes[index];
              return _DailyMixCard(
                title: item['title']!,
                subtitle: item['subtitle']!,
                imageUrl: item['image']!,
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DailyMixCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final int index;

  const _DailyMixCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.index,
  });

  @override
  State<_DailyMixCard> createState() => _DailyMixCardState();
}

class _DailyMixCardState extends State<_DailyMixCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (widget.index * 100)),
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
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {},
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Hero(
                    tag: 'daily_mix_${widget.index}',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(widget.imageUrl),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(_isPressed ? 0.05 : 0.1),
                            blurRadius: _isPressed ? 5 : 10,
                            offset: Offset(0, _isPressed ? 2 : 5),
                          )
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}