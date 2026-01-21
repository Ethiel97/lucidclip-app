import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  const AppConstants._();

  static const storageDirectory = 'lucid_clip_storage';

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

  static final githubClientId =
      dotenv.env['GITHUB_CLIENT_ID'] ??
      const String.fromEnvironment('GITHUB_CLIENT_ID');

  static final githubClientSecret =
      dotenv.env['GITHUB_CLIENT_SECRET'] ??
      const String.fromEnvironment('GITHUB_CLIENT_SECRET');

  static final monthlyProductId =
      dotenv.env['LUCID_MONTHLY_PRODUCT_ID'] ??
      const String.fromEnvironment('LUCID_MONTHLY_PRODUCT_ID');

  static final yearlyProductId =
      dotenv.env['LUCID_YEARLY_PRODUCT_ID'] ??
      const String.fromEnvironment('LUCID_YEARLY_PRODUCT_ID');

  static const clipboardItemDetailsViewWidth = 380.0;
  static const clipboardSidebarWidth = 220.0;
  static const collapsedSidebarWidth = 100.0;

  static const isProd = bool.fromEnvironment('dart.vm.product');
}
