import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/app_language.dart';
import 'settings_screen.dart';
import 'downloads_screen.dart';
import 'chat_bot_screen.dart';
import 'help_support_screen.dart';
import 'edit_profile_screen.dart';
import 'my_songs_screen.dart';
import 'my_playlists_screen.dart';
import 'my_favorites_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AppLanguage _appLanguage = AppLanguage();

  @override
  void initState() {
    super.initState();
    _appLanguage.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _appLanguage.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColors.backgroundLight,
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
                children: [
                  const _Header(),
                  const SizedBox(height: 24),
                  const _ProfileCard(),
                  const SizedBox(height: 32),
                  _StatsSection(),
                  const SizedBox(height: 32),
                  const _SettingsSection(),
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

class _Header extends StatefulWidget {
  const _Header();

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  final AppLanguage _appLanguage = AppLanguage();

  @override
  void initState() {
    super.initState();
    _appLanguage.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _appLanguage.translate('profile'),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.textMain,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatefulWidget {
  const _ProfileCard();

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  final AppLanguage _appLanguage = AppLanguage();

  @override
  void initState() {
    super.initState();
    _appLanguage.addListener(() => setState(() {}));
  }

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
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Change Profile Picture',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildChangeAvatarOption(
                          Icons.camera_alt_rounded,
                          'Take Photo',
                          () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Camera feature coming soon!'),
                                backgroundColor: AppColors.primary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildChangeAvatarOption(
                          Icons.photo_library_rounded,
                          'Choose from Gallery',
                          () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Gallery feature coming soon!'),
                                backgroundColor: AppColors.primary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildChangeAvatarOption(
                          Icons.delete_outline_rounded,
                          'Remove Photo',
                          () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Photo removed!'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              },
              child: Stack(
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
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Alex Morgan',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _appLanguage.translate('premium_member'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeAvatarOption(IconData icon, String label, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textMain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsSection extends StatefulWidget {

  @override
  State<_StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends State<_StatsSection> {
  final AppLanguage _appLanguage = AppLanguage();

  @override
  void initState() {
    super.initState();
    _appLanguage.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MySongsScreen()),
                );
              },
              child: _StatCard(
                icon: Icons.music_note_rounded,
                value: '142',
                label: _appLanguage.translate('songs'),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyPlaylistsScreen()),
                );
              },
              child: _StatCard(
                icon: Icons.playlist_play_rounded,
                value: '23',
                label: _appLanguage.translate('playlists'),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyFavoritesScreen()),
                );
              },
              child: _StatCard(
                icon: Icons.favorite_rounded,
                value: '89',
                label: _appLanguage.translate('favorites'),
              ),
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

class _SettingsSection extends StatefulWidget {
  const _SettingsSection();

  @override
  State<_SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<_SettingsSection> {
  final AppLanguage _appLanguage = AppLanguage();

  @override
  void initState() {
    super.initState();
    _appLanguage.addListener(() => setState(() {}));
  }

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
              title: _appLanguage.translate('notifications'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                thumbColor: WidgetStateProperty.all(AppColors.primary),
              ),
            ),
            const Divider(height: 1),
            _SettingItem(
              icon: Icons.download_outlined,
              title: _appLanguage.translate('downloaded_songs'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DownloadsScreen()),
                );
              },
            ),
            const Divider(height: 1),
            _SettingItem(
              icon: Icons.data_usage_rounded,
              title: _appLanguage.translate('data_usage'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                _showDataUsageDialog(context);
              },
            ),
            const Divider(height: 1),
            _SettingItem(
              icon: Icons.dark_mode_outlined,
              title: _appLanguage.translate('dark_mode'),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
                thumbColor: WidgetStateProperty.all(AppColors.primary),
              ),
            ),
            const Divider(height: 1),
            _SettingItem(
              icon: Icons.language_rounded,
              title: _appLanguage.translate('language'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                _showLanguageDialog(context, () {
                  setState(() {}); // Refresh UI when language changes
                });
              },
            ),
            const Divider(height: 1),
            _SettingItem(
              icon: Icons.smart_toy_rounded,
              title: _appLanguage.translate('ai_assistant'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatBotScreen()),
                );
              },
            ),
            const Divider(height: 1),
            _SettingItem(
              icon: Icons.help_outline_rounded,
              title: _appLanguage.translate('help_support'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                );
              },
            ),
            const Divider(height: 1),
            _SettingItem(
              icon: Icons.info_outline_rounded,
              title: _appLanguage.translate('about'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                _showAboutDialog(context);
              },
            ),
            const Divider(height: 1),
            _SettingItem(
              icon: Icons.logout_rounded,
              title: _appLanguage.translate('logout'),
              trailing: const Icon(Icons.chevron_right_rounded),
              textColor: Colors.red,
              onTap: () {
                _showLogoutDialog(context);
              },
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
  final VoidCallback? onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.trailing,
    this.textColor,
    this.onTap,
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
      onTap: onTap,
    );
  }
}

// Dialog Functions
void _showDataUsageDialog(BuildContext context) {
  final AppLanguage appLanguage = AppLanguage();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        appLanguage.translate('data_usage'),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DataUsageItem(appLanguage.translate('streaming'), '2.4 GB', Icons.wifi_rounded),
          const SizedBox(height: 12),
          _DataUsageItem(appLanguage.translate('downloads'), '1.8 GB', Icons.download_rounded),
          const SizedBox(height: 12),
          _DataUsageItem(appLanguage.translate('cache'), '456 MB', Icons.cached_rounded),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appLanguage.translate('total_usage'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Text(
                '4.7 GB',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(appLanguage.translate('close')),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(appLanguage.translate('cache_cleared'))),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(appLanguage.translate('clear_cache')),
        ),
      ],
    ),
  );
}

void _showLanguageDialog(BuildContext context, Function() onLanguageChanged) {
  final AppLanguage appLanguage = AppLanguage();
  final languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    {'code': 'vi', 'name': 'Tiếng Việt', 'flag': '🇻🇳'},
  ];
  
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            appLanguage.translate('select_language'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: languages.map((language) {
                final isSelected = appLanguage.currentLanguage == language['code'];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.primary.withOpacity(0.1) 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? AppColors.primary 
                          : Colors.grey.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    leading: Text(
                      language['flag'] as String,
                      style: const TextStyle(fontSize: 28),
                    ),
                    title: Text(
                      language['name'] as String,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.primary : AppColors.textMain,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppColors.primary)
                        : null,
                    onTap: () {
                      // Thay đổi ngôn ngữ
                      appLanguage.setLanguage(language['code'] as String);
                      onLanguageChanged();
                      Navigator.pop(context);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${appLanguage.translate('language_changed')} ${language['name']}',
                          ),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  },
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(appLanguage.translate('cancel')),
          ),
        ],
      );
      },
    ),
  );
}

void _showAboutDialog(BuildContext context) {
  final AppLanguage appLanguage = AppLanguage();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        appLanguage.translate('about_soulsync'),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.music_note_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'SoulSync',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            appLanguage.translate('version'),
            style: const TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          Text(
            appLanguage.translate('music_companion'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          Text(
            appLanguage.translate('copyright'),
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(appLanguage.translate('close')),
        ),
      ],
    ),
  );
}

void _showLogoutDialog(BuildContext context) {
  final AppLanguage appLanguage = AppLanguage();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        appLanguage.translate('logout'),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(appLanguage.translate('logout_confirm')),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(appLanguage.translate('cancel')),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(appLanguage.translate('logout')),
        ),
      ],
    ),
  );
}

class _DataUsageItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DataUsageItem(this.title, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
          ),
        ),
      ],
    );
  }
}

