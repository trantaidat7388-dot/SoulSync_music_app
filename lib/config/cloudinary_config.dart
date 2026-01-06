/// Cloudinary configuration.
///
/// This project uses *unsigned uploads* for avatars so we don't ship secrets in the app.
///
/// Provide values at build/run time using `--dart-define`:
///
/// - `CLOUDINARY_CLOUD_NAME`
/// - `CLOUDINARY_UPLOAD_PRESET`
/// - (optional) `CLOUDINARY_AVATAR_FOLDER` (default: avatars)
///
/// Example:
/// `flutter run -d windows --dart-define=CLOUDINARY_CLOUD_NAME=xxx --dart-define=CLOUDINARY_UPLOAD_PRESET=yyy`
class CloudinaryConfig {
  static const String cloudName = String.fromEnvironment('CLOUDINARY_CLOUD_NAME');
  static const String uploadPreset = String.fromEnvironment('CLOUDINARY_UPLOAD_PRESET');
  static const String avatarFolder = String.fromEnvironment(
    'CLOUDINARY_AVATAR_FOLDER',
    defaultValue: 'avatars',
  );

  static bool get isConfigured => cloudName.trim().isNotEmpty && uploadPreset.trim().isNotEmpty;
}
