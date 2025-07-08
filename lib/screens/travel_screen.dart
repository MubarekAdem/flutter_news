import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TravelScreen extends StatelessWidget {
  TravelScreen({super.key});

  final List<Map<String, String>> destinations = [
    {
      'name': 'Cleopatras Pool',
      'description':
          'A historic desert oasis in Egypt, known for its ancient beauty.',
      'imageUrl': 'https://example.com/cleopatra_pool.jpg',
    },
    {
      'name': 'Nile River',
      'description':
          'The lifeblood of Egypt, perfect for cruises and exploration.',
      'imageUrl': 'https://example.com/nile_river.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travel')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final destination = destinations[index];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: destination['imageUrl']!,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    destination['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    destination['description']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
