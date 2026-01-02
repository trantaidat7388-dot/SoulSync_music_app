# 📖 Hướng dẫn sử dụng Firebase Service

Sau khi đã setup Firebase, đây là cách sử dụng FirebaseService trong app.

## 🎯 Import và sử dụng

### 1. Trong các Screen

```dart
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';

// Lấy instance
final firebaseService = Provider.of<FirebaseService>(context, listen: false);

// Hoặc listen để tự động rebuild khi có thay đổi
final firebaseService = Provider.of<FirebaseService>(context);
```

---

## 🔐 Authentication

### Đăng ký (Register)

```dart
final error = await firebaseService.registerWithEmail(
  name: 'Nguyễn Văn A',
  email: 'user@example.com',
  password: 'password123',
);

if (error == null) {
  // Đăng ký thành công
  print('User ID: ${firebaseService.userId}');
  Navigator.pushReplacement(context, MainScreen());
} else {
  // Hiển thị lỗi
  showSnackBar(error);
}
```

### Đăng nhập (Login)

```dart
final error = await firebaseService.loginWithEmail(
  email: 'user@example.com',
  password: 'password123',
);

if (error == null) {
  // Đăng nhập thành công
  print('Welcome ${firebaseService.userName}!');
} else {
  // Hiển thị lỗi
  showSnackBar(error);
}
```

### Đăng xuất (Logout)

```dart
await firebaseService.logout();
Navigator.pushReplacement(context, LoginScreen());
```

### Reset Password

```dart
final error = await firebaseService.resetPassword('user@example.com');

if (error == null) {
  showSnackBar('Email đã được gửi!');
} else {
  showSnackBar(error);
}
```

### Kiểm tra trạng thái đăng nhập

```dart
// Check if user is logged in
if (firebaseService.isLoggedIn) {
  print('User đã đăng nhập');
  print('Email: ${firebaseService.userEmail}');
  print('Name: ${firebaseService.userName}');
}
```

---

## 👤 User Profile

### Lấy thông tin user

```dart
// Automatic update with Provider
Consumer<FirebaseService>(
  builder: (context, service, child) {
    if (!service.isLoggedIn) {
      return Text('Chưa đăng nhập');
    }
    
    return Column(
      children: [
        Text('Name: ${service.userName}'),
        Text('Email: ${service.userEmail}'),
        if (service.userPhotoUrl != null)
          Image.network(service.userPhotoUrl!),
      ],
    );
  },
);
```

### Cập nhật profile

```dart
final error = await firebaseService.updateUserProfile({
  'name': 'Tên mới',
  'bio': 'Bio của tôi',
  'photoUrl': 'https://example.com/photo.jpg',
});

if (error == null) {
  showSnackBar('Cập nhật thành công!');
}
```

---

## ❤️ Favorites (Yêu thích)

### Thêm vào favorites

```dart
await firebaseService.addToFavorites(track.id);
```

### Xóa khỏi favorites

```dart
await firebaseService.removeFromFavorites(track.id);
```

### Kiểm tra track có trong favorites không

```dart
bool isFav = firebaseService.isFavorite(track.id);

// Trong UI
IconButton(
  icon: Icon(
    firebaseService.isFavorite(track.id)
        ? Icons.favorite
        : Icons.favorite_border,
    color: firebaseService.isFavorite(track.id)
        ? Colors.red
        : Colors.grey,
  ),
  onPressed: () {
    if (firebaseService.isFavorite(track.id)) {
      firebaseService.removeFromFavorites(track.id);
    } else {
      firebaseService.addToFavorites(track.id);
    }
  },
);
```

### Lấy danh sách favorites

```dart
List<String> favoriteIds = firebaseService.getFavorites();
print('Có ${favoriteIds.length} bài hát yêu thích');
```

---

## 🎵 Playlists

### Tạo playlist mới

```dart
final error = await firebaseService.createPlaylist(
  name: 'My Favorite Songs',
  description: 'Những bài hát tôi thích nhất',
  coverImage: 'https://example.com/cover.jpg', // optional
);

if (error == null) {
  showSnackBar('Playlist đã được tạo!');
}
```

### Lấy danh sách playlists (Real-time)

```dart
StreamBuilder<QuerySnapshot>(
  stream: firebaseService.getUserPlaylists(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Text('Chưa có playlist nào');
    }
    
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        var playlist = snapshot.data!.docs[index].data() as Map<String, dynamic>;
        return ListTile(
          title: Text(playlist['name']),
          subtitle: Text(playlist['description']),
          trailing: Text('${playlist['tracks'].length} songs'),
        );
      },
    );
  },
);
```

