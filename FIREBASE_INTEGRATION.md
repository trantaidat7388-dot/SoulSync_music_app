# 🔥 Firebase Integration - SoulSync Music App

## 📋 Tổng quan

Firebase đã được tích hợp vào SoulSync Music App với các tính năng:

- ✅ **Authentication**: Email/Password đăng ký, đăng nhập, reset password
- ✅ **Firestore Database**: Lưu trữ user profiles, playlists, favorites
- ✅ **Real-time Sync**: Tự động đồng bộ dữ liệu
- ✅ **Security**: Firestore rules bảo vệ dữ liệu người dùng

## 🚀 Quick Start

### Cách 1: FlutterFire CLI (Khuyến nghị - 5 phút)

```bash
# 1. Cài đặt FlutterFire CLI
dart pub global activate flutterfire_cli

# 2. Login Firebase
firebase login

# 3. Configure project
cd d:\SoulSync_music_app
flutterfire configure

# 4. Update Android build files (xem FLUTTERFIRE_CLI_GUIDE.md)

# 5. Chạy app
flutter clean
flutter pub get
flutter run
```

**📖 Chi tiết:** [FLUTTERFIRE_CLI_GUIDE.md](FLUTTERFIRE_CLI_GUIDE.md)

### Cách 2: Thủ công (30-40 phút)

Làm theo hướng dẫn chi tiết: [FIREBASE_SETUP_GUIDE.md](FIREBASE_SETUP_GUIDE.md)

### Checklist

Theo dõi tiến độ: [FIREBASE_CHECKLIST.md](FIREBASE_CHECKLIST.md)

## 📁 Files đã tạo/cập nhật

### ✅ Services
- `lib/services/firebase_service.dart` - Firebase service đầy đủ
  - Authentication (register, login, logout, reset password)
  - User profile management
  - Favorites management
  - Playlists CRUD
  - Recently played tracking
  - Artist following

### ✅ Screens (Đã tích hợp Firebase)
- `lib/screens/login_screen.dart` - Login với Firebase Auth
- `lib/screens/register_screen.dart` - Register với Firebase Auth
- `lib/screens/forgot_password_screen.dart` - Reset password

### ✅ Main App
- `lib/main.dart` - Firebase initialization, MultiProvider setup

### ✅ Configuration
- `lib/firebase_options.dart` - Firebase config (generate bằng FlutterFire CLI)

### ✅ Android Config (Templates)
- `android/app/build.gradle.kts.firebase` - Template
- `android/build.gradle.kts.firebase` - Template

### ✅ Documentation
- `FIREBASE_SETUP_GUIDE.md` - Hướng dẫn setup chi tiết
- `FLUTTERFIRE_CLI_GUIDE.md` - Hướng dẫn dùng FlutterFire CLI
- `FIREBASE_USAGE_GUIDE.md` - Code examples
- `FIREBASE_CHECKLIST.md` - Checklist theo dõi
- `FIREBASE_INTEGRATION.md` - File này

## 💻 Cách sử dụng trong code

### Authentication

```dart
// Get Firebase Service
final firebaseService = Provider.of<FirebaseService>(context, listen: false);

// Register
final error = await firebaseService.registerWithEmail(
  name: 'User Name',
  email: 'user@email.com',
  password: 'password',
);

// Login
final error = await firebaseService.loginWithEmail(
  email: 'user@email.com',
  password: 'password',
);

// Logout
await firebaseService.logout();
```

### Favorites

```dart
// Add to favorites
await firebaseService.addToFavorites(trackId);

// Check if favorite
bool isFav = firebaseService.isFavorite(trackId);

// Get all favorites
List<String> favs = firebaseService.getFavorites();
```

### Playlists

```dart
// Create playlist
await firebaseService.createPlaylist(
  name: 'My Playlist',
  description: 'Description',
);

// Get playlists (real-time)
StreamBuilder<QuerySnapshot>(
  stream: firebaseService.getUserPlaylists(),
  builder: (context, snapshot) {
    // Build UI
  },
);
```

**📖 Chi tiết và examples:** [FIREBASE_USAGE_GUIDE.md](FIREBASE_USAGE_GUIDE.md)

## 🔐 Security Rules

### Firestore Rules
Paste vào Firebase Console → Firestore Database → Rules:

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

### Storage Rules
Paste vào Firebase Console → Storage → Rules:

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

## 📊 Firestore Database Structure

```
users/
  {userId}/
    - uid: string
    - name: string
    - email: string
    - photoUrl: string | null
    - bio: string
    - favorites: array (track IDs)
    - playlists: array (playlist IDs)
    - followingArtists: array (artist IDs)
    
    recently_played/ (subcollection)
      {docId}/
        - trackId: string
        - trackName: string
        - artistName: string
        - playedAt: timestamp

playlists/
  {playlistId}/
    - userId: string
    - name: string
    - description: string
    - tracks: array
    - coverImage: string | null
    - isPublic: boolean
```

## 🧪 Testing

Sau khi setup, test các tính năng:

1. **Đăng ký tài khoản mới**
   - Vào Register screen
   - Điền thông tin
   - Check Firebase Console → Authentication

2. **Đăng nhập**
   - Dùng tài khoản vừa tạo
   - Check vào MainScreen

3. **Favorites**
   - Add bài hát vào favorites
   - Check Firebase Console → Firestore → users → {userId}

4. **Playlists**
   - Tạo playlist
   - Check Firestore → playlists

5. **Logout**
   - Logout
   - Check quay về LoginScreen

## 🆘 Troubleshooting

### Lỗi: Platform Exception
```bash
# Đảm bảo đã download google-services.json và GoogleService-Info.plist
# Đặt đúng vị trí: android/app/ và ios/Runner/
```

### Lỗi: Firebase not initialized
```bash
# Check lib/main.dart có await Firebase.initializeApp()
# Check firebase_options.dart đã được generate
```

### Lỗi: Build failed Android
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Lỗi: Pod install failed (iOS)
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter run
```

## 📚 Tài liệu

1. **FIREBASE_SETUP_GUIDE.md** - Hướng dẫn setup từng bước chi tiết
2. **FLUTTERFIRE_CLI_GUIDE.md** - Setup nhanh với FlutterFire CLI
3. **FIREBASE_USAGE_GUIDE.md** - Code examples và cách sử dụng
4. **FIREBASE_CHECKLIST.md** - Checklist theo dõi tiến độ

## 🔗 Links

- [Firebase Console](https://console.firebase.google.com/)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Authentication Docs](https://firebase.google.com/docs/auth)
- [Cloud Firestore Docs](https://firebase.google.com/docs/firestore)

## 🎉 Next Steps

Sau khi tích hợp Firebase thành công:

1. ✅ Test authentication flow
2. ✅ Update UI để hiển thị user info
3. ✅ Tích hợp favorites vào các screens
4. ✅ Tích hợp playlists management
5. ✅ Setup Security Rules ở production mode
6. ✅ (Optional) Add Google Sign-In, Facebook Login

---

**Made with ❤️ for SoulSync Music App**
