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
  NewsProvider newsprovider = NewsProvider();
  List<News> newsList = [];
  bool isLoading = true;
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  void fetchNews() async {
    try {
      var r = await newsprovider.get();
      setState(() {
        newsList = r.result;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
   
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _scrollController,
              builder: (context, child) {
                double offset = _scrollController.hasClients
                    ? _scrollController.offset * 0.3
                    : 0; 
                return Transform.translate(
                  offset: Offset(0, -offset),
                  child: Image.asset(
                    "assets/images/newp.jpg", 
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),

          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: newsList.length,
                          itemBuilder: (context, index) {
                            var currentNews = newsList[index];
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Card(
                                color: const Color(0xFFF5F5DC), // Beige newspaper color
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentNews.title!,
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Georgia', // Classic newspaper font
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        currentNews.text!,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Times New Roman',
                                          height: 1.5,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 7,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format(currentNews.dateTime!),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black54,
                                          ),
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
                      Row(
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
                              if (_pageController.page! < newsList.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
