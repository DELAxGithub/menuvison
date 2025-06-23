import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/image_search_result.dart';

class ImageSearchService {
  final String apiKey;
  final String searchEngineId;
  static const String _baseUrl = 'https://www.googleapis.com/customsearch/v1';
  
  ImageSearchService({
    required this.apiKey,
    required this.searchEngineId,
  });
  
  Future<List<ImageSearchResult>> searchImages(String query) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'key': apiKey,
        'cx': searchEngineId,
        'q': query,
        'searchType': 'image',
        'num': '6',
      },
    );
    
    try {
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];
        
        return items
            .map((item) => ImageSearchResult.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to search images: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching images: $e');
    }
  }
}