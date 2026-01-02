# 🔥 Hướng dẫn kết nối Firebase & Xem tài khoản

## 📋 Bước 1: Kết nối Firebase (Chọn 1 trong 2 cách)

### ⚡ CÁCH 1: FlutterFire CLI (Nhanh nhất - 5 phút)

```powershell
# 1. Cài FlutterFire CLI
dart pub global activate flutterfire_cli

# 2. Thêm vào PATH (nếu báo lỗi command not found)
$env:PATH += ";$env:USERPROFILE\AppData\Local\Pub\Cache\bin"

# 3. Cài Firebase CLI (nếu chưa có)
npm install -g firebase-tools

# 4. Login Firebase
firebase login

# 5. Configure project
cd d:\SoulSync_music_app
flutterfire configure
```

**Khi chạy `flutterfire configure`:**
- Chọn Firebase project (hoặc tạo mới)
- Chọn platforms: `android`, `ios` (Space để chọn, Enter xác nhận)
- Tool sẽ tự động:
  - Download `google-services.json` → `android/app/`
  - Download `GoogleService-Info.plist` → `ios/Runner/`
  - Generate `lib/firebase_options.dart` với config thực

**Sau đó cập nhật Android build files:**

📁 `android/build.gradle.kts`:
```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.2")  // THÊM DÒNG NÀY
    }
}
```

📁 `android/app/build.gradle.kts`:
```kotlin
plugins {
    id("com.google.gms.google-services")  // THÊM DÒNG NÀY
}

android {
    defaultConfig {
        minSdk = 23              // ĐỔI TỪ 21 THÀNH 23
        multiDexEnabled = true   // THÊM DÒNG NÀY
    }
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")  // THÊM DÒNG NÀY
}
```

### 🔧 CÁCH 2: Thủ công (30 phút)

Xem chi tiết trong [FIREBASE_SETUP_GUIDE.md](FIREBASE_SETUP_GUIDE.md)

---

## 📱 Bước 2: Enable Authentication trong Firebase Console

1. Vào https://console.firebase.google.com/
2. Chọn project của bạn
3. Click **Authentication** → **Get started**
4. Tab **Sign-in method**
5. Click **Email/Password**
6. Bật **Enable** ✅
7. Click **Save**

---

## 💾 Bước 3: Tạo Firestore Database

1. Trong Firebase Console, click **Firestore Database**
2. Click **Create database**
3. Chọn **Start in test mode** (cho development)
4. Chọn region: **asia-southeast1** (Singapore - gần VN nhất)
5. Click **Enable**

---

## 🚀 Bước 4: Chạy App

```powershell
flutter clean
flutter pub get
flutter run
```

---

## 🎯 Bước 5: Đăng ký tài khoản

1. Mở app
2. Click **Get Started** (onboarding)
3. Click **Sign Up / Register**
4. Điền thông tin:
   - Name: `Tên của bạn`
   - Email: `email@example.com`
   - Password: `password123` (tối thiểu 6 ký tự)
   - Confirm Password: `password123`
   - Tick ✅ Accept Terms
5. Click **Sign Up**

Nếu thành công, bạn sẽ thấy:
- ✅ Thông báo "Đăng ký thành công!"
- Tự động chuyển vào MainScreen

---

## 👀 Cách xem tài khoản đã tạo

### 📍 **Cách 1: Xem trong Firebase Console (Web)**

1. Vào https://console.firebase.google.com/
2. Chọn project của bạn
3. Click **Authentication** (menu bên trái)
4. Bạn sẽ thấy danh sách Users:

```
┌─────────────────────┬──────────────────────┬────────────┬──────────────┐
│ Identifier          │ Providers            │ Created    │ Signed In    │
├─────────────────────┼──────────────────────┼────────────┼──────────────┤
│ email@example.com   │ password             │ Today      │ Just now     │
│ Tên của bạn         │                      │            │              │
└─────────────────────┴──────────────────────┴────────────┴──────────────┘
```

Click vào user để xem chi tiết:
- User UID
- Email
- Display Name
- Created Date
- Last Sign In

