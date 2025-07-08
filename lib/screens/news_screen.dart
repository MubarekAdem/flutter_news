import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String _selectedCategory = 'general';
  bool _isLoading = false;
  String _error = '';
  List<Map<String, String>> _articles = [];

  // Simulated fetchNews (replace with your actual data source)
  Future<void> _fetchNews(String category) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      // Simulate fetching articles (replace with your API call or data source)
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay
      setState(() {
        _selectedCategory = category;
        _articles = _getSampleArticles(category);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error fetching news: $e';
        _isLoading = false;
      });
    }
  }

  // Sample articles (replace with your data model)
  List<Map<String, String>> _getSampleArticles(String category) {
    return [
      if (category == 'general') ...[
        {
          'title': 'General News Headline',
          'url': 'https://example.com',
          'imageUrl': 'https://via.placeholder.com/150',
          'timeAgo': '1 hour ago',
          'source': 'News Daily',
        },
      ],
      if (category == 'sports') ...[
        {
          'title': 'Sports Event Update',
          'url': 'https://example.com',
          'imageUrl': 'https://via.placeholder.com/150',
          'timeAgo': '2 hours ago',
          'source': 'Sports Now',
        },
      ],
      if (category == 'business') ...[
        {
          'title': 'Business Market Report',
          'url': 'https://example.com',
          'imageUrl': 'https://via.placeholder.com/150',
          'timeAgo': '3 hours ago',
          'source': 'Business Today',
        },
      ],
    ];
  }

  @override
  void initState() {
    super.initState();
    _fetchNews(_selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NewsFeed',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.purple.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.accessibility, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.purple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      color: Colors.blue,
                    ),
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                    items: const [
                      DropdownMenuItem(
                        value: 'general',
                        child: Text('General'),
                      ),
                      DropdownMenuItem(value: 'sports', child: Text('Sports')),
                      DropdownMenuItem(
                        value: 'business',
                        child: Text('Business'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        _fetchNews(value);
                      }
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child:
                  _isLoading
                      ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          ),
                        ),
                      )
                      : _error.isNotEmpty
                      ? Center(
                        child: Text(
                          _error,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 16,
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: _articles.length,
                        itemBuilder: (context, index) {
                          final article = _articles[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  final url = Uri.parse(article['url']!);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  }
                                },
                                borderRadius: BorderRadius.circular(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (article['imageUrl'] != null) ...[
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(15),
                                            ),
                                        child: CachedNetworkImage(
                                          imageUrl: article['imageUrl']!,
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  const Icon(Icons.error),
                                        ),
                                      ),
                                    ],
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: _getCategoryColor(
                                                    _selectedCategory,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  _selectedCategory[0]
                                                          .toUpperCase() +
                                                      _selectedCategory
                                                          .substring(1),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                article['timeAgo'] ??
                                                    '2 hours ago',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            article['title']!,
                                            style:
                                                theme.textTheme.titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black87,
                                                    ) ??
                                                const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            article['source'] ?? 'Tech Daily',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'general':
        return Colors.grey.shade200;
      case 'sports':
        return Colors.red.shade200;
      case 'business':
        return Colors.orange.shade200;
      default:
        return Colors.grey.shade200;
    }
  }
}
