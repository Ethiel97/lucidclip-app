import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  const AppConstants._();

  static const storageDirectory = 'lucid_clip_storage';

  static final String apiBaseUrl =
      dotenv.env['API_BASE_URL'] ??
      const String.fromEnvironment('API_BASE_URL');

  static final String supabaseProjectUrl =
      dotenv.env['SUPABASE_PROJECT_URL'] ??
      const String.fromEnvironment('SUPABASE_PROJECT_URL');

  static final supabaseProjectId =
      dotenv.env['SUPABASE_PROJECT_ID'] ??
      const String.fromEnvironment('SUPABASE_PROJECT_ID');

  static final supabaseToken =
      dotenv.env['SUPABASE_TOKEN'] ??
      const String.fromEnvironment('SUPABASE_TOKEN');

  static final supabasePublishableKey =
      dotenv.env['SUPABASE_API_KEY'] ??
      const String.fromEnvironment('SUPABASE_API_KEY');

  static final firebaseApiKey =
      dotenv.env['FIREBASE_API_KEY'] ??
      const String.fromEnvironment('FIREBASE_API_KEY');

  static final monthlyProductId =
      dotenv.env['LUCID_MONTHLY_PRODUCT_ID'] ??
      const String.fromEnvironment('LUCID_MONTHLY_PRODUCT_ID');

  static final yearlyProductId =
      dotenv.env['LUCID_YEARLY_PRODUCT_ID'] ??
      const String.fromEnvironment('LUCID_YEARLY_PRODUCT_ID');

  static final wiredashProjectId =
      dotenv.env['WIREDASH_PROJECT_ID'] ??
      const String.fromEnvironment('WIREDASH_PROJECT_ID');

  static final wiredashSecret =
      dotenv.env['WIREDASH_SECRET'] ??
      const String.fromEnvironment('WIREDASH_SECRET');

  static final oAuthRedirectScheme =
      dotenv.env['OAUTH_REDIRECT_SCHEME'] ??
      const String.fromEnvironment(
        'OAUTH_REDIRECT_SCHEME',
        defaultValue: 'lucidclip',
      );

  static final secureStorageEncryptionKey =
      dotenv.env['SECURE_STORAGE_ENCRYPTION_KEY'] ??
      const String.fromEnvironment('SECURE_STORAGE_ENCRYPTION_KEY');

  static const clipboardItemDetailsViewWidth = 380.0;
  static const clipboardSidebarWidth = 220.0;
  static const collapsedSidebarWidth = 100.0;

  static const isProd = bool.fromEnvironment('dart.vm.product');
}
