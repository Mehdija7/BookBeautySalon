import 'package:bookbeauty_desktop/models/order.dart';
import 'package:bookbeauty_desktop/models/user.dart';
import 'package:bookbeauty_desktop/providers/order_provider.dart';
import 'package:bookbeauty_desktop/providers/user_provider.dart';
import 'package:bookbeauty_desktop/widgets/order/order_items.dart';
import 'package:bookbeauty_desktop/widgets/shared/main_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewOrderScreen extends StatefulWidget {
  NewOrderScreen({super.key, required this.order});
  Order order;

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  late User user;
  late UserProvider userProvider;
  late OrderProvider orderProvider;
  bool isLoading = true;

  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    orderProvider = context.read<OrderProvider>();
    super.initState();
    _fetchUser();
  }

  Future<void> changeState() async {
    setState(() {
      isLoading = true; // Set loading state while the update happens
    });

    Order o = widget.order;

    try {
      if (widget.order.status!.toLowerCase() == 'kreirana') {
        o.status = "Isporucena"; // Update status to 'Isporucena'
      } else if (widget.order.status!.toLowerCase() == 'isporucena') {
        o.status = "Dostavljena"; // Update status to 'Dostavljena'
      }

      var result = await orderProvider.update(widget.order.orderId!, o);

      setState(() {
        widget.order = result; // Update the order after successful update
        isLoading = false; // Set loading state to false
      });
      Navigator.of(context).pop(true);
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false; // Handle loading state after error
      });
    }
  }

  Future<void> _fetchUser() async {
    try {
      int userId = widget.order.customerId ?? 0;
      var result = await userProvider.getById(userId);
      setState(() {
        user = result;
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

  @override
  Widget build(BuildContext context) {
    late Color buttonColor;
    late String buttonText;

    switch (widget.order.status!.toLowerCase()) {
      case 'kreirana':
        buttonColor = const Color.fromARGB(255, 172, 247, 150); // Green
        buttonText = 'Oznaci kao spakovano';
        break;
      case 'isporucena':
        buttonColor = const Color.fromARGB(255, 255, 165, 0); // Orange
        buttonText = 'Oznaci kao poslano';
        break;
      case 'dostavljena':
        buttonColor = const Color.fromARGB(255, 255, 69, 58); // Red
        buttonText = 'Narudzba je poslana';
        break;
      default:
        buttonColor = Colors.grey; // Default case if status is not recognized
        buttonText = 'Nepoznato stanje';
    }

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const MainTitle(title: 'Narudzba'),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "ID narudzbe: ${widget.order.orderNumber}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: OrderItems(
                    items: widget.order!.orderItems!,
                    totalPrice: widget.order.totalPrice.toString(),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Informacije o kupcu',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 200, left: 20, bottom: 20),
                        child: Text('Adresa:  ${user.address}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 200, left: 20, bottom: 20),
                        child: Text('Ime:  ${user.firstName} ${user.lastName}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 200, left: 20, bottom: 20),
                        child: Text('Broj:  ${user.phone}'),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          changeState();
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(buttonColor),
                          foregroundColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(255, 245, 245, 245)),
                        ),
                        child: Text(buttonText),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
