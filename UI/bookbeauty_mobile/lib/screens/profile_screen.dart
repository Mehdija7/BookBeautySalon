import 'package:flutter/material.dart';
import 'package:book_beauty/widgets/customer_info_item.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // Define the theme colors
    final Color dustyBlue = const Color(0xFF748CAB);
    final Color goldGrey = const Color(0xFFC1A57B);
    final Color backgroundGrey = const Color(0xFFF2F2F2);

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
              'Mehdija Sekic',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: dustyBlue,
              ),
            ),
            const SizedBox(height: 40),
            // Customer Info Items with a consistent theme
            CustomerInfoItem(
              title: 'Ime:',
              value: 'Mehdija',
              titleStyle: TextStyle(
                color: dustyBlue,
                fontWeight: FontWeight.bold,
              ),
              valueStyle: TextStyle(
                color: goldGrey,
              ),
            ),
            CustomerInfoItem(
              title: 'Prezime:',
              value: 'Sekic',
              titleStyle: TextStyle(
                color: dustyBlue,
                fontWeight: FontWeight.bold,
              ),
              valueStyle: TextStyle(
                color: goldGrey,
              ),
            ),
            CustomerInfoItem(
              title: 'Grad:',
              value: 'Sanski Most',
              titleStyle: TextStyle(
                color: dustyBlue,
                fontWeight: FontWeight.bold,
              ),
              valueStyle: TextStyle(
                color: goldGrey,
              ),
            ),
            CustomerInfoItem(
              title: 'Adresa:',
              value: 'Sanski Most',
              titleStyle: TextStyle(
                color: dustyBlue,
                fontWeight: FontWeight.bold,
              ),
              valueStyle: TextStyle(
                color: goldGrey,
              ),
            ),
            CustomerInfoItem(
              title: 'Broj telefona:',
              value: '123-456-789',
              titleStyle: TextStyle(
                color: dustyBlue,
                fontWeight: FontWeight.bold,
              ),
              valueStyle: TextStyle(
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
