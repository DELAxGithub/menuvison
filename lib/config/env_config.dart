import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get googleCustomSearchApiKey => 
      dotenv.env['GOOGLE_CUSTOM_SEARCH_API_KEY'] ?? '';
  
  static String get googleSearchEngineId => 
      dotenv.env['GOOGLE_SEARCH_ENGINE_ID'] ?? '';
  
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      print('Warning: Could not load .env file: $e');
      // Set default values for development
      dotenv.env['GOOGLE_CUSTOM_SEARCH_API_KEY'] = 'your_api_key_here';
      dotenv.env['GOOGLE_SEARCH_ENGINE_ID'] = 'your_search_engine_id_here';
    }
  }
}