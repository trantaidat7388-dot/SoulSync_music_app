import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../screens/now_playing_screen.dart';

class DynamicIslandPlayer extends StatefulWidget {
  const DynamicIslandPlayer({super.key});

  @override
  State<DynamicIslandPlayer> createState() => _DynamicIslandPlayerState();
}

class _DynamicIslandPlayerState extends State<DynamicIslandPlayer>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isPlaying = true;
  bool _isShuffled = false;
  bool _isLiked = false;
  int _repeatMode = 0; // 0: off, 1: repeat all, 2: repeat one
  double _progress = 0.35; // 35% progress (01:02 of 03:08)
  double _volume = 0.7;
  Timer? _progressTimer;
  
  // Sample track data
  final String _currentTrack = 'Lag Lag';
  final String _currentArtist = 'Quang Hùng MasterD';
  final String _albumArt = 'https://lh3.googleusercontent.com/aida-public/AB6AXuD9fxCh6ix0aWLgour1YPDsqEAdkSI_q85A_PQ-r-IpV15bFAnCSroUA2hJvtpfEecrMtv6AED61ldXvgn4uH-IiRnElltY4h_YrxbBlPx3BnrGwXGEC9aE1okxT9imLOMmawLxC-IYRS_ABtMvc3IXv7FwqF2kmLHHLjcq9SxUET6r8oSBK48CJcInyPnZPeWVO9owgW3QrGXXfzWiJtRErdJyzR2cQ_vRGO1JqxYeoT2y70dxJyRIhCrL-u-OB3Ed4A9wPIaxQw';

  late AnimationController _animationController;
  late AnimationController _waveAnimationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _contentAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _waveAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    _contentAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );

    _startProgressTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _waveAnimationController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    if (_isPlaying) {
      _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_isPlaying && mounted) {
          setState(() {
            _progress += 0.0053;
            if (_progress >= 1.0) {
              _progress = 0.0;
            }
          });
        }
      });
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      _startProgressTimer();
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isLiked ? '❤️ Added to Liked Songs' : '💔 Removed from Liked Songs'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: _isLiked ? AppColors.primary : Colors.grey.shade700,
      ),
    );
  }

  void _toggleShuffle() {
    setState(() {
      _isShuffled = !_isShuffled;
    });
  }

  void _toggleRepeat() {
    setState(() {
      _repeatMode = (_repeatMode + 1) % 3;
    });
  }

  void _skipPrevious() {
    setState(() {
      _progress = 0.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⏮️ Previous track'),
        duration: Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _skipNext() {
    setState(() {
      _progress = 0.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⏭️ Next track'),
        duration: Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openNowPlaying() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const NowPlayingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
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
  }

  String _formatDuration(double progress, int totalSeconds) {
    final currentSeconds = (progress * totalSeconds).round();
    final minutes = currentSeconds ~/ 60;
    final seconds = currentSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    
    return Stack(
      children: [
        if (_isExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleExpanded,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        
        Positioned(
          top: safeAreaTop + 8,
          left: _isExpanded ? 16 : screenWidth / 2 - 100,
          right: _isExpanded ? 16 : null,
          child: GestureDetector(
            onTap: () {
              if (!_isExpanded) {
                _toggleExpanded();
              }
            },
            onLongPress: _toggleExpanded,
            child: AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, child) {
                final width = _isExpanded ? null : 200.0;
                final height = 46.0 + (_expandAnimation.value * 166.0);
                final borderRadius = 20.0;

                return Container(
                  width: width,
                  height: height,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: _isExpanded ? _buildExpandedView() : _buildCompactView(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Hero(
            tag: 'album_art_hero',
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColors.primary.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  _albumArt,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.music_note_rounded,
                      color: AppColors.primary,
                      size: 16,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentTrack,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  _currentArtist,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 9,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 24,
            height: 24,
            child: _buildWaveform(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedView() {
    return AnimatedBuilder(
      animation: _contentAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _contentAnimation.value,
          child: Transform.scale(
            scale: 0.9 + (_contentAnimation.value * 0.1),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: _openNowPlaying,
                          child: Hero(
                            tag: 'album_art_hero',
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  _albumArt,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppColors.primary.withOpacity(0.2),
                                      child: const Icon(
                                        Icons.album_rounded,
                                        color: AppColors.primary,
                                        size: 28,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: _openNowPlaying,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _currentTrack,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _currentArtist,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggleLike,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _isLiked 
                                  ? AppColors.primary.withOpacity(0.2)
                                  : Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                              color: _isLiked ? AppColors.primary : Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: Colors.white.withOpacity(0.2),
                            thumbColor: Colors.white,
                            overlayColor: AppColors.primary.withOpacity(0.2),
                          ),
                          child: Slider(
                            value: _progress,
                            onChanged: (value) {
                              setState(() {
                                _progress = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(_progress, 188),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '3:08',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildControlButton(
                          _isShuffled ? Icons.shuffle_on_rounded : Icons.shuffle_rounded,
                          _toggleShuffle,
                          size: 20,
                          isActive: _isShuffled,
                        ),
                        _buildControlButton(
                          Icons.skip_previous_rounded,
                          _skipPrevious,
                          size: 28,
                        ),
                        _buildControlButton(
                          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          _togglePlayPause,
                          size: 32,
                          isPrimary: true,
                        ),
                        _buildControlButton(
                          Icons.skip_next_rounded,
                          _skipNext,
                          size: 28,
                        ),
                        _buildControlButton(
                          _repeatMode == 0 
                              ? Icons.repeat_rounded
                              : _repeatMode == 1
                                  ? Icons.repeat_on_rounded
                                  : Icons.repeat_one_rounded,
                          _toggleRepeat,
                          size: 20,
                          isActive: _repeatMode > 0,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.volume_down_rounded,
                          color: Colors.white.withOpacity(0.6),
                          size: 20,
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 2,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor: Colors.white.withOpacity(0.2),
                              thumbColor: Colors.white,
                            ),
                            child: Slider(
                              value: _volume,
                              onChanged: (value) {
                                setState(() {
                                  _volume = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Icon(
                          Icons.volume_up_rounded,
                          color: Colors.white.withOpacity(0.6),
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButton(
    IconData icon,
    VoidCallback onPressed, {
    double size = 22,
    bool isPrimary = false,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isPrimary ? 56 : 44,
        height: isPrimary ? 56 : 44,
        decoration: BoxDecoration(
          color: isPrimary
              ? Colors.white
              : isActive
                  ? AppColors.primary.withOpacity(0.25)
                  : Colors.transparent,
          shape: BoxShape.circle,
          border: isActive && !isPrimary
              ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 1)
              : null,
        ),
        child: Icon(
          icon,
          color: isPrimary 
              ? Colors.black 
              : isActive 
                  ? AppColors.primary 
                  : Colors.white,
          size: size,
        ),
      ),
    );
  }

  Widget _buildWaveform() {
    return AnimatedBuilder(
      animation: _waveAnimationController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final baseHeight = 4.0;
            final maxHeight = 16.0;
            final animValue = _waveAnimationController.value;
            
            double height = baseHeight;
            if (_isPlaying) {
              if (index == 0) {
                height = baseHeight + (maxHeight - baseHeight) * animValue;
              } else if (index == 1) {
                height = baseHeight + (maxHeight - baseHeight) * (1 - animValue);
              } else {
                height = baseHeight + (maxHeight - baseHeight) * animValue;
              }
            }
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              width: 3,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
                boxShadow: _isPlaying ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ] : null,
              ),
            );
          }),
        );
      },
    );
  }
}
