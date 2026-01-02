# 🎯 Checklist tích hợp Firebase

Làm theo thứ tự này để setup Firebase cho SoulSync Music App:

## ✅ Bước 1: Cài đặt Firebase Console (15 phút)

- [ ] Tạo Firebase project tại https://console.firebase.google.com/
- [ ] Enable Authentication → Email/Password
- [ ] Tạo Firestore Database (test mode)
- [ ] Enable Storage

## ✅ Bước 2: FlutterFire CLI (5 phút) - RECOMMENDED

```bash
# Cài đặt
dart pub global activate flutterfire_cli

# Login Firebase
firebase login

# Configure project
cd d:\SoulSync_music_app
flutterfire configure
```

**Hoặc** làm thủ công (Bước 3-5):

## ✅ Bước 3: Android Configuration (10 phút)

- [ ] Thêm Android app trong Firebase Console
- [ ] Download `google-services.json` → `android/app/`
- [ ] Cập nhật `android/build.gradle.kts`:
  ```kotlin
  classpath("com.google.gms:google-services:4.4.2")
  ```
- [ ] Cập nhật `android/app/build.gradle.kts`:
  ```kotlin
  id("com.google.gms.google-services")
  minSdk = 23
  multiDexEnabled = true
  ```

## ✅ Bước 4: iOS Configuration (10 phút)

- [ ] Thêm iOS app trong Firebase Console
- [ ] Download `GoogleService-Info.plist`
- [ ] Mở `ios/Runner.xcworkspace` trong Xcode
- [ ] Drag `GoogleService-Info.plist` vào Runner folder
- [ ] Update `ios/Podfile` (platform :ios, '13.0')
- [ ] Run: `cd ios && pod install`

## ✅ Bước 5: Flutter Code (DONE ✅)

Các file đã được tạo/cập nhật:

- [x] `lib/firebase_options.dart` ← Cần generate với FlutterFire CLI
- [x] `lib/services/firebase_service.dart`
- [x] `lib/main.dart` (thêm Firebase.initializeApp)
- [x] `lib/screens/login_screen.dart` (tích hợp Firebase)
- [x] `lib/screens/register_screen.dart` (tích hợp Firebase)
- [x] `lib/screens/forgot_password_screen.dart` (tích hợp Firebase)

## ✅ Bước 6: Security Rules

### Firestore Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /playlists/{playlistId} {
      allow read: if resource.data.isPublic == true 
                  || request.auth.uid == resource.data.userId;
      allow write: if request.auth.uid == resource.data.userId;
    }
  }
}
```

Copy vào: Firebase Console → Firestore Database → Rules

### Storage Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

Copy vào: Firebase Console → Storage → Rules

## ✅ Bước 7: Test

```bash
# Clean và rebuild
flutter clean
flutter pub get

# Chạy app
flutter run

# Test các tính năng:
- [ ] Đăng ký tài khoản mới
- [ ] Đăng nhập
- [ ] Forgot password (check email)
- [ ] Add to favorites
- [ ] Create playlist
- [ ] Logout
```

## ✅ Bước 8: Gitignore

Add vào `.gitignore`:

```
# Firebase
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
ios/firebase_app_id_file.json
lib/firebase_options.dart
```

## 🆘 Troubleshooting

### Lỗi: firebase_core not found
```bash
flutter pub get
```

### Lỗi: Google Services plugin
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Lỗi: Pod install failed (iOS)
```bash
cd ios
pod deintegrate
pod install
```

### Lỗi: Multidex
Đảm bảo đã thêm vào `android/app/build.gradle.kts`:
```kotlin
multiDexEnabled = true
```

## 📚 Tài liệu tham khảo

- [FIREBASE_SETUP_GUIDE.md](FIREBASE_SETUP_GUIDE.md) - Hướng dẫn chi tiết
- [FLUTTERFIRE_CLI_GUIDE.md](FLUTTERFIRE_CLI_GUIDE.md) - Sử dụng FlutterFire CLI
- [FIREBASE_USAGE_GUIDE.md](FIREBASE_USAGE_GUIDE.md) - Code examples
- [FlutterFire Docs](https://firebase.flutter.dev/)

## 🎉 Hoàn thành!

Khi tất cả checkbox được check ✅, Firebase đã được tích hợp thành công!

Bạn có thể:
- 🔐 Đăng ký/Đăng nhập users
- 💾 Lưu user data vào Firestore
- ❤️ Quản lý favorites
- 🎵 Tạo và quản lý playlists
- 🕒 Track recently played
- 👤 Update user profiles
