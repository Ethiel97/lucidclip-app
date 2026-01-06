import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  const AppConstants._();

  static const storageDirectory = 'lucid_clip_storage';

  static final String supabaseProjectUrl =
      dotenv.env['SUPABASE_PROJECT_URL'] ??
      const String.fromEnvironment('SUPABASE_PROJECT_URL');

  static final supabaseAnonKey =
      dotenv.env['SUPABASE_ANON_KEY'] ??
      const String.fromEnvironment('SUPABASE_ANON_KEY');

  static final supabaseProjectId =
      dotenv.env['SUPABASE_PROJECT_ID'] ??
      const String.fromEnvironment('SUPABASE_PROJECT_ID');

  static final supabaseToken =
      dotenv.env['SUPABASE_TOKEN'] ??
      const String.fromEnvironment('SUPABASE_TOKEN');

  static final supabaseApiKey =
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

  static const clipboardItemDetailsViewWidth = 360.0;
  static const clipboardSidebarWidth = 240.0;
  static const collapsedSidebarWidth = 100.0;
}
