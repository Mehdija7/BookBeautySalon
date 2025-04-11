import 'dart:convert';

import 'package:book_beauty/models/news.dart';
import 'package:book_beauty/providers/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
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
    return  isLoading
          ? Center(child: CircularProgressIndicator())
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
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
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
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                currentNews.text!,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              DateFormat('dd/MM/yyyy').format(currentNews.dateTime!),
                              style: TextStyle(
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
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          if (_pageController.page! > 0) {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          if (_pageController.page! < news.length - 1) {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
  
  }
}
