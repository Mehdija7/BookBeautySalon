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
  // Controllers
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();

  // Providers
  final CategoryProvider categoryProvider = CategoryProvider();
  final ProductProvider productProvider = ProductProvider();

  // UI State
  String? selectedValue;
  late List<Category> _registeredCategories = [];
  File? _image;
  String? fileUrl;
  String? base64Image;
  late ImageProvider _productImage;

  // Validation Errors
  String? _titleError;
  String? _priceError;
  String? _descriptionError;
  String? _imageError;

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
      print("ERROR MESSAGE $e");
    }
  }

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
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

  bool _validateFields() {
    bool isValid = true;

    setState(() {
      _titleError = null;
      _priceError = null;
      _descriptionError = null;
      _imageError = null;

      if (_titleController.text.trim().isEmpty) {
        _titleError = "This field is required.";
        isValid = false;
      }

      if (_priceController.text.trim().isEmpty) {
        _priceError = "This field is required.";
        isValid = false;
      } else if (double.tryParse(_priceController.text.trim()) == null) {
        _priceError = "Wrong format. Use a valid number.";
        isValid = false;
      }

      if (_descriptionController.text.trim().isEmpty) {
        _descriptionError = "This field is required.";
        isValid = false;
      }

      if (_image == null) {
        _imageError = "Image is required.";
        isValid = false;
      }
    });

    return isValid;
  }

  void _submitData() {
    if (!_validateFields()) return;

    final enteredPrice = double.parse(_priceController.text);
    final selectedCategoryId = int.tryParse(selectedValue!);
    Product newproduct = Product(
      name: _titleController.text.trim(),
      price: enteredPrice,
      categoryId: selectedCategoryId,
      description: _descriptionController.text.trim(),
      stateMachine: 'Draft',
      image: base64Image,
    );

    _addProduct(newproduct);
  }

  Future<void> _addProduct(Product newproduct) async {
    try {
      await productProvider.insert(newproduct);
      setState(() {
        _titleController.clear();
        _priceController.clear();
        _descriptionController.clear();
        _image = null;
      });
      _showSnackBar("Product added successfully.", Colors.green);
    } catch (e) {
      _showSnackBar("Adding product was unsuccessful.", Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MainTitle(title: 'Adding new product'),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  if (_titleError != null)
                    Text(_titleError!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Price', suffixText: 'BAM'),
                  ),
                  if (_priceError != null)
                    Text(_priceError!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                  ),
                  if (_descriptionError != null)
                    Text(_descriptionError!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 20),
                  const Text('Category',
                      style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  _registeredCategories.isEmpty
                      ? const Text("Add categories")
                      : DropdownButton<String>(
                          value: selectedValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue!;
                              _categoryController.text = selectedValue!;
                            });
                          },
                          items: _registeredCategories
                              .map((Category category) => DropdownMenuItem<String>(
                                    value: category.categoryId.toString(),
                                    child: Text(category.name!),
                                  ))
                              .toList(),
                        ),
                ],
              ),
            ),
            const SizedBox(width: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Image:'),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _openFilePicker,
                  child: _image != null
                      ? Image.file(_image!, width: 400, height: 400)
                      : Image.asset('assets/images/pravaslika.png', width: 400, height: 400),
                ),
                if (_imageError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(_imageError!, style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 150, 216, 156),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Add product'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
