# Test Playback Flow

## ✅ Đã làm:

1. **AudioPlayerService** - Service phát nhạc với just_audio
   - Init trong main.dart
   - Streams cho track, playing, progress
   - Methods: setTrack(), play(), pause()

2. **Track Model** - Thêm local storage
   - `localPath` - đường dẫn file local
   - `isDownloaded` - đã tải về chưa
   - `copyWith()` - update track

3. **Search Screen** - Tap vào track để phát
   - Import AudioPlayerService
   - onTap: setTrack() → play()
   - Navigate đến NowPlaying

4. **MiniPlayer** - Hiển thị track đang phát
   - Album art từ stream
   - Title/Artist từ stream
   - Play/Pause button
   - Progress bar

5. **NowPlaying Screen** - Chi tiết track
   - Title/Artist reactive
   - Progress bar reactive

## 🎵 Cách sử dụng:

### 1. Từ Search (Deezer API):
```dart
1. Vào Search tab
2. Tìm bài hát (vd: "hello")
3. Tap vào bất kỳ track nào
4. → Nhạc sẽ phát ngay (preview 30s từ Deezer)
```

### 2. Từ nhạc local (nếu có):
```dart
// Trong bất kỳ screen nào
final player = AudioPlayerService.instance;
final localTrack = Track(
  id: '1',
  name: 'Tên bài hát',
  artistName: 'Nghệ sĩ',
  // ... các field khác
  localPath: '/path/to/music.mp3', // ← File local
  isDownloaded: true,
);
await player.setTrack(localTrack);
await player.play();
```

### 3. Downloads Service:
```dart
// Tải nhạc về local
final updated = await DownloadsService.instance.downloadTrack(track);
// updated.localPath sẽ có đường dẫn file đã tải

// Lấy danh sách đã tải
final downloaded = await DownloadsService.instance.getDownloadedTracks();
```

## 🐛 Nếu vẫn không phát được:

1. **Check permissions** (Android):
   - Thêm vào `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
   ```

2. **Check preview URL**:
   - Deezer preview URLs có thể expire
   - Check track.previewUrl != null

3. **Test trực tiếp**:
   ```dart
   final player = AudioPlayerService.instance;
   await player.setTrack(trackFromSearch);
   print('Playing: ${player.isPlaying}');
   ```

## 📱 Try it now:
```bash
flutter run
# Vào Search → Tìm "hello" → Tap track đầu tiên
```
