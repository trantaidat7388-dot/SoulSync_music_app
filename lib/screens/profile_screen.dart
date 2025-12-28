import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'settings_screen.dart';
import 'downloads_screen.dart';
import 'recently_played_screen.dart';
import 'sleep_timer_screen.dart';
import 'equalizer_screen.dart';
import 'chat_bot_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
            height: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: const [
                  _Header(),
                  SizedBox(height: 24),
                  _ProfileCard(),
                  SizedBox(height: 32),
                  _StatsSection(),
                  SizedBox(height: 32),
                  _SettingsSection(),
                  SizedBox(height: 24),
                ],
              ),
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
            'Profile',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          Icon(
            Icons.settings_outlined,
            color: AppColors.textMain,
            size: 28,
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  'https://i.pravatar.cc/150?img=32',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Alex Johnson',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'alex.johnson@email.com',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.music_note_rounded,
              value: '142',
              label: 'Songs',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StatCard(
              icon: Icons.playlist_play_rounded,
              value: '23',
              label: 'Playlists',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StatCard(
              icon: Icons.favorite_rounded,
              value: '89',
              label: 'Favorites',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _SettingItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeThumbColor: AppColors.primary,
              ),
            ),
            const Divider(height: 1),
            _SettingItem(
              icon: Icons.download_outlined,
              title: 'Downloaded Songs',
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
            const Divider(height: 1),
            _SettingItem(
              icon: Icons.data_usage_rounded,
              title: 'Data Usage',
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
            const Divider(height: 1),
            _SettingItem(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              trailing: Switch(
                value: false,
                onChanged: (value) {},
                activeThumbColor: AppColors.primary,
              ),
            ),
            const Divider(height: 1),
            _SettingItem(
              icon: Icons.language_rounded,
              title: 'Language',
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
            const Divider(height: 1),
            _SettingItem(
              icon: Icons.smart_toy_rounded,
              title: 'AI Assistant',
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
            const Divider(height: 1),
            _SettingItem(
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
            const Divider(height: 1),
            _SettingItem(
              icon: Icons.info_outline_rounded,
              title: 'About',
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
            const Divider(height: 1),
            _SettingItem(
              icon: Icons.logout_rounded,
              title: 'Logout',
              trailing: const Icon(Icons.chevron_right_rounded),
              textColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final Color? textColor;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.trailing,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(
        icon,
        color: textColor ?? AppColors.textMain,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor ?? AppColors.textMain,
        ),
      ),
      trailing: trailing,
      onTap: () {
        // Navigate based on title
        if (title == 'Settings') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        } else if (title == 'Downloads') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DownloadsScreen()),
          );
        } else if (title == 'Recently Played') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RecentlyPlayedScreen()),
          );
        } else if (title == 'Sleep Timer') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SleepTimerScreen()),
          );
        } else if (title == 'Equalizer') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EqualizerScreen()),
          );
        } else if (title == 'AI Assistant') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatBotScreen()),
          );
        }
      },
    );
  }
}
