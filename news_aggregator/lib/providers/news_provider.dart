import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsProvider with ChangeNotifier {
  static const String _apiKey = '394f2e908dd94cb2980d9613d5fd37be';
  static const String _baseUrl = 'https://newsapi.org/v2';
  
  List<dynamic> _articles = [];
  bool _isLoading = false;
  String _error = '';
  
  List<dynamic> get articles => _articles;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchTopHeadlines() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/top-headlines?country=us&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _articles = data['articles'];
      } else {
        _error = 'Failed to fetch news';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNewsByCategory(String category) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/top-headlines?country=us&category=$category&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _articles = data['articles'];
      } else {
        _error = 'Failed to fetch news';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}