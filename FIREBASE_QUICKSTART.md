# ⚡ Firebase Quick Start (5 phút)

## 🎯 Cách nhanh nhất để setup Firebase

### 1️⃣ Install FlutterFire CLI (1 phút)

```bash
# Install
dart pub global activate flutterfire_cli

# Verify
flutterfire --version
```

**Lỗi "command not found"?**
```bash
# Windows (PowerShell)
$env:PATH += ";$env:USERPROFILE\AppData\Local\Pub\Cache\bin"

# macOS/Linux
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### 2️⃣ Login Firebase (30 giây)

```bash
firebase login
```

**Chưa có Firebase CLI?**
```bash
npm install -g firebase-tools
```

### 3️⃣ Configure Project (2 phút)

```bash
cd d:\SoulSync_music_app
flutterfire configure
```

Tool sẽ hỏi:
- ✅ Chọn Firebase project (hoặc tạo mới)
- ✅ Chọn platforms: `android`, `ios` (dùng Space, Enter)
- ✅ Auto download config files
- ✅ Auto generate `firebase_options.dart`

### 4️⃣ Update Android Build Files (1 phút)

**android/build.gradle.kts** - Thêm dòng này:
```kotlin
buildscript {
    dependencies {
        // ... existing code ...
        classpath("com.google.gms:google-services:4.4.2")  // ADD
    }
}
```

**android/app/build.gradle.kts** - Thêm 3 thứ:
```kotlin
plugins {
    // ... existing plugins ...
    id("com.google.gms.google-services")  // 1. ADD THIS
}

android {
    defaultConfig {
        // ... existing config ...
        minSdk = 23              // 2. CHANGE FROM 21 to 23
        multiDexEnabled = true   // 3. ADD THIS
    }
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")  // 4. ADD THIS
}
```

### 5️⃣ Setup Firebase Console (1 phút)

Vào https://console.firebase.google.com/

**Enable Authentication:**
1. Click **Authentication** → Get started
2. Tab **Sign-in method**
3. Enable **Email/Password** ✅

**Create Firestore:**
1. Click **Firestore Database** → Create
2. **Test mode** ✅
3. Region: **asia-southeast1** (Singapore)

**Enable Storage:**
1. Click **Storage** → Get started
2. **Test mode** ✅

### 6️⃣ Test (30 giây)

```bash
flutter clean
flutter pub get
flutter run
```

## ✅ Done!

App giờ có:
- 🔐 Đăng ký/Đăng nhập với Email
- 💾 Lưu user data vào Firestore
- ❤️ Favorites management
- 🎵 Playlists
- 🔄 Real-time sync

## 🧪 Test ngay

1. Mở app
2. Vào **Register** screen
3. Đăng ký tài khoản mới
4. Check Firebase Console → Authentication
5. Check Firestore → users collection

## 🆘 Có lỗi?

**Build failed?**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

**iOS pod install failed?**
```bash
cd ios
pod deintegrate
pod install
cd ..
```

**Firebase not initialized?**
- Check `lib/firebase_options.dart` đã tồn tại
- Re-run: `flutterfire configure`

## 📚 Docs

- Chi tiết: [FIREBASE_INTEGRATION.md](FIREBASE_INTEGRATION.md)
- Code examples: [FIREBASE_USAGE_GUIDE.md](FIREBASE_USAGE_GUIDE.md)
- Full guide: [FIREBASE_SETUP_GUIDE.md](FIREBASE_SETUP_GUIDE.md)

---

**⏱️ Total time: ~5 phút**
