import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/models/search_result.dart';
import 'package:book_beauty/models/user.dart';
import 'package:book_beauty/providers/order_item_provider.dart';
import 'package:book_beauty/providers/product_provider.dart';
import 'package:book_beauty/providers/recommend_result_provider.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:book_beauty/widgets/customer_info_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<Product> _allProducts = [];
  final ProductProvider productProvider = ProductProvider();
  final OrderItemProvider orderItemProvider = OrderItemProvider();
  final RecommendResultProvider recommendResultProvider =
      RecommendResultProvider();
  List<Product> dataRecomm = [];
  SearchResult<Product>? result;
  SearchResult<Product>? resultRecomm;

  Future<void> _fetchProducts() async {
    var list = orderItemProvider.orderItems;
    Product p = list[0].product!;
    int id = p.productId!;
    try {
      if (list.isEmpty) {
        final products = await productProvider.getMobile();
        setState(() {
          _allProducts = products;
        });
      } else {
        var recommendResult = await recommendResultProvider.get();
        var filteredRecommendation =
            recommendResult.result.where((x) => x.productId == id).toList();
        if (filteredRecommendation.isNotEmpty) {
          var matchingRecommendation = filteredRecommendation.first;

          print(recommendResult);

          int firstProductID = matchingRecommendation.firstproductId!;
          int secondProductID = matchingRecommendation.secondproductId!;
          int thirdProductID = matchingRecommendation.thirdproductId!;

          var firstRecommendProduct =
              await productProvider.getById(firstProductID);
          var secondRecommendedProduct =
              await productProvider.getById(secondProductID);
          var thirdRecommendedProduct =
              await productProvider.getById(thirdProductID);

          setState(() {
            List<Product> list = [];
            list.addAll([
              firstRecommendProduct,
              secondRecommendedProduct,
              thirdRecommendedProduct
            ]);
            _allProducts = list;
            resultRecomm = SearchResult<Product>()
              ..result = [
                firstRecommendProduct,
                secondRecommendedProduct,
                thirdRecommendedProduct
              ]
              ..count = 3;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("No matching recommendations found"),
          ));
        }
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something bad happened."),
      ));
    }
  }

  @override
  void initState() {
    _fetchProducts();
    super.initState();
  }

  Widget generateProductCard(Product product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          product.image!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = UserProvider.user ?? User();
    const Color dustyBlue = Color(0xFF748CAB);
    const Color goldGrey = Color(0xFFC1A57B);
    const Color backgroundGrey = Color(0xFFF2F2F2);

    return Scaffold(
      backgroundColor: backgroundGrey,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/user.jpg',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${user.firstName} ${user.lastName}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: dustyBlue,
              ),
            ),
            const SizedBox(height: 40),
            CustomerInfoItem(
              title: 'Ime:',
              value: user.firstName ?? '',
              titleStyle: const TextStyle(
                color: dustyBlue,
                fontWeight: FontWeight.bold,
              ),
              valueStyle: const TextStyle(
                color: goldGrey,
              ),
            ),
            CustomerInfoItem(
              title: 'Prezime:',
              value: user.lastName ?? '',
              titleStyle: const TextStyle(
                color: dustyBlue,
                fontWeight: FontWeight.bold,
              ),
              valueStyle: const TextStyle(
                color: goldGrey,
              ),
            ),
            CustomerInfoItem(
              title: 'Grad:',
              value: user.address ?? '',
              titleStyle: const TextStyle(
                color: dustyBlue,
                fontWeight: FontWeight.bold,
              ),
              valueStyle: const TextStyle(
                color: goldGrey,
              ),
            ),
            CustomerInfoItem(
              title: 'Broj telefona:',
              value: user.phone ?? '',
              titleStyle: const TextStyle(
                color: dustyBlue,
                fontWeight: FontWeight.bold,
              ),
              valueStyle: const TextStyle(
                color: goldGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  const CustomerInfoItem({
    super.key,
    required this.title,
    required this.value,
    this.titleStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleStyle ??
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: valueStyle ?? const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
