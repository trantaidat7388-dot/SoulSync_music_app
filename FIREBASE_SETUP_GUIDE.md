# 🔥 Hướng dẫn tích hợp Firebase vào SoulSync Music App

## 📋 Mục lục
1. [Cài đặt Firebase Console](#1-cài-đặt-firebase-console)
2. [Cấu hình Android](#2-cấu-hình-android)
3. [Cấu hình iOS](#3-cấu-hình-ios)
4. [Khởi tạo Firebase trong Flutter](#4-khởi-tạo-firebase-trong-flutter)
5. [Tạo Firebase Service](#5-tạo-firebase-service)
6. [Tích hợp vào Login/Register](#6-tích-hợp-vào-loginregister)
7. [Cấu trúc Database Firestore](#7-cấu-trúc-database-firestore)

---

## 1️⃣ Cài đặt Firebase Console

### Bước 1: Tạo Project Firebase
1. Truy cập: https://console.firebase.google.com/
2. Click **"Add project"** (Thêm dự án)
3. Đặt tên: **"SoulSync Music App"**
4. Bật/Tắt Google Analytics (tùy chọn)
5. Click **"Create project"**

### Bước 2: Enable Authentication
1. Vào **Authentication** → **Get started**
2. Chọn tab **Sign-in method**
3. Enable các phương thức:
   - ✅ **Email/Password**
   - ✅ **Google** (optional)
   - ✅ **Facebook** (optional)

### Bước 3: Tạo Firestore Database
1. Vào **Firestore Database** → **Create database**
2. Chọn **Start in test mode** (cho development)
3. Chọn region: **asia-southeast1** (Singapore - gần VN)
4. Click **Enable**

### Bước 4: Cấu hình Storage
1. Vào **Storage** → **Get started**
2. Chọn **Start in test mode**
3. Click **Done**

---

## 2️⃣ Cấu hình Android

### Bước 1: Thêm Android App vào Firebase
1. Trong Firebase Console, click biểu tượng **Android**
2. Nhập **Package name**: `com.example.music_app` 
   (hoặc đổi thành package name của bạn)
3. Nhập **App nickname**: "SoulSync Android"
4. **SHA-1** (optional): Lấy bằng lệnh:
   ```bash
   cd android
   ./gradlew signingReport
   ```
5. Click **Register app**

### Bước 2: Download google-services.json
1. Download file **google-services.json**
2. Copy vào thư mục: `android/app/`
3. Cấu trúc:
   ```
   android/
     app/
       google-services.json  ← File này
       build.gradle.kts
   ```

### Bước 3: Cập nhật build.gradle files

**📁 android/build.gradle.kts** (project level)
```kotlin
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.5.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.20")
        classpath("com.google.gms:google-services:4.4.2")  // ADD THIS
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

**📁 android/app/build.gradle.kts** (app level)
```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")  // ADD THIS
}

android {
    namespace = "com.example.music_app"
    compileSdk = 34  // Đổi thành 34
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.music_app"
        minSdk = 23  // Firebase yêu cầu tối thiểu 23
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled = true  // ADD THIS
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")  // ADD THIS
}
```

### Bước 4: Cập nhật AndroidManifest.xml

**📁 android/app/src/main/AndroidManifest.xml**
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    
    <application
        android:name="${applicationName}"
        android:label="SoulSync"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            
            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme"/>
            
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
```

---

## 3️⃣ Cấu hình iOS

### Bước 1: Thêm iOS App vào Firebase
1. Trong Firebase Console, click biểu tượng **iOS**
2. Nhập **Bundle ID**: `com.example.musicApp`
3. Click **Register app**

### Bước 2: Download GoogleService-Info.plist
1. Download file **GoogleService-Info.plist**
2. Mở Xcode: `open ios/Runner.xcworkspace`
3. Drag file vào **Runner/Runner** folder (trong Xcode)
4. Đảm bảo chọn **"Copy items if needed"**

### Bước 3: Cập nhật Podfile

**📁 ios/Podfile**
```ruby
# Uncomment this line to define a global platform for your project
platform :ios, '13.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  
  # Firebase pods (tự động được thêm từ pubspec.yaml)
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    
    # Fix for Firebase on iOS
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
```

### Bước 4: Chạy pod install
```bash
cd ios
pod install
cd ..
```

---

## 4️⃣ Khởi tạo Firebase trong Flutter

### Cập nhật main.dart

**📁 lib/main.dart**
```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';  // ADD
import 'firebase_options.dart';  // ADD (sẽ tạo sau)
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';  // ADD
import 'theme/colors.dart';
import 'services/app_language.dart';
import 'services/theme_provider.dart';
import 'services/audio_player_service.dart';
import 'services/firebase_service.dart';  // ADD (sẽ tạo sau)

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize services
  await AudioPlayerService.instance.init();
  
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FirebaseService()),  // ADD
      ],
      child: const MyAppContent(),
    );
  }
}

// ... rest of code
```

---

## 5️⃣ Tạo Firebase Service

Tạo file service để quản lý authentication và database:

**📁 lib/services/firebase_service.dart**
```dart
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _currentUser;
  Map<String, dynamic>? _userProfile;
  
  FirebaseService() {
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      if (user != null) {
        _loadUserProfile();
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });
  }
  
  // Getters
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  Map<String, dynamic>? get userProfile => _userProfile;
  
  // Load user profile from Firestore
  Future<void> _loadUserProfile() async {
    if (_currentUser == null) return;
    
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .get();
      
      if (doc.exists) {
        _userProfile = doc.data() as Map<String, dynamic>?;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }
  
  // REGISTER with Email & Password
  Future<String?> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await credential.user?.updateDisplayName(name);
      
      // Create user profile in Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': name,
        'email': email,
        'photoUrl': null,
        'bio': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'favoriteGenres': [],
        'followingArtists': [],
        'playlists': [],
        'recentlyPlayed': [],
      });
      
      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          return 'Mật khẩu quá yếu (tối thiểu 6 ký tự)';
        case 'email-already-in-use':
          return 'Email đã được sử dụng';
        case 'invalid-email':
          return 'Email không hợp lệ';
        default:
          return 'Lỗi: ${e.message}';
      }
    } catch (e) {
      return 'Đã xảy ra lỗi: $e';
    }
  }
  
  // LOGIN with Email & Password
  Future<String?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Không tìm thấy tài khoản';
        case 'wrong-password':
          return 'Mật khẩu không đúng';
        case 'invalid-email':
          return 'Email không hợp lệ';
        case 'user-disabled':
          return 'Tài khoản đã bị vô hiệu hóa';
        default:
          return 'Lỗi: ${e.message}';
      }
    } catch (e) {
      return 'Đã xảy ra lỗi: $e';
    }
  }
  
  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }
  
  // RESET PASSWORD
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Không tìm thấy email này';
        case 'invalid-email':
          return 'Email không hợp lệ';
        default:
          return 'Lỗi: ${e.message}';
      }
    } catch (e) {
      return 'Đã xảy ra lỗi: $e';
    }
  }
  
  // UPDATE USER PROFILE
  Future<String?> updateUserProfile(Map<String, dynamic> data) async {
    if (_currentUser == null) return 'Chưa đăng nhập';
    
    try {
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      await _loadUserProfile();
      return null; // Success
    } catch (e) {
      return 'Lỗi cập nhật: $e';
    }
  }
  
  // ADD TO FAVORITES
  Future<void> addToFavorites(String trackId) async {
    if (_currentUser == null) return;
    
    await _firestore.collection('users').doc(_currentUser!.uid).update({
      'favorites': FieldValue.arrayUnion([trackId]),
    });
  }
  
  // REMOVE FROM FAVORITES
  Future<void> removeFromFavorites(String trackId) async {
    if (_currentUser == null) return;
    
    await _firestore.collection('users').doc(_currentUser!.uid).update({
      'favorites': FieldValue.arrayRemove([trackId]),
    });
  }
  
  // SAVE RECENTLY PLAYED
  Future<void> saveRecentlyPlayed(Map<String, dynamic> track) async {
    if (_currentUser == null) return;
    
    await _firestore
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('recently_played')
        .add({
      ...track,
      'playedAt': FieldValue.serverTimestamp(),
    });
  }
  
  // CREATE PLAYLIST
  Future<String?> createPlaylist({
    required String name,
    String? description,
  }) async {
    if (_currentUser == null) return 'Chưa đăng nhập';
    
    try {
      DocumentReference playlistRef = await _firestore.collection('playlists').add({
        'userId': _currentUser!.uid,
        'name': name,
        'description': description ?? '',
        'tracks': [],
        'coverImage': null,
        'isPublic': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // Add to user's playlists
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'playlists': FieldValue.arrayUnion([playlistRef.id]),
      });
      
      return null; // Success
    } catch (e) {
      return 'Lỗi tạo playlist: $e';
    }
  }
}
```

---

## 6️⃣ Tích hợp vào Login/Register

Bạn sẽ cần cập nhật 2 file:
- `lib/screens/login_screen.dart`
- `lib/screens/register_screen.dart`

Thay thế hàm `_handleLogin()` và `_handleRegister()` để sử dụng FirebaseService.

---

## 7️⃣ Cấu trúc Database Firestore

### Collections:

#### 📁 users
```
users/
  {userId}/
    - uid: string
    - name: string
    - email: string
    - photoUrl: string | null
    - bio: string
    - createdAt: timestamp
    - updatedAt: timestamp
    - favoriteGenres: array
    - followingArtists: array
    - playlists: array (playlist IDs)
    - favorites: array (track IDs)
    
    recently_played/ (subcollection)
      {docId}/
        - trackId: string
        - trackName: string
        - artistName: string
        - playedAt: timestamp
```

#### 📁 playlists
```
playlists/
  {playlistId}/
    - userId: string
    - name: string
    - description: string
    - tracks: array
    - coverImage: string | null
    - isPublic: boolean
    - createdAt: timestamp
    - updatedAt: timestamp
```

#### 📁 downloads
```
downloads/
  {userId}/
    - tracks: array
      - trackId: string
      - downloadedAt: timestamp
      - localPath: string
```

---

## 🚀 Các bước thực hiện

### 1. Cài đặt FlutterFire CLI (Recommended)
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Generate firebase_options.dart
flutterfire configure
```

### 2. Hoặc tạo thủ công firebase_options.dart
Tôi sẽ tạo file template trong bước tiếp theo.

### 3. Test Firebase
```bash
flutter clean
flutter pub get
flutter run
```

---

## ⚠️ Lưu ý quan trọng

1. **Security Rules**: Đổi Firestore rules từ test mode sang production:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /playlists/{playlistId} {
      allow read: if resource.data.isPublic == true || request.auth.uid == resource.data.userId;
      allow write: if request.auth.uid == resource.data.userId;
    }
  }
}
```

2. **Storage Rules**:
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

3. **Environment**: Đừng commit file `google-services.json` và `GoogleService-Info.plist` lên Git!

Add vào `.gitignore`:
```
# Firebase
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
ios/firebase_app_id_file.json
lib/firebase_options.dart
```

---

## 🎉 Hoàn thành!

Sau khi làm theo hướng dẫn này, app của bạn sẽ có:
- ✅ Đăng ký/Đăng nhập với Email & Password
- ✅ Quản lý user profiles trong Firestore
- ✅ Lưu favorites, playlists, recently played
- ✅ Reset password
- ✅ Logout
- ✅ Real-time sync với Firebase

Tiếp theo, tôi sẽ tạo các file cần thiết!
