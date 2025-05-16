import 'dart:convert';

import 'package:bookbeauty_desktop/models/review.dart';
import 'package:bookbeauty_desktop/providers/review_provider.dart';
import 'package:bookbeauty_desktop/widgets/product/review_stars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late List<Review> _reviews = [];
  late ReviewProvider _provider;
  List<Review> _filteredReviews = [];
  bool isLoading = true;
  bool isGroupedByUser = false;
  bool isGroupedByProduct = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _provider = context.read<ReviewProvider>();
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    try {
      var result = await _provider.get();
      setState(() {
        _reviews = result.result;
        _filteredReviews =
            result.result; 
        isLoading = false;
      });
    } catch (e) {
      print(
          "*****************************ERROR MESSAGE $e ***********************************");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _sortReviews(String option) {
  setState(() {
    if (option == "From lowest mark") {
      _filteredReviews.sort((a, b) => a.mark!.compareTo(b.mark!));
    } else if (option == "From highest mark") {
      _filteredReviews.sort((a, b) => b.mark!.compareTo(a.mark!));
    }
  });
}


  void _groupReviews(String option) {
  List<Review> base = List.from(_reviews); 

  if (option == "By user") {
    base = _groupByUser(base);
    isGroupedByUser = true;
    isGroupedByProduct = false;
  } else if (option == "By product") {
    base = _groupByProduct(base);
    isGroupedByUser = false;
    isGroupedByProduct = true;
  }

  if (_searchController.text.isNotEmpty) {
    base = base.where((review) {
      final query = _searchController.text.toLowerCase();
      return (review.user?.username?.toLowerCase().contains(query) ?? false) ||
             (review.product?.name?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  setState(() {
    _filteredReviews = base;
  });
}

  List<Review> _groupByUser(List<Review> reviews) {
    Map<String, List<Review>> grouped = {};
    for (var review in reviews) {
      final username = review.user?.username ?? "Unknown";
      if (!grouped.containsKey(username)) {
        grouped[username] = [];
      }
      grouped[username]!.add(review);
    }
    return grouped.values.expand((element) => element).toList();
  }

  List<Review> _groupByProduct(List<Review> reviews) {
    Map<String, List<Review>> grouped = {};
    for (var review in reviews) {
      final productName = review.product?.name ?? "Unknown Product";
      if (!grouped.containsKey(productName)) {
        grouped[productName] = [];
      }
      grouped[productName]!.add(review);
    }
    return grouped.values.expand((element) => element).toList();
  }

  void _searchReviews(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredReviews = _reviews;
      } else {
        _filteredReviews = _reviews.where((review) {
          final userMatch = review.user?.username
                  ?.toLowerCase()
                  .contains(query.toLowerCase()) ??
              false;
          final productMatch = review.product?.name
                  ?.toLowerCase()
                  .contains(query.toLowerCase()) ??
              false;
          return userMatch || productMatch;
        }).toList();
      }
    });
  }

void _clearFilters() {
  setState(() {
    isGroupedByUser = false;
    isGroupedByProduct = false;
    _filteredReviews = _reviews;
    _searchController.clear();
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _searchReviews,
                    decoration: const InputDecoration(
                      labelText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.filter_alt),
                  onPressed: () {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        MediaQuery.of(context).size.width - 120,
                        kToolbarHeight,
                        0,
                        0,
                      ),
                      items: [
                        const PopupMenuItem<String>(
                          value: "From lowest mark",
                          child: Text("From lowest mark"),
                        ),
                        const PopupMenuItem<String>(
                          value: "From highest mark",
                          child: Text("From highest mark"),
                        ),
                      ],
                    ).then((value) {
                      if (value != null) {
                        _sortReviews(
                            value); 
                      }
                    });
                  },
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        MediaQuery.of(context).size.width - 200,
                        kToolbarHeight,
                        0,
                        0,
                      ),
                      items: [
                        const PopupMenuItem<String>(
                          value: "By user",
                          child: Text("By user"),
                        ),
                        const PopupMenuItem<String>(
                          value: "By product",
                          child: Text("By product"),
                        ),
                      ],
                    ).then((value) {
                      if (value != null) {
                        _groupReviews(
                            value);
                      }
                    });
                  },
                ),
                IconButton(
                    icon: const Icon(
                      Icons.filter_alt_off,
                      color: Colors.redAccent,
                    ),
                    tooltip: 'Delete all filters',
                    onPressed: _clearFilters),
              ],
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: _filteredReviews.length,
                    itemBuilder: (ctx, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(_filteredReviews[index].user!.username!),
                              Text(_filteredReviews[index].product!.name!),
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: _filteredReviews[index].product!.image != null
                      ? Image.memory(
                          base64Decode(_filteredReviews[index].product!.image!),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          "assets/images/logoBB.png",
                       
                          fit: BoxFit.cover,
                        ),
                              ),
                              ReviewStars(
                                average:
                                    _filteredReviews[index].mark!.toDouble(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
