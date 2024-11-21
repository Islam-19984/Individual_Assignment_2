import 'package:flutter/material.dart';
import 'news_api_client.dart';
import 'article_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> _newsArticles;

  @override
  void initState() {
    super.initState();
    _newsArticles = _fetchTopHeadlines();
  }

  Future<Map<String, dynamic>> _fetchTopHeadlines() async {
    final client = NewsApiClient();
    return await client.getTopHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Aggregator'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _newsArticles,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final articles = snapshot.data!['articles'];
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ListTile(
                  title: Text(article['title']),
                  subtitle: Text(article['source']['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailsScreen(article: article),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}