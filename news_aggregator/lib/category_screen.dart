import 'package:flutter/material.dart';
import 'news_api_client.dart';
import 'article_details_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _categories = ['business', 'entertainment', 'health', 'science', 'sports', 'technology'];
  late Future<Map<String, dynamic>> _newsArticles;
  String _selectedCategory = 'business';

  @override
  void initState() {
    super.initState();
    _newsArticles = _fetchNewsArticlesByCategory(_selectedCategory);
  }

  Future<Map<String, dynamic>> _fetchNewsArticlesByCategory(String category) async {
    final client = NewsApiClient();
    return await client.getTopHeadlines(category: category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News by Category'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                  _newsArticles = _fetchNewsArticlesByCategory(_selectedCategory);
                });
              },
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category.toUpperCase()),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
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
          ),
        ],
      ),
    );
  }
}