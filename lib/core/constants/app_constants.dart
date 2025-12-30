import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  const AppConstants._();

  static const storageDirectory = 'lucid_clip_storage';

  static final String supabaseProjectUrl =
      dotenv.env['SUPABASE_PROJECT_URL'] ?? '';
  static final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static final supabaseApiKey = dotenv.env['SUPABASE_API_KEY'] ?? '';

  static const clipboardItemDetailsViewWidth = 360.0;
  static const clipboardSidebarWidth = 260.0;
}
