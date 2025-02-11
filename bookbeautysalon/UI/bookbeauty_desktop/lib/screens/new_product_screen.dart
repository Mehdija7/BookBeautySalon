import 'dart:convert';
import 'dart:io';

import 'package:bookbeauty_desktop/models/category.dart';
import 'package:bookbeauty_desktop/models/product.dart';
import 'package:bookbeauty_desktop/providers/category_provider.dart';
import 'package:bookbeauty_desktop/providers/product_provider.dart';
import 'package:bookbeauty_desktop/utils.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/shared/main_title.dart';
import 'package:flutter/material.dart';

class NewProductScreen extends StatefulWidget {
  const NewProductScreen({super.key});

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  String? selectedValue;
  late List<Category> _registeredCategories = [];
  CategoryProvider categoryProvider = CategoryProvider();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  File? _image;
  String? fileUrl;
  ProductProvider productProvider = ProductProvider();
  String? base64Image;
  late ImageProvider _productImage;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      var result = await categoryProvider.get();

      setState(() {
        _registeredCategories = result.result;
        if (_registeredCategories.isNotEmpty) {
          selectedValue = _registeredCategories[0].categoryId.toString();
        }
      });
    } catch (e) {
      print(
          "*****************************ERROR MESSAGE $e ***********************************");
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
        _productImage = imageFromBase64String(base64Image!).image;
        _image = File(result.files.single.path!);
        fileUrl = _image?.path;
      });
    }
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Neispravan unos'),
              content: const Text(
                  'Molimo Vas unesite ispravan naziv, opis, cijenu, kategoriju i sliku proizvoda.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _submitData() {
    final enteredPrice = double.tryParse(_priceController.text);
    final selectedCategoryId = int.tryParse(selectedValue!);
    final amountIsInvalid = enteredPrice == null || enteredPrice <= 0;
    String? imagePath = fileUrl;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        imagePath == '') {
      _showDialog();
      return;
    }
    Product newproduct = Product(
        name: _titleController.text,
        price: enteredPrice,
        categoryId: selectedCategoryId,
        description: _descriptionController.text,
        image: base64Image);
    _addProduct(newproduct);
  }

  Future<void> _addProduct(Product newproduct) async {
    try {
      var id = await productProvider.insert(newproduct);
      setState(() {
        _titleController.text = '';
        _priceController.text = '';
        _image = null;
        _descriptionController.text = '';
      });
      _showSnackBar(
          "Proizvod uspješno dodan", const Color.fromARGB(255, 95, 167, 97));
    } catch (e) {
      _showSnackBar('Neuspješno dodavanje proizvoda',
          const Color.fromARGB(255, 226, 98, 75));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MainTitle(title: 'Dodavanje novog proizvoda'),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 200, left: 20, bottom: 10),
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Naziv',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 200, left: 20, bottom: 20),
                  child: TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                        hintText: 'Cijena', suffixText: 'BAM'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 200, left: 20),
                  child: TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Opis proizvoda',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 15),
                  child: Text(
                    'Kategorija',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 114, 111, 111),
                        fontWeight: FontWeight.w600),
                  ),
                ),
                _registeredCategories.isEmpty
                    ? const Text("Dodajte kategorije")
                    : Padding(
                        padding: const EdgeInsets.only(left: 20, top: 15),
                        child: DropdownButton<String>(
                          focusColor: Colors.transparent,
                          value: selectedValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue!;
                              _categoryController.text = selectedValue!;
                              print(
                                  "CATEGORY CONTROLLER: ${_categoryController.text}");
                            });
                          },
                          items: _registeredCategories.map((Category category) {
                            return DropdownMenuItem<String>(
                              value: category.categoryId.toString(),
                              child: Text(category.name!),
                            );
                          }).toList(),
                        ),
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Slika: '),
                Padding(
                  padding: const EdgeInsets.only(top: 0, right: 0),
                  child: GestureDetector(
                    onTap: _openFilePicker,
                    child: _image != null
                        ? Image.file(
                            _image!,
                            width: 400,
                            height: 400,
                          )
                        : Image.asset(
                            'assets/images/pravaslika.png',
                            width: 400,
                            height: 400,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 500, top: 100),
                  child: ElevatedButton(
                    onPressed: () {
                      _submitData();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return const Color.fromARGB(255, 111, 160, 103);
                          }
                          return const Color.fromARGB(255, 150, 216, 156);
                        },
                      ),
                      foregroundColor: WidgetStateProperty.all<Color>(
                          const Color.fromARGB(255, 245, 245, 245)),
                    ),
                    child: const Text('Dodaj proizvod'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
