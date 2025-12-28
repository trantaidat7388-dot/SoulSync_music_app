import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'lyrics_screen.dart';
import 'queue_screen.dart';
import 'equalizer_screen.dart';
import 'audio_visualizer_screen.dart';
import '../widgets/share_widgets.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // Background Gradient Blur
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
                const _Header(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      child: Column(
                        children: const [
                          _AlbumArt(),
                          SizedBox(height: 24),
                          _TrackInfo(),
                          SizedBox(height: 32),
                          _ProgressBar(),
                          SizedBox(height: 40),
                          _PlaybackControls(),
                          SizedBox(height: 40),
                          _UpNextList(),
                          SizedBox(height: 24),
                          _DeviceSelector(),
                          SizedBox(height: 24),
                        ],
                      ),
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
        children: [
          _buildIconButton(Icons.keyboard_arrow_down_rounded, 28, () => Navigator.pop(context)),
          Column(
            children: [
              Text(
                'NOW PLAYING',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: AppColors.primary.withOpacity(0.8),
                ),
              ),
            ],
          ),
          _buildIconButton(Icons.more_horiz_rounded, 24, () {
            _showOptionsMenu(context);
          }),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.lyrics_rounded, color: AppColors.primary),
              title: const Text('Lyrics'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LyricsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.queue_music_rounded, color: AppColors.primary),
              title: const Text('Up Next'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QueueScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.equalizer_rounded, color: AppColors.primary),
              title: const Text('Equalizer'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EqualizerScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.graphic_eq_rounded, color: AppColors.primary),
              title: const Text('Visualizer'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AudioVisualizerScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.share_rounded, color: AppColors.primary),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => const ShareMusicWidget(
                    songTitle: 'Blinding Lights',
                    artistName: 'The Weeknd',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, double size, VoidCallback onPressed) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: size),
        color: AppColors.textMain,
        onPressed: onPressed,
      ),
    );
  }
}

class _AlbumArt extends StatelessWidget {
  const _AlbumArt();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Shadow/Glow
        Positioned(
          bottom: 0,
          left: 20,
          right: 20,
          top: 20,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
          ),
        ),
        
        // Main Image
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: AppColors.surfaceLight,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 40,
                  offset: const Offset(0, 10),
                ),
              ],
              image: const DecorationImage(
                image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuD9fxCh6ix0aWLgour1YPDsqEAdkSI_q85A_PQ-r-IpV15bFAnCSroUA2hJvtpfEecrMtv6AED61ldXvgn4uH-IiRnElltY4h_YrxbBlPx3BnrGwXGEC9aE1okxT9imLOMmawLxC-IYRS_ABtMvc3IXv7FwqF2kmLHHLjcq9SxUET6r8oSBK48CJcInyPnZPeWVO9owgW3QrGXXfzWiJtRErdJyzR2cQ_vRGO1JqxYeoT2y70dxJyRIhCrL-u-OB3Ed4A9wPIaxQw'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrackInfo extends StatelessWidget {
  const _TrackInfo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Sunsets & Chill',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                'Lo-Fi Beats',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.favorite_border_rounded, size: 28),
          color: AppColors.textMuted,
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.35,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                left: 100, // Approximate position for 35%
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.white,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(BorderSide(color: AppColors.primary, width: 2)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              '1:24',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
            Text(
              '3:45',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _PlaybackControls extends StatelessWidget {
  const _PlaybackControls();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.shuffle_rounded, size: 28),
          color: AppColors.textMuted,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.skip_previous_rounded, size: 40),
          color: AppColors.textMain,
        ),
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 30,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow_rounded, size: 44),
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.skip_next_rounded, size: 40),
          color: AppColors.textMain,
        ),
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.repeat_rounded, size: 28),
              color: AppColors.primary,
            ),
            const Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                radius: 3,
                backgroundColor: AppColors.primary,
              ),
            )
          ],
        ),
      ],
    );
  }
}

class _UpNextList extends StatelessWidget {
  const _UpNextList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Up Next',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'SEE ALL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildListItem(
          'Coffee Shop Vibes',
          'Jazz Collective',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD4zTvs1ZSng5Zs-6SN5e6BY4THURyLABqJuRzTseMfznR7cdc845lQnuxW_Byz_ueROCw2Hi8LXbQB_UR16NDwRAkvGIQGq4UYgSDdkZwtqAhbJSSR0LO4GYw1U9XAcqiEZUIrpVEOh07cioPqi1a42PawaVEWvSbkbqTmdUHo7oM-W1uR3o5oWQZPdph52lmM_rZAKUB2TtCdBP82GoLoClCKT7MmwfYAq0qdj7O6Unr5NCwYW8o4kMrGa1m_DtQjKdF2xDxXSw',
        ),
        const SizedBox(height: 12),
        _buildListItem(
          'Rainy Day Reading',
          'Acoustic Dreams',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAmtFifzozcQm7xAGiCL7_6Icz5OfmgQWrbVoM4jjIdaOwTrkGuVQBLHWYPVVl9KRG_eGN6qkbhIRxMzltH10xZUD1QvtBeAwFhEMq66Mk7TPZUgzzMy9oj9_OTYdmYXISguXLBSZp4MDLLhyrM7XuBFnhroFY7-npxaToy02371fr_CCidrCgPkI6CeLJPaz0JXvkLQR52PbbKa83XvoNM2l4F5Z0FYd3xtzsQF5Wj-ydFhTa2lHb92aaWFpkPlJAzR_1vTDVaVQ',
        ),
        const SizedBox(height: 12),
        _buildListItem(
          'Late Night Coding',
          'Synthwave Boy',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC0twC4bcYkDO_Ks18aY0qp5CTNDlfne1DHEy86WFtTl5AGTHEcFCOIBANtP_w1AmYviNfj9jrQ4svLAER01_WSQ9mTnYs4199WII8b2ASOEJp2SPHkjL88UbfbXPsHM85vqFl3uDkzkGQ6BvMzTbp6RqE0jWYOE2z7Ppsq_MfOCjK84lhjE0oBxxPbnnGLNw9WjIDH6fCXfMqWe43k0EmAHbLqNZXgLGDXaPXnk6QSWMI2rcRmPPHoavM7RqKKPYmpV4-2KLxUGg',
        ),
      ],
    );
  }

  Widget _buildListItem(String title, String artist, String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.drag_indicator_rounded, color: AppColors.textMuted, size: 20),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 48,
              width: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textMain,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  artist,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.remove_circle_outline_rounded, size: 20),
            color: AppColors.textMuted.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}

class _DeviceSelector extends StatelessWidget {
  const _DeviceSelector();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.speaker_group_outlined, color: AppColors.primary, size: 18),
          SizedBox(width: 8),
          Text(
            'AirPods Pro',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}