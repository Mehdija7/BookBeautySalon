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
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arhiva novosti'),
      ),
      body: isLoading
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
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              // Container that represents the book page
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title of the News
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        currentNews.title!,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // Text content area
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        currentNews.text!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          height: 1.5,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Date at the bottom
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(currentNews.dateTime!),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Button Row for Next and Previous
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
            ),
    );
  }
}
