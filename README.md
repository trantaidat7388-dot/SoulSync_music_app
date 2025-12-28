# 🎵 SoulSync Music App

Ứng dụng nghe nhạc hiện đại với Flutter - Giao diện đẹp, tính năng đầy đủ như Spotify, Apple Music.

## ✨ Tính năng

- 🎨 Material 3 Design với animations mượt mà
- 🤖 AI Chat Bot trợ lý âm nhạc
- 🎚️ Equalizer 8 bands với 8 presets
- 📊 Audio Visualizer (4 kiểu: Bars, Wave, Circle, Particles)
- ⏰ Sleep Timer với fade out
- 📝 Lyrics display với auto-scroll
- 📥 Downloads management
- 🔄 Queue management với drag & drop
- 🌙 Dark/Light mode
- 🌍 Multi-language support
- 🎭 20+ screens đầy đủ tính năng

## 📋 Yêu cầu hệ thống

- Flutter SDK: `>= 3.0.0`
- Dart SDK: `>= 3.0.0`
- Android Studio / VS Code
- Android SDK với NDK 27.0.12077973 (cho Android)
- Xcode (cho iOS/macOS)

## 🚀 Cài đặt & Chạy

### 1️⃣ Clone dự án

```bash
git clone <repository-url>
cd SoulSync_music_app
```

### 2️⃣ Cài đặt dependencies

```bash
flutter pub get
```

### 3️⃣ Chạy ứng dụng

**Chạy trên thiết bị/emulator:**
```bash
flutter run
```

**Chọn thiết bị cụ thể:**
```bash
# Liệt kê devices
flutter devices

# Chạy trên device cụ thể
flutter run -d <device-id>
```

**Build APK (Android):**
```bash
flutter build apk --release
```

**Build iOS:**
```bash
flutter build ios --release
```

## 🛠️ Cấu trúc dự án

```
lib/
├── main.dart                 # Entry point
├── screens/                  # 20 màn hình
│   ├── onboarding_screen.dart
│   ├── home_screen.dart
│   ├── search_screen.dart
│   ├── library_screen.dart
│   ├── profile_screen.dart
│   ├── now_playing_screen.dart
│   ├── chat_bot_screen.dart
│   ├── settings_screen.dart
│   ├── equalizer_screen.dart
│   ├── audio_visualizer_screen.dart
│   └── ... (11+ screens khác)
├── widgets/                  # Reusable widgets
│   ├── mini_player.dart
│   ├── draggable_chat_bot.dart
│   ├── share_widgets.dart
│   └── song_options_bottom_sheet.dart
└── theme/                    # Theme & colors
    └── colors.dart
```

## 📦 Dependencies chính

- `google_fonts: ^6.2.1` - Font Plus Jakarta Sans
- Material 3 Design
- Flutter SDK built-in packages

## 🎨 Theme & Colors

Ứng dụng sử dụng warm color palette:
- **Primary:** `#E48744` (Warm orange)
- **Secondary:** `#F4D0B5` (Light peach)
- **Background Light:** `#FFF8F0` (Warm cream)

## 📱 Màn hình chính

1. **Onboarding** - Giới thiệu app
2. **Home** - Trang chủ với playlists, genres
3. **Search** - Tìm kiếm nhạc
4. **Library** - Thư viện cá nhân
5. **Profile** - Hồ sơ & settings
6. **Now Playing** - Màn hình phát nhạc
7. **Chat Bot** - AI trợ lý âm nhạc
8. **Equalizer** - Điều chỉnh âm thanh
9. **Audio Visualizer** - Trực quan hóa
10. **Settings** - Cài đặt app
11. **Queue** - Hàng đợi phát nhạc
12. **Lyrics** - Lời bài hát
13. **Downloads** - Quản lý tải xuống
14. **Recently Played** - Lịch sử nghe
15. **Sleep Timer** - Hẹn giờ tắt
16. **Artist Detail** - Chi tiết nghệ sĩ
17. **Genre Detail** - Chi tiết thể loại
18. **Playlist Detail** - Chi tiết playlist

## ⚠️ Lưu ý khi setup

### Android

Nếu gặp lỗi NDK version:
```kotlin
// android/app/build.gradle.kts
android {
    ndkVersion = "27.0.12077973"
}
```

### iOS/macOS

Chạy pod install nếu cần:
```bash
cd ios
pod install
cd ..
```

## 🐛 Troubleshooting

### Lỗi "Target of URI doesn't exist"

```bash
# Restart Dart Analysis Server
# VS Code: Ctrl+Shift+P → "Dart: Restart Analysis Server"

# Hoặc reload window
# VS Code: Ctrl+Shift+P → "Developer: Reload Window"
```

### Lỗi dependencies

```bash
# Clean và get lại packages
flutter clean
flutter pub get
```

### Lỗi build Android

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

## 📝 Git Workflow

**Những gì KHÔNG nên commit:**
- `.dart_tool/`
- `build/`
- `.flutter-plugins`
- `.flutter-plugins-dependencies`
- `.pub-cache/`
- Android/iOS build outputs

**Những gì NÊN commit:**
- `pubspec.yaml` ✅
- `pubspec.lock` ✅
- Source code `lib/` ✅
- Assets (nếu có)
- README.md ✅

## 🤝 Contributing

1. Fork dự án
2. Tạo branch mới (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Tạo Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**SoulSync Music App**
- Modern Flutter music application
- Material 3 Design
- Full-featured like Spotify & Apple Music

---

**⭐ Nếu thích project này, đừng quên star repo nhé! ⭐**
