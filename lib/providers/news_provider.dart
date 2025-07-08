import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../config/env.dart';
import '../models/article.dart';

class NewsProvider with ChangeNotifier {
  List _articles = [];
  bool _isLoading = false;
  String _error = '';
  List get articles => _articles;
  bool get isLoading => _isLoading;
  String get error => _error;
  final Dio _dio = Dio();

  Future fetchNews(String category) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await _dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {'category': category, 'apiKey': Env.newsApiKey},
      );
      final articles =
          (response.data['articles'] as List)
              .map((json) => Article.fromJson(json))
              .toList();
      _articles = articles;
    } catch (e) {
      _error = 'Failed to load news: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
