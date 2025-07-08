import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: Column(
        children: [
          DropdownButton(
            value: 'general',
            items: const [
              DropdownMenuItem(value: 'general', child: Text('General')),
              DropdownMenuItem(value: 'sports', child: Text('Sports')),
              DropdownMenuItem(value: 'business', child: Text('Business')),
            ],
            onChanged: (value) {
              if (value != null) {
                newsProvider.fetchNews(value);
              }
            },
          ),
          Expanded(
            child:
                newsProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : newsProvider.error.isNotEmpty
                    ? Center(child: Text(newsProvider.error))
                    : ListView.builder(
                      itemCount: newsProvider.articles.length,
                      itemBuilder: (context, index) {
                        final article = newsProvider.articles[index];
                        return ListTile(
                          leading:
                              article.imageUrl != null
                                  ? CachedNetworkImage(
                                    imageUrl: article.imageUrl!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) =>
                                            const CircularProgressIndicator(),
                                    errorWidget:
                                        (context, url, error) =>
                                            const Icon(Icons.error),
                                  )
                                  : const Icon(Icons.image),
                          title: Text(article.title),
                          onTap: () async {
                            final url = Uri.parse(article.url);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
