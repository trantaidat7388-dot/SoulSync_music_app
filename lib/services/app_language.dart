import 'package:flutter/material.dart';

class AppLanguage extends ChangeNotifier {
  static final AppLanguage _instance = AppLanguage._internal();
  factory AppLanguage() => _instance;
  AppLanguage._internal();

  String _currentLanguage = 'en'; // 'en' or 'vi'

  String get currentLanguage => _currentLanguage;

  void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
    notifyListeners();
  }

  // Translations
  static final Map<String, Map<String, String>> _translations = {
    // Profile Screen
    'profile': {'en': 'Profile', 'vi': 'Hồ Sơ'},
    'edit_profile': {'en': 'Edit Profile', 'vi': 'Chỉnh Sửa Hồ Sơ'},
    'songs': {'en': 'Songs', 'vi': 'Bài Hát'},
    'playlists': {'en': 'Playlists', 'vi': 'Danh Sách Phát'},
    'favorites': {'en': 'Favorites', 'vi': 'Yêu Thích'},
    'notifications': {'en': 'Notifications', 'vi': 'Thông Báo'},
    'downloaded_songs': {'en': 'Downloaded Songs', 'vi': 'Bài Hát Đã Tải'},
    'data_usage': {'en': 'Data Usage', 'vi': 'Dung Lượng Dữ Liệu'},
    'dark_mode': {'en': 'Dark Mode', 'vi': 'Chế Độ Tối'},
    'language': {'en': 'Language', 'vi': 'Ngôn Ngữ'},
    'ai_assistant': {'en': 'AI Assistant', 'vi': 'Trợ Lý AI'},
    'help_support': {'en': 'Help & Support', 'vi': 'Trợ Giúp & Hỗ Trợ'},
    'about': {'en': 'About', 'vi': 'Giới Thiệu'},
    'logout': {'en': 'Logout', 'vi': 'Đăng Xuất'},
    
    // Dialog titles
    'select_language': {'en': 'Select Language', 'vi': 'Chọn Ngôn Ngữ'},
    'cancel': {'en': 'Cancel', 'vi': 'Hủy'},
    'save': {'en': 'Save', 'vi': 'Lưu'},
    'close': {'en': 'Close', 'vi': 'Đóng'},
    
    // Edit Profile
    'name': {'en': 'Name', 'vi': 'Tên'},
    'email': {'en': 'Email', 'vi': 'Email'},
    'profile_updated': {'en': 'Profile updated successfully', 'vi': 'Cập nhật hồ sơ thành công'},
    
    // Data Usage
    'streaming': {'en': 'Streaming', 'vi': 'Phát Trực Tuyến'},
    'downloads': {'en': 'Downloads', 'vi': 'Tải Xuống'},
    'cache': {'en': 'Cache', 'vi': 'Bộ Nhớ Đệm'},
    'total_usage': {'en': 'Total Usage', 'vi': 'Tổng Sử Dụng'},
    'clear_cache': {'en': 'Clear Cache', 'vi': 'Xóa Bộ Nhớ Đệm'},
    'cache_cleared': {'en': 'Cache cleared successfully', 'vi': 'Đã xóa bộ nhớ đệm thành công'},
    
    // Language change
    'language_changed': {'en': 'Language changed to', 'vi': 'Đã chuyển ngôn ngữ sang'},
    'english': {'en': 'English', 'vi': 'Tiếng Anh'},
    'vietnamese': {'en': 'Tiếng Việt', 'vi': 'Tiếng Việt'},
    
    // Help & Support
    'faq': {'en': 'FAQ', 'vi': 'Câu Hỏi Thường Gặp'},
    'contact_support': {'en': 'Contact Support', 'vi': 'Liên Hệ Hỗ Trợ'},
    'report_bug': {'en': 'Report a Bug', 'vi': 'Báo Lỗi'},
    'send_feedback': {'en': 'Send Feedback', 'vi': 'Gửi Phản Hồi'},
    'opening': {'en': 'Opening', 'vi': 'Đang mở'},
    
    // About
    'about_soulsync': {'en': 'About SoulSync', 'vi': 'Giới Thiệu SoulSync'},
    'version': {'en': 'Version 1.0.0', 'vi': 'Phiên bản 1.0.0'},
    'music_companion': {'en': 'Your personal music streaming companion', 'vi': 'Người bạn đồng hành âm nhạc của bạn'},
    'copyright': {'en': '© 2025 SoulSync. All rights reserved.', 'vi': '© 2025 SoulSync. Bảo lưu mọi quyền.'},
    
    // Logout
    'logout_confirm': {'en': 'Are you sure you want to logout?', 'vi': 'Bạn có chắc chắn muốn đăng xuất?'},
  };

  String translate(String key) {
    return _translations[key]?[_currentLanguage] ?? key;
  }

  String get(String key) => translate(key);
}
