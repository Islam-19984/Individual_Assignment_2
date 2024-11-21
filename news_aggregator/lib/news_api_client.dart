import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiClient {
  static const _apiKey = '394f2e908dd94cb2980d9613d5fd37be';
  static const _baseUrl = 'https://newsapi.org/v2';

  Future<Map<String, dynamic>> getTopHeadlines({
    String country = 'us',
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParameters = {
        'country': country,
        'apiKey': _apiKey,
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };

      if (category != null) {
        queryParameters['category'] = category;
      }

      final uri = Uri.parse('$_baseUrl/top-headlines').replace(
        queryParameters: queryParameters,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

  Future<Map<String, dynamic>> searchArticles({
    required String query,
    String? language,
    String? sortBy,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParameters = {
        'q': query,
        'apiKey': _apiKey,
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };

      if (language != null) {
        queryParameters['language'] = language;
      }

      if (sortBy != null) {
        queryParameters['sortBy'] = sortBy;
      }

      final uri = Uri.parse('$_baseUrl/everything').replace(
        queryParameters: queryParameters,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to search articles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching articles: $e');
    }
  }

  Future<Map<String, dynamic>> getSources({
    String? category,
    String? language,
    String? country,
  }) async {
    try {
      final queryParameters = {
        'apiKey': _apiKey,
      };

      if (category != null) {
        queryParameters['category'] = category;
      }

      if (language != null) {
        queryParameters['language'] = language;
      }

      if (country != null) {
        queryParameters['country'] = country;
      }

      final uri = Uri.parse('$_baseUrl/sources').replace(
        queryParameters: queryParameters,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch sources: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching sources: $e');
    }
  }
}