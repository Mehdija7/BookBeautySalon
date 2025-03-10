import 'dart:async';
import 'package:book_beauty/models/order.dart';
import 'package:book_beauty/models/transaction.dart';
import 'package:book_beauty/providers/order_item_provider.dart';
import 'package:book_beauty/providers/paypalservice.dart';
import 'package:book_beauty/providers/transaction_provider.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:book_beauty/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.order});
  final Order order;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TransactionProvider _transactionProvider = TransactionProvider();
  final PaypalServices _paypalServices = PaypalServices();
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;

  final String returnURL = 'https://api.sandbox.paypal.com/v1/payments/payment';
  final String cancelURL = 'https://api.sandbox.paypal.com/v1/payments/payment';

  final Map<String, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  Future<void> _initializePayment() async {
    try {
      accessToken = await _paypalServices.getAccessToken();
      final transactions = _getOrderParams();
      final res = await _paypalServices.createPaypalPayment(transactions, accessToken);
      if (res != null && mounted) {
        setState(() {
          checkoutUrl = res["approvalUrl"];
          executeUrl = res["executeUrl"];
        });
      }
    } catch (ex) {
      _showSnackBar("Payment initialization failed: ${ex.toString()}");
    }
  }

  Map<String, dynamic> _getOrderParams() {
    List<Map<String, dynamic>> items = [];

    if (widget.order.orderItems != null) {
      for (var orderItem in widget.order.orderItems!) {
        items.add({
          "name": orderItem.product?.name ?? "Unknown Product",
          "quantity": orderItem.quantity ?? 0,
          "price": orderItem.product?.price ?? 0.0,
          "currency": defaultCurrency["currency"] ?? "USD",
        });
      }
    }

    return {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": widget.order.totalPrice.toString(),
            "currency": defaultCurrency["currency"],
            "details": {"subtotal": widget.order.totalPrice.toString(), "shipping": "0", "shipping_discount": "0"}
          },
          "description": "The payment transaction description.",
          "payment_options": {"allowed_payment_method": "INSTANT_FUNDING_SOURCE"},
          "item_list": {"items": items},
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black12,
        elevation: 0.0,
      ),
      body: FutureBuilder(
        future: _initializePayment(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (checkoutUrl != null) {
            return WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..clearCache()
                ..loadRequest(Uri.parse(checkoutUrl!))
                ..setNavigationDelegate(NavigationDelegate(
                  onNavigationRequest: (NavigationRequest request) async {
                    if (request.url.contains(returnURL)) {
                      final uri = Uri.parse(request.url);
                      final payerID = uri.queryParameters['PayerID'];

                      if (payerID != null) {
                        try {
                          await _paypalServices.executePayment(
                              Uri.parse(executeUrl!), payerID, accessToken);
                          Provider.of<OrderItemProvider>(context, listen: false).deleteAllItems();
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => const SuccessScreen()));
                        } catch (error) {
                          _showSnackBar("Payment execution failed: ${error.toString()}");
                        }
                      } else {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const CancelScreen()));
                      }
                    }
                    return NavigationDecision.navigate;
                  },
                )),
            );
          } else {
            return const Center(child: Text("Failed to load payment page."));
          }
        },
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Uspješna transakcija')),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Hvala Vam na kupovini.'),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomeScreen(user: UserProvider.globaluser!)),
                  );
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.lightGreen,
                    foregroundColor: Colors.white),
                child: const Text(
                  "Vrati na početnu",
                ),
              ),
            ]),
      ),
    );
  }
}

class CancelScreen extends StatelessWidget {
  const CancelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Neuspjela transakcija')),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Vaša transakcija je otkazana.'),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomeScreen(user: UserProvider.globaluser!)),
                  );
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white),
                child: const Text(
                  "Vrati na početnu",
                ),
              ),
            ]),
      ),
    );
  }
}

