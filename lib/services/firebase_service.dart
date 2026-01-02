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
  String? get userId => _currentUser?.uid;
  String? get userEmail => _currentUser?.email;
  String? get userName => _userProfile?['name'] ?? _currentUser?.displayName;
  String? get userPhotoUrl => _userProfile?['photoUrl'] ?? _currentUser?.photoURL;
  
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
        'favorites': [],
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
        case 'invalid-credential':
          return 'Email hoặc mật khẩu không đúng';
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
      
      // Update display name in Auth if name is changed
      if (data.containsKey('name')) {
        await _currentUser!.updateDisplayName(data['name']);
      }
      
      // Update photo URL in Auth if photoUrl is changed
      if (data.containsKey('photoUrl')) {
        await _currentUser!.updatePhotoURL(data['photoUrl']);
      }
      
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
    
    await _loadUserProfile();
  }
  
  // REMOVE FROM FAVORITES
  Future<void> removeFromFavorites(String trackId) async {
    if (_currentUser == null) return;
    
    await _firestore.collection('users').doc(_currentUser!.uid).update({
      'favorites': FieldValue.arrayRemove([trackId]),
    });
    
    await _loadUserProfile();
  }
  
  // CHECK IF TRACK IS FAVORITE
  bool isFavorite(String trackId) {
    if (_userProfile == null) return false;
    List<dynamic> favorites = _userProfile!['favorites'] ?? [];
    return favorites.contains(trackId);
  }
  
  // GET FAVORITES LIST
  List<String> getFavorites() {
    if (_userProfile == null) return [];
    return List<String>.from(_userProfile!['favorites'] ?? []);
  }
  
  // SAVE RECENTLY PLAYED
  Future<void> saveRecentlyPlayed(Map<String, dynamic> track) async {
    if (_currentUser == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('recently_played')
          .add({
        ...track,
        'playedAt': FieldValue.serverTimestamp(),
      });
      
      // Keep only last 50 tracks
      final recentlyPlayed = await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('recently_played')
          .orderBy('playedAt', descending: true)
          .get();
      
      if (recentlyPlayed.docs.length > 50) {
        for (var i = 50; i < recentlyPlayed.docs.length; i++) {
          await recentlyPlayed.docs[i].reference.delete();
        }
      }
    } catch (e) {
      debugPrint('Error saving recently played: $e');
    }
  }
  
  // GET RECENTLY PLAYED
  Stream<QuerySnapshot> getRecentlyPlayed() {
    if (_currentUser == null) {
      return const Stream.empty();
    }
    
    return _firestore
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('recently_played')
        .orderBy('playedAt', descending: true)
        .limit(50)
        .snapshots();
  }
  
  // CREATE PLAYLIST
  Future<String?> createPlaylist({
    required String name,
    String? description,
    String? coverImage,
  }) async {
    if (_currentUser == null) return 'Chưa đăng nhập';
    
    try {
      DocumentReference playlistRef = await _firestore.collection('playlists').add({
        'userId': _currentUser!.uid,
        'name': name,
        'description': description ?? '',
        'tracks': [],
        'coverImage': coverImage,
        'isPublic': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // Add to user's playlists
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'playlists': FieldValue.arrayUnion([playlistRef.id]),
      });
      
      await _loadUserProfile();
      return null; // Success
    } catch (e) {
      return 'Lỗi tạo playlist: $e';
    }
  }
  
  // GET USER PLAYLISTS
  Stream<QuerySnapshot> getUserPlaylists() {
    if (_currentUser == null) {
      return const Stream.empty();
    }
    
    return _firestore
        .collection('playlists')
        .where('userId', isEqualTo: _currentUser!.uid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }
  
  // ADD TRACK TO PLAYLIST
  Future<String?> addTrackToPlaylist(String playlistId, Map<String, dynamic> track) async {
    if (_currentUser == null) return 'Chưa đăng nhập';
    
    try {
      await _firestore.collection('playlists').doc(playlistId).update({
        'tracks': FieldValue.arrayUnion([track]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      return null; // Success
    } catch (e) {
      return 'Lỗi thêm bài hát: $e';
    }
  }
  
  // REMOVE TRACK FROM PLAYLIST
  Future<String?> removeTrackFromPlaylist(String playlistId, Map<String, dynamic> track) async {
    if (_currentUser == null) return 'Chưa đăng nhập';
    
    try {
      await _firestore.collection('playlists').doc(playlistId).update({
        'tracks': FieldValue.arrayRemove([track]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      return null; // Success
    } catch (e) {
      return 'Lỗi xóa bài hát: $e';
    }
  }
  
  // DELETE PLAYLIST
  Future<String?> deletePlaylist(String playlistId) async {
    if (_currentUser == null) return 'Chưa đăng nhập';
    
    try {
      await _firestore.collection('playlists').doc(playlistId).delete();
      
      // Remove from user's playlists
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'playlists': FieldValue.arrayRemove([playlistId]),
      });
      
      await _loadUserProfile();
      return null; // Success
    } catch (e) {
      return 'Lỗi xóa playlist: $e';
    }
  }
  
  // FOLLOW ARTIST
  Future<void> followArtist(String artistId) async {
    if (_currentUser == null) return;
    
    await _firestore.collection('users').doc(_currentUser!.uid).update({
      'followingArtists': FieldValue.arrayUnion([artistId]),
    });
    
    await _loadUserProfile();
  }
  
  // UNFOLLOW ARTIST
  Future<void> unfollowArtist(String artistId) async {
    if (_currentUser == null) return;
    
    await _firestore.collection('users').doc(_currentUser!.uid).update({
      'followingArtists': FieldValue.arrayRemove([artistId]),
    });
    
    await _loadUserProfile();
  }
  
  // CHECK IF FOLLOWING ARTIST
  bool isFollowingArtist(String artistId) {
    if (_userProfile == null) return false;
    List<dynamic> following = _userProfile!['followingArtists'] ?? [];
    return following.contains(artistId);
  }
}
