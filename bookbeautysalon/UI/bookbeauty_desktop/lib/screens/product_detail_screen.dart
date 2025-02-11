import 'dart:convert';
import 'dart:io';
import 'package:bookbeauty_desktop/screens/products_list_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:bookbeauty_desktop/models/product.dart';
import 'package:bookbeauty_desktop/providers/product_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.id});

  final int id;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _product;
  ProductProvider productProvider = ProductProvider();
  bool isLoading = true;
  bool isEditing = false;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _image;
  String? base64Image;
  String? fileUrl;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  void checkState() {
    var value = true;
    if (_product!.stateMachine != "draft") {
      value = false;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text('Upozorenje'),
                content: Text(
                    'Onemoguceno je uredjivanje proizvoda za stanje ${_product!.stateMachine}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ]);
          });
    }

    setState(() {
      isEditing = value;
    });
  }

  Future<void> _fetchProduct() async {
    try {
      var result = await productProvider.getById(widget.id);
      setState(() {
        _product = result;
        _descriptionController.text = _product?.description ?? '';
        _priceController.text = _product?.price?.toStringAsFixed(2) ?? '';
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching product: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> edit() async {
    try {
      if (_product != null) {
        _product!.description = _descriptionController.text;
        _product!.price = double.tryParse(_priceController.text);
        if (_image != null) {
          _product!.image = base64Encode(await _image!.readAsBytes());
        }
        var product =
            await productProvider.update(_product!.productId!, _product);

        setState(() {
          _product = product;
          isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Proizvod uspjesno spremljen'),
          backgroundColor: Colors.lightGreen,
        ));
      }
    } catch (e) {
      print("Error updating product: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Greska prilikom spremanja proizvoda.')));
    }
  }

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final bytes = file.readAsBytesSync();
      setState(() {
        base64Image = base64Encode(bytes);
        _image = file;
        fileUrl = _image?.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product?.name ?? 'Loading...'),
        backgroundColor: const Color.fromARGB(157, 201, 198, 198),
      ),
      body: _product == null || isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              color: const Color.fromARGB(157, 201, 198, 198),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: isEditing ? _openFilePicker : null,
                      child: _image != null
                          ? Image.file(
                              _image!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : _product?.image != null
                              ? Image.memory(
                                  base64Decode(_product!.image!),
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/images/logoBB.png", // Default placeholder
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: _product?.description ??
                              'Enter product description...',
                          labelText: 'Description',
                        ),
                        enabled:
                            isEditing, // Enable editing only if isEditing is true
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Enter price...',
                          labelText: 'Price',
                        ),
                        enabled:
                            isEditing, // Enable editing only if isEditing is true
                      ),
                    ),

                    // Edit or Save Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: isEditing
                          ? TextButton(
                              onPressed: edit,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 50),
                                backgroundColor:
                                    const Color.fromARGB(255, 145, 228, 163),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Spremi',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                checkState();
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 50),
                                backgroundColor:
                                    const Color.fromARGB(255, 243, 205, 100),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Uredi',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
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
