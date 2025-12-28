# Spotify API Integration

## 1. Đăng ký Spotify Developer Account

### Bước 1: Tạo tài khoản
1. Truy cập: https://developer.spotify.com/dashboard
2. Đăng nhập bằng tài khoản Spotify (hoặc tạo mới)
3. Chấp nhận Terms of Service

### Bước 2: Tạo App
1. Click "Create an App"
2. Điền thông tin:
   - **App name**: SoulSync Music App
   - **App description**: Music streaming application
   - **Redirect URI**: http://localhost:8888/callback (cho development)
3. Tick vào checkbox Terms of Service
4. Click "Create"

### Bước 3: Lấy credentials
1. Vào Dashboard của app vừa tạo
2. Click "Settings"
3. Copy:
   - **Client ID**: `abc123...`
   - **Client Secret**: `xyz789...` (Click "View client secret")

### Bước 4: Lưu credentials
Tạo file `.env` trong root project:
```
SPOTIFY_CLIENT_ID=your_client_id_here
SPOTIFY_CLIENT_SECRET=your_client_secret_here
```

## 2. Thêm dependencies vào pubspec.yaml

```yaml
dependencies:
  http: ^1.1.0
  flutter_dotenv: ^5.1.0
  just_audio: ^0.9.36  # Để phát nhạc preview
```

## 3. Chạy lệnh
```bash
flutter pub get
```

## 4. API Endpoints quan trọng

### Search
```
GET https://api.spotify.com/v1/search
Query params: q=track_name&type=track&limit=20
```

### Get Track
```
GET https://api.spotify.com/v1/tracks/{id}
```

### Get Artist
```
GET https://api.spotify.com/v1/artists/{id}
```

### Get Recommendations
```
GET https://api.spotify.com/v1/recommendations
Query params: seed_tracks=id1,id2&limit=20
```

### Browse Categories
```
GET https://api.spotify.com/v1/browse/categories
```

### Featured Playlists
```
GET https://api.spotify.com/v1/browse/featured-playlists
```

## 5. Authentication Flow

Spotify sử dụng **OAuth 2.0 Client Credentials Flow** cho app-only access:

```
1. POST https://accounts.spotify.com/api/token
   Headers: 
     Authorization: Basic <base64(client_id:client_secret)>
   Body:
     grant_type=client_credentials
     
2. Response:
   {
     "access_token": "NgCXRK...MzYjw",
     "token_type": "Bearer",
     "expires_in": 3600
   }
   
3. Use token trong các request:
   Headers:
     Authorization: Bearer NgCXRK...MzYjw
```

## 6. Rate Limits

- **Default**: 30 requests/second
- **Extended**: Liên hệ Spotify nếu cần nhiều hơn

## 7. Response Example

### Track Object
```json
{
  "id": "3n3Ppam7vgaVa1iaRUc9Lp",
  "name": "Mr. Brightside",
  "artists": [
    {
      "id": "0C0XlULifJtAgn6ZNCW2eu",
      "name": "The Killers"
    }
  ],
  "album": {
    "id": "4OHNH3sDzIxnmUADXzv2kT",
    "name": "Hot Fuss",
    "images": [
      {
        "url": "https://i.scdn.co/image/ab67616d0000b273...",
        "height": 640,
        "width": 640
      }
    ]
  },
  "duration_ms": 222973,
  "preview_url": "https://p.scdn.co/mp3-preview/...",
  "popularity": 87
}
```

## 8. Alternative: Deezer API (Không cần authentication cho basic features)

### Base URL
```
https://api.deezer.com
```

### Search
```
GET https://api.deezer.com/search?q=eminem
```

### Response đơn giản hơn Spotify:
```json
{
  "data": [
    {
      "id": 3135556,
      "title": "Harder, Better, Faster, Stronger",
      "artist": {
        "name": "Daft Punk"
      },
      "album": {
        "cover_medium": "https://..."
      },
      "preview": "https://cdns-preview-d.dzcdn.net/..."
    }
  ]
}
```

## 9. Testing API

Dùng Postman hoặc curl:

```bash
# Lấy token Spotify
curl -X POST "https://accounts.spotify.com/api/token" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -d "grant_type=client_credentials&client_id=YOUR_CLIENT_ID&client_secret=YOUR_CLIENT_SECRET"

# Search tracks
curl -X GET "https://api.spotify.com/v1/search?q=hello&type=track&limit=5" \
     -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## 10. Best Practices

1. **Cache token**: Lưu access token và chỉ refresh khi hết hạn (3600s)
2. **Handle errors**: API có thể trả về 401, 429 (rate limit), 500
3. **Pagination**: Dùng offset/limit cho kết quả lớn
4. **Image optimization**: Spotify trả về nhiều sizes, chọn size phù hợp
5. **Preview URLs**: Có thể null, cần handle gracefully

## 11. Khuyến nghị

- Development: Dùng Spotify API (dữ liệu tốt nhất)
- Production: Kết hợp nhiều sources (Spotify + Deezer + YouTube)
- Local playback: Cần subscription hoặc dùng preview URLs
- Offline: Download previews và cache
