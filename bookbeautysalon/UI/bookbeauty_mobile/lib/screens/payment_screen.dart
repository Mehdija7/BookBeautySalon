import 'dart:async';
import 'package:book_beauty/models/order.dart';
import 'package:book_beauty/models/transaction.dart';
import 'package:book_beauty/models/user.dart';
import 'package:book_beauty/providers/order_item_provider.dart';
import 'package:book_beauty/providers/paypalservice.dart';
import 'package:book_beauty/providers/transaction_provider.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:book_beauty/screens/home_screen.dart';
import 'package:book_beauty/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:app_links/app_links.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.order});

  final Order order;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  StreamSubscription? _sub;
  final TransactionProvider _transactionProvider = TransactionProvider();

  late List<Map<String, dynamic>> itemList = [];
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final PaypalServices _paypalServices = PaypalServices();

  final Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  final String returnURL = 'https://api.sandbox.paypal.com/v1/payments/payment';
  final String cancelURL = 'https://api.sandbox.paypal.com/v1/payments/payment';

  @override
  void initState() {
    super.initState();
    addOrder();
    _initializePayment();
  }

  void addOrder() {}

  Future<void> _initializePayment() async {
    try {
      accessToken = await _paypalServices.getAccessToken();

      final transactions = _getOrderParams();
      final res =
          await _paypalServices.createPaypalPayment(transactions, accessToken);
      if (res != null) {
        setState(() {
          checkoutUrl = res["approvalUrl"];
          executeUrl = res["executeUrl"];
        });
      }
    } catch (ex) {
      _showSnackBar(ex.toString());
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

    for (var i in items) {
      print("****** ITEM IN ITEMS IN PAYMENT SCREEN ****** ");
      print(i);
    }
    return {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": widget.order.totalPrice,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": widget.order.totalPrice,
              "shipping": "0",
              "shipping_discount": "0"
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    print("----- ORDER ID ------- ");
    print(widget.order.orderId);
    Transaction newTransaction = Transaction(
        orderId: widget.order.orderId,
        price: widget.order.totalPrice,
        name: 'transaction',
        status: 'Created');
    final _orderItemProvider =
        Provider.of<OrderItemProvider>(context, listen: false);
    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(checkoutUrl!))
            ..setNavigationDelegate(NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) async {
                print(
                    "+++++++++++++++++++++++++++++++++++++++++ REQUEST URL +++++++++++++++++++++++++++++++++++++++++++++++++++++++");
                print(request.url);
                if (request.url.contains(returnURL)) {
                  final uri = Uri.parse(request.url);
                  final payerID = uri.queryParameters['PayerID'];
                  print(
                      "+++++++++++++++++++++++++++++++++++++++ PAYER ID +++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
                  print(payerID);

                  if (payerID != null) {
                    print(
                        "+++++++++++++++++++++++++++++++++++++++ EXECUTE URL +++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
                    print(executeUrl);

                    _paypalServices
                        .executePayment(
                            Uri.parse(executeUrl!), payerID, accessToken)
                        .then((id) async {
                      _orderItemProvider.deleteAllItems();
                      print(
                          "////////////////// PLACENO USPJESNO   ////////////////////////");
                      newTransaction.status = 'Succeed';
                      var r = await _transactionProvider.insert(newTransaction);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SuccessScreen()));
                    });
                  } else {
                    newTransaction.status = 'Canceled';
                    var r = await _transactionProvider.insert(newTransaction);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CancelScreen()));
                  }
                }
                if (request.url.contains(cancelURL)) {}
                return NavigationDecision.navigate;
              },
            )),
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
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
