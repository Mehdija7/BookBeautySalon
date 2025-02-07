import 'package:flutter/material.dart';
import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/models/search_result.dart';
import 'package:book_beauty/models/user.dart';
import 'package:book_beauty/providers/order_item_provider.dart';
import 'package:book_beauty/providers/product_provider.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:book_beauty/widgets/customer_info_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProductProvider productProvider = ProductProvider();
  final OrderItemProvider orderItemProvider = OrderItemProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = UserProvider.globaluser ?? User();
    const Color dustyBlue = Color(0xFF748CAB);
    const Color goldGrey = Color(0xFFC1A57B);
    const Color backgroundGrey = Color(0xFFF2F2F2);

    return Scaffold(
      backgroundColor: backgroundGrey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: dustyBlue,
                    ),
                    onPressed: () {},
                  ),
                ],
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
              const SizedBox(height: 40),

              // My Orders Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "My Orders",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      // Order History Content
                      Text("Order History goes here."),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // My Appointments Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "My Appointments",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.book,
                              color: dustyBlue,
                            ),
                            onPressed: () {
                              // Add your edit logic here
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      // Appointments History Content
                      Text("Appointment History goes here."),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
