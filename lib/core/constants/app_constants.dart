class AppConstants {
  const AppConstants._();

  static const storageDirectory = 'lucid_clip_storage';

  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static const String supabaseProjectUrl = String.fromEnvironment(
    'SUPABASE_PROJECT_URL',
  );

  static const supabaseProjectId = String.fromEnvironment(
    'SUPABASE_PROJECT_ID',
  );

  static const supabaseToken = String.fromEnvironment('SUPABASE_TOKEN');

  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_API_KEY',
  );

  static const firebaseApiKey = String.fromEnvironment('FIREBASE_API_KEY');

  static const monthlyProductId = String.fromEnvironment(
    'LUCID_MONTHLY_PRODUCT_ID',
  );

  static const yearlyProductId = String.fromEnvironment(
    'LUCID_YEARLY_PRODUCT_ID',
  );

  static const wiredashProjectId = String.fromEnvironment(
    'WIREDASH_PROJECT_ID',
  );

  static const wiredashSecret = String.fromEnvironment('WIREDASH_SECRET');

  static const oAuthRedirectScheme = String.fromEnvironment(
    'OAUTH_REDIRECT_SCHEME',
    defaultValue: 'lucidclip',
  );

  static const secureStorageEncryptionKey = String.fromEnvironment(
    'SECURE_STORAGE_ENCRYPTION_KEY',
  );

  static const clipboardItemDetailsViewWidth = 380.0;
  static const clipboardSidebarWidth = 220.0;
  static const collapsedSidebarWidth = 100.0;

  static const isProd = bool.fromEnvironment('dart.vm.product');
}
