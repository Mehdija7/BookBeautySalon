import 'dart:convert';
import 'dart:io';
import 'package:bookbeauty_desktop/models/news.dart';
import 'package:bookbeauty_desktop/providers/news_provider.dart';
import 'package:bookbeauty_desktop/providers/user_provider.dart';
import 'package:bookbeauty_desktop/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddNewsScreen extends StatefulWidget {
  const AddNewsScreen({super.key});

  @override
  State<AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  final _formKey = GlobalKey<FormState>();
  final NewsProvider newsProvider = NewsProvider();
  final UserProvider userProvider = UserProvider();
  String? title;
  String? text;
  File? _image;
  String? base64Image;
  late ImageProvider _productImage;

  String? _validateField(String? value, String errorMessage) {
    return (value == null || value.isEmpty) ? errorMessage : null;
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final news = News(
        dateTime: DateTime.now(),
        title: title,
        text: text,
        newsImage: base64Image,
        hairdresserId: UserProvider.globalUserId,
      );

      try {
        await newsProvider.insert(news);
        _formKey.currentState!.reset();
        setState(() {
          text = "";
          title = "";
          _image = null;
        });
        _showSnackBar('News added successfully', Colors.lightGreen);
      } catch (e) {
        _showSnackBar('Adding news was unsuccessfully', Colors.red);
      }
    }
  }

  void _openFilePicker() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      final file = File(result.files.single.path!);
      setState(() {
        base64Image = base64Encode(file.readAsBytesSync());
        _productImage = imageFromBase64String(base64Image!).image;
        _image = file;
      });
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adding news')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTextField('Title', (value) => title = value, (v) => _validateField(v, 'This field is required.')),
              const SizedBox(height: 20.0),
              _buildTextField('Content', (value) => text = value, (v) => _validateField(v, 'This field is required.'), maxLines: 10),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: _openFilePicker,
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 50, color: Colors.grey),
                              SizedBox(height: 10),
                              Text('Add image', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: const Color.fromARGB(255, 150, 216, 156),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Add news', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged, String? Function(String?)? validator, {int maxLines = 1}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 16),
    );
  }
}