### 📍 **Cách 2: Xem User Data trong Firestore**

1. Trong Firebase Console, click **Firestore Database**
2. Bạn sẽ thấy collection **users**
3. Click vào collection → Sẽ thấy documents (mỗi user là 1 document)
4. Click vào document ID (user UID) để xem chi tiết:

```json
{
  "uid": "abc123xyz...",
  "name": "Tên của bạn",
  "email": "email@example.com",
  "photoUrl": null,
  "bio": "",
  "createdAt": "2026-01-02 10:30:00",
  "updatedAt": "2026-01-02 10:30:00",
  "favorites": [],
  "playlists": [],
  "followingArtists": [],
  "recentlyPlayed": []
}
```

### 📍 **Cách 3: Xem trong App (Profile Screen)**

Trong app đã có Profile Screen hiển thị thông tin user:

1. Đăng nhập vào app
2. Vào tab **Profile** (icon người ở bottom navigation)
3. Bạn sẽ thấy:
   - Avatar/Photo
   - Name
   - Email
   - Stats (Songs, Playlists, Followers)
   - Favorites
   - My Playlists

---

## 🔍 Kiểm tra xem Firebase đã kết nối thành công chưa

### Test 1: Đăng ký tài khoản
```
✅ Đăng ký thành công → Firebase đã kết nối
❌ Lỗi "Firebase not initialized" → Chưa kết nối
```

### Test 2: Check trong code
Mở app và check terminal/console:

```
✅ Không có lỗi → OK
❌ "FirebaseException" → Chưa config đúng
```

### Test 3: Check files
```
✅ lib/firebase_options.dart có config thực (không phải YOUR_API_KEY)
✅ android/app/google-services.json tồn tại
✅ ios/Runner/GoogleService-Info.plist tồn tại (nếu build iOS)
```

---

## 🆘 Troubleshooting

### Lỗi: "Firebase not initialized"
```powershell
# Chạy lại configure
flutterfire configure

# Rebuild app
flutter clean
flutter pub get
flutter run
```

### Lỗi: "Email already in use"
- Email đã được đăng ký rồi
- Dùng email khác hoặc login

### Lỗi: "Weak password"
- Password phải tối thiểu 6 ký tự

### Lỗi: Build failed (Android)
```powershell
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

---

## 📊 Cấu trúc User Data

Khi đăng ký, Firebase tạo:

**1. Authentication User:**
- UID (unique ID)
- Email
- Display Name
- Created Date

**2. Firestore Document (users/{userId}):**
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
    - favorites: []
    - playlists: []
    - followingArtists: []
    - recentlyPlayed: []
```

---

## 📸 Screenshots hướng dẫn

### Firebase Console - Authentication
```
Firebase Console → Authentication → Users

Bạn sẽ thấy:
┌──────────────────────────────────────────┐
│  👤 Users                                │
│  ┌────────────────────────────────────┐  │
│  │ email@example.com                  │  │
│  │ Password • Created today           │  │
│  └────────────────────────────────────┘  │
└──────────────────────────────────────────┘
```

### Firebase Console - Firestore
```
Firestore Database → users → {userId}

Data:
{
  name: "Nguyễn Văn A"
  email: "user@example.com"
  favorites: []
  playlists: []
}
```

---

## ✅ Checklist hoàn thành

- [ ] Chạy `flutterfire configure`
- [ ] Enable Authentication (Email/Password)
- [ ] Create Firestore Database
- [ ] Update Android build files
- [ ] Run app: `flutter run`
- [ ] Đăng ký tài khoản test
- [ ] Kiểm tra trong Firebase Console → Authentication
- [ ] Kiểm tra trong Firestore Database → users
- [ ] Xem profile trong app

---

## 🎉 Hoàn thành!

Khi tất cả checklist ✅, bạn đã:
- Kết nối Firebase thành công
- Có thể đăng ký/đăng nhập
- Xem được user data trong Firebase Console
- Xem được profile trong app

Tiếp theo: Bạn có thể thêm ảnh đại diện, edit profile, add favorites, v.v.
