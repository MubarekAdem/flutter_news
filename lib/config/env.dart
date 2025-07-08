import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL']!;
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY']!;
  static String get newsApiKey => dotenv.env['NEWS_API_KEY']!;
  static String get weatherApiKey => dotenv.env['WEATHER_API_KEY']!;
  static String get financeApiKey => dotenv.env['FINANCE_API_KEY']!;
}
