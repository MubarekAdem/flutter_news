import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/news_provider.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final ThemeData theme = Theme.of(context); // Local declaration

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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _buildCategoryTab('All', true, () {
                    newsProvider.fetchNews('general');
                  }),
                  _buildCategoryTab('Tech', false, () {
                    newsProvider.fetchNews('tech');
                  }),
                  _buildCategoryTab('Business', false, () {
                    newsProvider.fetchNews('business');
                  }),
                  _buildCategoryTab('Health', false, () {
                    newsProvider.fetchNews('health');
                  }),
                  _buildCategoryTab('Sports', false, () {
                    newsProvider.fetchNews('sports');
                  }),
                ],
              ),
            ),
            Expanded(
              child:
                  newsProvider.isLoading
                      ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          ),
                        ),
                      )
                      : newsProvider.error.isNotEmpty
                      ? Center(
                        child: Text(
                          newsProvider.error,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 16,
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: newsProvider.articles.length,
                        itemBuilder: (context, index) {
                          final article = newsProvider.articles[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: _buildNewsCard(article, context),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red.shade200 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildNewsCard(article, BuildContext context) {
    String category = article.category ?? 'general';
    Color categoryColor = _getCategoryColor(category);
    bool isFeatured = article.isFeatured ?? false;
    final ThemeData localTheme = Theme.of(
      context,
    ); // Use local context for safety

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () async {
          final url = Uri.parse(article.url);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        },
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isFeatured) ...[
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl ?? '',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.red.shade200,
                child: const Text(
                  'FEATURED',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          category[0].toUpperCase() + category.substring(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        article.timeAgo ?? '2 hours ago',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style:
                        localTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
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
                    article.source ?? 'Tech Daily',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'tech':
        return Colors.blue.shade200;
      case 'business':
        return Colors.orange.shade200;
      case 'health':
        return Colors.green.shade200;
      case 'sports':
        return Colors.red.shade200;
      default:
        return Colors.grey.shade200;
    }
  }
}
