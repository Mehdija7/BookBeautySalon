import 'package:book_beauty/screens/appointment_screen.dart';
import 'package:book_beauty/screens/edit_screen.dart';
import 'package:book_beauty/screens/login_screen.dart';
import 'package:book_beauty/screens/orders_screen.dart';
import 'package:book_beauty/screens/products_screen.dart';
import 'package:book_beauty/models/user.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:book_beauty/widgets/customer_info_item.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProvider userProvider = UserProvider();
  bool isLoading = true;
  User? user;

  @override
  void initState() {
    super.initState();
    _fetchUser(); 
  }

  Future<void> _fetchUser() async {
    try {
      int userId = UserProvider.globalUserId ?? 0;
      if (userId == 0) {
        throw Exception("Invalid user ID");
      }
      var result = await userProvider.getById(userId);
      setState(() {
        user = result;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching user: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void goToEditScreen() async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (ctx) => EditScreen(user: UserProvider.globaluser!)),
    );
    if (result == true) {
      _fetchUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color dustyBlue = Color(0xFF748CAB);
    const Color goldGrey = Color(0xFFC1A57B);
    const Color backgroundGrey = Color(0xFFF2F2F2);

    return Scaffold(
      backgroundColor: backgroundGrey,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text("Failed to load user data"))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        ClipOval(
                          child: Image.asset(
                            'assets/images/user.jpg',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: goToEditScreen,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${user!.firstName} ${user!.lastName}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: dustyBlue,
                          ),
                        ),
                        const SizedBox(height: 30),
                        CustomerInfoItem(
                            title: 'First name:',
                            value: user!.firstName ?? '',
                            titleStyle: const TextStyle(
                                color: dustyBlue, fontWeight: FontWeight.bold),
                            valueStyle: const TextStyle(color: goldGrey)),
                        CustomerInfoItem(
                            title: 'Last name:',
                            value: user!.lastName ?? '',
                            titleStyle: const TextStyle(
                                color: dustyBlue, fontWeight: FontWeight.bold),
                            valueStyle: const TextStyle(color: goldGrey)),
                        CustomerInfoItem(
                            title: 'Address:',
                            value: user!.address ?? '',
                            titleStyle: const TextStyle(
                                color: dustyBlue, fontWeight: FontWeight.bold),
                            valueStyle: const TextStyle(color: goldGrey)),
                        CustomerInfoItem(
                            title: 'Telephone number:',
                            value: user!.phone ?? '',
                            titleStyle: const TextStyle(
                                color: dustyBlue, fontWeight: FontWeight.bold),
                            valueStyle: const TextStyle(color: goldGrey)),
                        CustomerInfoItem(
                          title: 'Email:',
                          value: user!.email ?? '',
                          titleStyle: const TextStyle(
                            color: dustyBlue,
                            fontWeight: FontWeight.bold,
                          ),
                          valueStyle: const TextStyle(
                            color: goldGrey,
                          ),
                        
                        ),
                        const SizedBox(height: 30),
                        _buildCard("My orders",
                            icon: Icons.shopping_cart_outlined,
                            iconColor: Colors.blueGrey,
                            path: 'orders'),
                        _buildCard("My appointments",
                            icon: Icons.book, path: 'appointments'),
                        _buildCard("Favorite products",
                            icon: Icons.favorite,
                            iconColor: Colors.redAccent,
                            path: 'favorites'),
                        const SizedBox(height: 60),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: dustyBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.logout, color: backgroundGrey),
                          label: const Text("Log out"),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (ctx) => const LoginScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildCard(String title,
      {IconData? icon, Color? iconColor, String? path}) {
    return GestureDetector(
      onTap: () {
        if (path != null) {
          if (path == 'orders') {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const OrdersScreen()),
            );
          }
          if (path == 'favorites') {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (ctx) => const ProductsScreen(
                        favoritesOnly: true,
                      )),
            );
          }
          if (path == 'appointments') {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (ctx) =>
                      AppointmentScreen(userId: UserProvider.globalUserId!)),
            );
          }
        }
      },
      child: Card(
        color: const Color.fromARGB(135, 255, 250, 236),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  if (icon != null)
                    Icon(
                      icon,
                      color: iconColor ?? const Color.fromARGB(255, 183, 187, 191),
                    ),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
