import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../screens/now_playing_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NowPlayingScreen()),
        );
      },
      child: Container(
        height: 72,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Progress bar at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.35,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Album Art
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                      image: const DecorationImage(
                        image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuD9fxCh6ix0aWLgour1YPDsqEAdkSI_q85A_PQ-r-IpV15bFAnCSroUA2hJvtpfEecrMtv6AED61ldXvgn4uH-IiRnElltY4h_YrxbBlPx3BnrGwXGEC9aE1okxT9imLOMmawLxC-IYRS_ABtMvc3IXv7FwqF2kmLHHLjcq9SxUET6r8oSBK48CJcInyPnZPeWVO9owgW3QrGXXfzWiJtRErdJyzR2cQ_vRGO1JqxYeoT2y70dxJyRIhCrL-u-OB3Ed4A9wPIaxQw'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Song Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Sunsets & Chill',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Lo-Fi Beats',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // Controls
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_border_rounded),
                        color: AppColors.textMuted,
                        iconSize: 22,
                      ),
                      const SizedBox(width: 4),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.pause_rounded),
                          color: Colors.white,
                          iconSize: 22,
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
    );
  }
}
