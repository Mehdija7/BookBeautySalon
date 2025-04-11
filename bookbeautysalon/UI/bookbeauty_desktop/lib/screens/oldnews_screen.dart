import 'dart:convert';
import 'package:bookbeauty_desktop/models/news.dart';
import 'package:bookbeauty_desktop/providers/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OldnewsScreen extends StatefulWidget {
  const OldnewsScreen({super.key});

  @override
  State<OldnewsScreen> createState() => _OldnewsScreenState();
}

class _OldnewsScreenState extends State<OldnewsScreen> {
  bool isLoading = true;
  NewsProvider newsProvider = NewsProvider();
  List<News> news = [];
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  void fetchNews() async {
    var result = await newsProvider.get();
    if (result.count > 0) {
      setState(() {
        news = result.result;
        news.sort((a, b) => b.dateTime!.compareTo(a.dateTime!));
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News archive'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      var currentNews = news[index];
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              currentNews.title!,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            if (currentNews.newsImage != null && currentNews.newsImage!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:  currentNews.newsImage != null
                      ? Image.memory(
                          base64Decode(currentNews.newsImage!), 
                          width: 100,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          "assets/images/logoBB.png",
                          width: 100,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                              ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                currentNews.text!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              DateFormat('dd/MM/yyyy').format(currentNews.dateTime!),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          if (_pageController.page! > 0) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          if (_pageController.page! < news.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