### Thêm bài hát vào playlist

```dart
final trackData = {
  'id': track.id,
  'name': track.name,
  'artistName': track.artistName,
  'imageUrl': track.imageUrl,
  'previewUrl': track.previewUrl,
};

final error = await firebaseService.addTrackToPlaylist(
  playlistId,
  trackData,
);

if (error == null) {
  showSnackBar('Đã thêm vào playlist!');
}
```

### Xóa bài hát khỏi playlist

```dart
await firebaseService.removeTrackFromPlaylist(playlistId, trackData);
```

### Xóa playlist

```dart
final error = await firebaseService.deletePlaylist(playlistId);

if (error == null) {
  showSnackBar('Đã xóa playlist!');
}
```

---

## 🕒 Recently Played

### Lưu bài hát vừa phát

```dart
// Gọi khi bắt đầu phát một bài hát
await firebaseService.saveRecentlyPlayed({
  'trackId': track.id,
  'trackName': track.name,
  'artistName': track.artistName,
  'imageUrl': track.imageUrl,
  'albumName': track.albumName,
  'durationMs': track.durationMs,
});
```

### Hiển thị recently played (Real-time)

```dart
StreamBuilder<QuerySnapshot>(
  stream: firebaseService.getRecentlyPlayed(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
    
    final tracks = snapshot.data!.docs;
    
    return ListView.builder(
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        var track = tracks[index].data() as Map<String, dynamic>;
        var playedAt = (track['playedAt'] as Timestamp).toDate();
        
        return ListTile(
          leading: Image.network(track['imageUrl']),
          title: Text(track['trackName']),
          subtitle: Text(track['artistName']),
          trailing: Text(
            _formatTime(playedAt), // e.g., "2 hours ago"
          ),
        );
      },
    );
  },
);
```

---

## 👨‍🎤 Follow Artists

### Follow một artist

```dart
await firebaseService.followArtist(artistId);
```

### Unfollow artist

```dart
await firebaseService.unfollowArtist(artistId);
```

### Kiểm tra có đang follow không

```dart
bool isFollowing = firebaseService.isFollowingArtist(artistId);

IconButton(
  icon: Icon(
    isFollowing ? Icons.favorite : Icons.favorite_border,
  ),
  onPressed: () {
    if (isFollowing) {
      firebaseService.unfollowArtist(artistId);
    } else {
      firebaseService.followArtist(artistId);
    }
  },
);
```

---

## 🔔 Listen to changes

### Auto-rebuild khi user data thay đổi

```dart
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseService>(
      builder: (context, service, child) {
        if (!service.isLoggedIn) {
          return LoginScreen();
        }
        
        return Column(
          children: [
            Text('Hi ${service.userName}!'),
            Text('${service.getFavorites().length} favorites'),
          ],
        );
      },
    );
  }
}
```

---

## 🎨 Example: Favorite Button Widget

```dart
class FavoriteButton extends StatelessWidget {
  final String trackId;
  
  const FavoriteButton({required this.trackId});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseService>(
      builder: (context, service, child) {
        final isFavorite = service.isFavorite(trackId);
        
        return IconButton(
          icon: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(isFavorite),
              color: isFavorite ? Colors.red : Colors.grey,
            ),
          ),
          onPressed: () async {
            if (isFavorite) {
              await service.removeFromFavorites(trackId);
            } else {
              await service.addToFavorites(trackId);
            }
          },
        );
      },
    );
  }
}
```

---

## 🚨 Error Handling

Tất cả các method authentication đều return `String?`:
- `null` = thành công
- `String` = error message (tiếng Việt)

```dart
final error = await firebaseService.loginWithEmail(...);

if (error != null) {
  // Show error to user
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(error),
      backgroundColor: Colors.red,
    ),
  );
}
```

---

## 💡 Tips

1. **Always check `isLoggedIn`** trước khi thực hiện operations cần authentication
2. **Use `Consumer`** để auto-rebuild UI khi data thay đổi
3. **Use `StreamBuilder`** cho real-time data (playlists, recently played)
4. **Error handling**: Luôn check return value của các async methods
5. **Loading states**: Show CircularProgressIndicator khi đang loading

---

## 📊 Firestore Structure

Xem chi tiết trong `FIREBASE_SETUP_GUIDE.md` phần 7 (Cấu trúc Database).
