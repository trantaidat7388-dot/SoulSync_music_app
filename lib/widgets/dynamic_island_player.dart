import 'package:flutter/material.dart';
import '../theme/colors.dart';

class DynamicIslandPlayer extends StatefulWidget {
  const DynamicIslandPlayer({super.key});

  @override
  State<DynamicIslandPlayer> createState() => _DynamicIslandPlayerState();
}

class _DynamicIslandPlayerState extends State<DynamicIslandPlayer>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isPlaying = false;
  Offset _position = const Offset(20, 50);
  
  // Sample track data - will be replaced with real player state
  final String _currentTrack = 'Beautiful Things';
  final String _currentArtist = 'Benson Boone';
  final String _albumArt = 'https://via.placeholder.com/150';

  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<BorderRadius?> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    _borderAnimation = BorderRadiusTween(
      begin: BorderRadius.circular(40),
      end: BorderRadius.circular(20),
    ).animate(_expandAnimation);
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
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (!_isExpanded) {
            setState(() {
              _position = Offset(
                (_position.dx + details.delta.dx).clamp(
                  0,
                  MediaQuery.of(context).size.width - (_isExpanded ? 320 : 180),
                ),
                (_position.dy + details.delta.dy).clamp(
                  0,
                  MediaQuery.of(context).size.height - (_isExpanded ? 180 : 80),
                ),
              );
            });
          }
        },
        child: AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            final width = _isExpanded
                ? 320.0
                : 180.0 + (_expandAnimation.value * 140);
            final height = _isExpanded
                ? 180.0
                : 60.0 + (_expandAnimation.value * 120);

            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: _borderAnimation.value,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _toggleExpanded,
                  borderRadius: _borderAnimation.value,
                  child: _isExpanded ? _buildExpandedView() : _buildCompactView(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompactView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Album art
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.primary.withOpacity(0.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _albumArt,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.music_note_rounded,
                    color: AppColors.primary,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentTrack,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _currentArtist,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11,
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Now Playing',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: _toggleExpanded,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          
          const Spacer(),
          
          // Album art and info
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _albumArt,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.primary.withOpacity(0.2),
                        child: const Icon(
                          Icons.album_rounded,
                          color: AppColors.primary,
                          size: 35,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentArtist,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.4,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 3,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                Icons.skip_previous_rounded,
                () {},
                size: 28,
              ),
              _buildControlButton(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                _togglePlayPause,
                size: 36,
                isPrimary: true,
              ),
              _buildControlButton(
                Icons.skip_next_rounded,
                () {},
                size: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    IconData icon,
    VoidCallback onPressed, {
    double size = 24,
    bool isPrimary = false,
  }) {
    return Container(
      width: isPrimary ? 56 : 44,
      height: isPrimary ? 56 : 44,
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.primary
            : Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        iconSize: size,
        onPressed: onPressed,
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
