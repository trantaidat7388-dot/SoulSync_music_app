# 🔥 Hướng dẫn sử dụng FlutterFire CLI (Khuyến nghị)

## Cách nhanh nhất và dễ nhất để setup Firebase!

### 📦 Bước 1: Cài đặt FlutterFire CLI

```bash
# Cài đặt FlutterFire CLI globally
dart pub global activate flutterfire_cli
```

### 🚀 Bước 2: Login Firebase

```bash
# Login vào Firebase account
firebase login
```

**Lưu ý:** Nếu chưa có Firebase CLI, cài đặt trước:
```bash
npm install -g firebase-tools
```

### ⚙️ Bước 3: Configure Firebase cho project

```bash
# Di chuyển vào thư mục project
cd d:\SoulSync_music_app

# Chạy FlutterFire configure
flutterfire configure
```

Tool sẽ:
1. ✅ Tự động tạo Firebase project (hoặc chọn project có sẵn)
2. ✅ Register Android app
3. ✅ Register iOS app
4. ✅ Download `google-services.json` (Android)
5. ✅ Download `GoogleService-Info.plist` (iOS)
6. ✅ Tự động generate file `lib/firebase_options.dart`
7. ✅ Cập nhật cấu hình cho tất cả platforms

### 🎯 Bước 4: Chọn platforms

Khi chạy `flutterfire configure`, tool sẽ hỏi:

```
? Which platforms should your configuration support?
  [x] android
  [x] ios
  [x] macos
  [x] web
```

Chọn platforms bạn muốn support (dùng Space để chọn, Enter để xác nhận).

### 📝 Bước 5: Cập nhật Android build files

Sau khi chạy FlutterFire CLI, bạn vẫn cần cập nhật một số file:

#### 📁 android/build.gradle.kts

Thêm classpath cho Google Services:

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
```

#### 📁 android/app/build.gradle.kts

Thêm plugin và dependencies:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")  // ADD THIS
}

android {
    defaultConfig {
        minSdk = 23  // Firebase requires minimum 23
        multiDexEnabled = true  // ADD THIS
    }
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")  // ADD THIS
}
```

### 🔄 Bước 6: Re-configure khi cần

Nếu bạn thêm platforms mới hoặc thay đổi Firebase project:

```bash
flutterfire configure
```

### ✅ Bước 7: Kiểm tra

File `lib/firebase_options.dart` sẽ được tạo tự động với nội dung như:

```dart
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      // ...
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIza...',
    appId: '1:...',
    messagingSenderId: '...',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
  );
  
  // ...
}
```

### 🎉 Xong!

Giờ bạn có thể chạy app:

```bash
flutter clean
flutter pub get
flutter run
```

---

## 🆘 Troubleshooting

### Lỗi: Command not found: flutterfire

```bash
# Add Flutter/Dart to PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Hoặc trên Windows (PowerShell):
$env:PATH += ";$env:USERPROFILE\AppData\Local\Pub\Cache\bin"
```

### Lỗi: Firebase login failed

```bash
# Logout và login lại
firebase logout
firebase login
```

### Lỗi: No Firebase projects found

1. Vào https://console.firebase.google.com/
2. Tạo project mới
3. Chạy lại `flutterfire configure`

---

## 📚 Tài liệu

- FlutterFire CLI: https://firebase.flutter.dev/docs/cli/
- Firebase Console: https://console.firebase.google.com/
- FlutterFire Docs: https://firebase.flutter.dev/
