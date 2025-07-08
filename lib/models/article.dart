import 'package:uuid/uuid.dart';

class Article {
  final String id;
  final String title;
  final String url;
  final String? imageUrl;
  final DateTime publishedAt;

  Article({
    required this.id,
    required this.title,
    required this.url,
    this.imageUrl,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? const Uuid().v4(),
      title: json['title'] ?? 'No Title',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'],
      publishedAt: DateTime.parse(
        json['publishedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
