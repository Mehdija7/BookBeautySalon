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

  TextEditingController _searchController = TextEditingController();

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
            result.result; // Initialize filtered list as all reviews
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

  // Sort reviews based on selected option
  void _sortReviews(String option) {
    if (option == "Od najniže ocjene") {
      _filteredReviews
          .sort((a, b) => a.mark!.compareTo(b.mark!)); // Ascending order
    } else if (option == "Od najviše ocjene") {
      _filteredReviews
          .sort((a, b) => b.mark!.compareTo(a.mark!)); // Descending order
    }
    setState(() {}); // Refresh UI after sorting
  }

  // Group reviews based on selected option
  void _groupReviews(String option) {
    if (option == "Po korisniku") {
      _filteredReviews = _groupByUser(_reviews);
      setState(() {
        isGroupedByUser = true;
        isGroupedByProduct = false;
      });
    } else if (option == "Po proizvodu") {
      _filteredReviews = _groupByProduct(_reviews);
      setState(() {
        isGroupedByUser = false;
        isGroupedByProduct = true;
      });
    }
  }

  // Helper method to group reviews by user
  List<Review> _groupByUser(List<Review> reviews) {
    Map<String, List<Review>> grouped = {};
    for (var review in reviews) {
      final username = review.user?.username ?? "Unknown";
      if (!grouped.containsKey(username)) {
        grouped[username] = [];
      }
      grouped[username]!.add(review);
    }
    // Flatten the grouped map into a list of reviews
    return grouped.values.expand((element) => element).toList();
  }

  // Helper method to group reviews by product
  List<Review> _groupByProduct(List<Review> reviews) {
    Map<String, List<Review>> grouped = {};
    for (var review in reviews) {
      final productName = review.product?.name ?? "Unknown Product";
      if (!grouped.containsKey(productName)) {
        grouped[productName] = [];
      }
      grouped[productName]!.add(review);
    }
    // Flatten the grouped map into a list of reviews
    return grouped.values.expand((element) => element).toList();
  }

  // Search functionality to filter reviews by user or product name
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
      bool isGroupedByUser = false;
      bool isGroupedByProduct = false;
      _filteredReviews = _reviews;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recenzije"),
      ),
      body: Column(
        children: [
          // Search, Sort, and Group Filters Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Search Box
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _searchReviews,
                    decoration: const InputDecoration(
                      labelText: "Pretraga",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Sort Filter Button
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
                        PopupMenuItem<String>(
                          value: "Od najniže ocjene",
                          child: const Text("Od najniže ocjene"),
                        ),
                        PopupMenuItem<String>(
                          value: "Od najviše ocjene",
                          child: const Text("Od najviše ocjene"),
                        ),
                      ],
                    ).then((value) {
                      if (value != null) {
                        _sortReviews(
                            value); // Sort the reviews based on the selected option
                      }
                    });
                  },
                ),
                const SizedBox(width: 10),
                // Group Filter Button
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
                        PopupMenuItem<String>(
                          value: "Po korisniku",
                          child: const Text("Po korisniku"),
                        ),
                        PopupMenuItem<String>(
                          value: "Po proizvodu",
                          child: const Text("Po proizvodu"),
                        ),
                      ],
                    ).then((value) {
                      if (value != null) {
                        _groupReviews(
                            value); // Group the reviews based on the selected option
                      }
                    });
                  },
                ),
                IconButton(
                    icon: const Icon(
                      Icons.filter_alt_off,
                      color: Colors.redAccent,
                    ),
                    tooltip: 'Izbrisi sve filtere',
                    onPressed: _clearFilters),
              ],
            ),
          ),
          // Reviews List
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
