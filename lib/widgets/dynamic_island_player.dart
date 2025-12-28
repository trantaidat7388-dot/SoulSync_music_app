import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../screens/now_playing_screen.dart';

class DynamicIslandPlayer extends StatefulWidget {
  const DynamicIslandPlayer({super.key});

  @override
  State<DynamicIslandPlayer> createState() => _DynamicIslandPlayerState();
}

class _DynamicIslandPlayerState extends State<DynamicIslandPlayer>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isPlaying = true;
  double _progress = 0.35; // 35% progress (01:02 of 03:08)
  
  // Sample track data
  final String _currentTrack = 'Lag Lag';
  final String _currentArtist = 'Quang Hùng MasterD';
  final String _albumArt = 'https://lh3.googleusercontent.com/aida-public/AB6AXuD9fxCh6ix0aWLgour1YPDsqEAdkSI_q85A_PQ-r-IpV15bFAnCSroUA2hJvtpfEecrMtv6AED61ldXvgn4uH-IiRnElltY4h_YrxbBlPx3BnrGwXGEC9aE1okxT9imLOMmawLxC-IYRS_ABtMvc3IXv7FwqF2kmLHHLjcq9SxUET6r8oSBK48CJcInyPnZPeWVO9owgW3QrGXXfzWiJtRErdJyzR2cQ_vRGO1JqxYeoT2y70dxJyRIhCrL-u-OB3Ed4A9wPIaxQw';

  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _contentAnimation;
  
  // Playlist thumbnails
  final List<String> _playlistThumbs = [
    'https://picsum.photos/id/10/100/100',
    'https://picsum.photos/id/20/100/100',
    'https://picsum.photos/id/30/100/100',
    'https://picsum.photos/id/40/100/100',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Background expand animation (chạy từ 0 -> 1.0)
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    // Content fade-in animation (chạy từ 0.4 -> 1.0, sau khi background expand)
    _contentAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    
    return Stack(
      children: [
        // Backdrop to detect taps outside
        if (_isExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleExpanded,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        
        // Dynamic Island Player
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
          // Album art
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColors.primary.withOpacity(0.2),
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
          const SizedBox(width: 8),
          
          // Track info
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
          
          // Waveform animation
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with album art, title and Spotify icon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Album art
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
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
                      const SizedBox(width: 12),
                      // Track info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentTrack,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Spotify icon
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1DB954),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.music_note_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Progress bar
                  Column(
                    children: [
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white.withOpacity(0.3),
                          thumbColor: Colors.white,
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
                              '01:02',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              '03:08',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildControlButton(
                        Icons.cast_rounded,
                        () {},
                        size: 22,
                      ),
                      _buildControlButton(
                        Icons.skip_previous_rounded,
                        () {},
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
                        () {},
                        size: 28,
                      ),
                      _buildControlButton(
                        Icons.add_circle_outline_rounded,
                        () {},
                        size: 22,
                      ),
                    ],
                  ),
                ],
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
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: isPrimary ? 56 : 48,
        height: isPrimary ? 56 : 48,
        decoration: BoxDecoration(
          color: isPrimary
              ? Colors.white
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isPrimary ? Colors.black : Colors.white,
          size: size,
        ),
      ),
    );
  }

  Widget _buildWaveform() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          margin: const EdgeInsets.symmetric(horizontal: 1),
          width: 3,
          height: _isPlaying ? (12.0 + (index % 2) * 8) : 4,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
