import 'package:bookbeauty_desktop/models/product.dart';
import 'package:bookbeauty_desktop/providers/product_provider.dart';
import 'package:bookbeauty_desktop/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';

class ButtonsList extends StatefulWidget {
  const ButtonsList(
      {super.key,
      required this.product,
      required this.activeProduct,
      required this.hideProduct,
      required this.editProduct,
      required this.updateProduct});

  final Product product;
  final void Function(Product product) activeProduct;
  final void Function(Product product) hideProduct;
  final void Function(Product product) editProduct;
  final Future<Product> Function (Product product) updateProduct;
  @override
  State<ButtonsList> createState() => _ButtonsListState();
}

class _ButtonsListState extends State<ButtonsList> {
  late Product _product;
  ProductProvider productProvider = ProductProvider();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    try {
      var result = await productProvider.getById(_product.productId!);
      setState(() {
        _product = result;
        isLoading = false;
      });
      print(_product);
    } catch (e) {
      _product = widget.product;
      print(
          "*****************************ERROR MESSAGE $e ***********************************");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void editingProduct() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ProductDetailScreen(id: widget.product.productId!,updateProduct: widget.updateProduct,),
        ),
      );
    }

    if (widget.product.stateMachine == 'draft') {
      return Row(
        children: [
          TextButton(
            onPressed: () {
              widget.activeProduct(_product);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              backgroundColor: const Color.fromARGB(255, 169, 243, 100),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Active',
              textAlign: TextAlign.center,
            ),
          ),
               const   SizedBox(width: 10),
            TextButton(
          onPressed: () {
            widget.editProduct(_product);
            editingProduct();
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            backgroundColor: const Color.fromARGB(255, 243, 205, 100),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Edit',
            textAlign: TextAlign.center,
          ),
        ),
        ],
      );
    } else if (widget.product.stateMachine == 'hidden') {
      return Row(children: [
        TextButton(
          onPressed: () {
            widget.editProduct(_product);
            editingProduct();
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            backgroundColor: const Color.fromARGB(255, 243, 205, 100),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Draft',
            textAlign: TextAlign.center,
          ),
        ),

      ]);
    } else {
      return TextButton(
        onPressed: () {
          widget.hideProduct(_product);
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          backgroundColor: const Color.fromARGB(255, 243, 100, 112),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Hide',
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
