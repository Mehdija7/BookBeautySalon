import 'dart:convert';
import 'dart:io';

import 'package:bookbeauty_desktop/models/service.dart';
import 'package:bookbeauty_desktop/providers/service_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/shared/main_title.dart';
import 'package:flutter/material.dart';

class NewserviceScreen extends StatefulWidget {
  const NewserviceScreen({super.key});

  @override
  State<NewserviceScreen> createState() => _NewserviceScreenState();
}

class _NewserviceScreenState extends State<NewserviceScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _longDescriptionController = TextEditingController();
  final _durationController = TextEditingController();
  File? _image;
  String? fileUrl;
  ServiceProvider serviceProvider = ServiceProvider();
  String? base64Image;

  bool _isTitleEmpty = false;
  bool _isPriceEmpty = false;
  bool _isShortDescriptionEmpty = false;
  bool _isLongDescriptionEmpty = false;
  bool _isDurationEmpty = false;
  bool _isImageEmpty = false;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _shortDescriptionController.dispose();
    _longDescriptionController.dispose();
    _durationController.dispose();
    super.dispose();
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
        _image = File(result.files.single.path!);
        fileUrl = _image?.path;
        _isImageEmpty = false;
      });
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Future<void> _addservice(Service newservice) async {
    try {
      var id = await serviceProvider.insert(newservice);
      setState(() {
        _titleController.text = '';
        _priceController.text = '';
        _image = null;
        _shortDescriptionController.text = '';
        _longDescriptionController.text = '';
        _durationController.text = '';
      });
      _showSnackBar('Usluga uspješno dodana!', Colors.green);
      Navigator.pop(context, 'service_added');
    } catch (e) {
      _showSnackBar('Neuspješno dodavanje usluge.', Colors.red);
    }
  }

  void _submitData() {
    final enteredPrice = double.tryParse(_priceController.text);
    final duration = int.tryParse(_durationController.text);
    final amountIsInvalid = enteredPrice == null || enteredPrice <= 0;
    final timeIsInvalid = duration == null || duration <= 0;

    setState(() {
      _isTitleEmpty = _titleController.text.trim().isEmpty;
      _isPriceEmpty = _priceController.text.trim().isEmpty;
      _isShortDescriptionEmpty =
          _shortDescriptionController.text.trim().isEmpty;
      _isLongDescriptionEmpty = _longDescriptionController.text.trim().isEmpty;
      _isDurationEmpty = _durationController.text.trim().isEmpty;
      _isImageEmpty = _image == null;
    });

    if (_isTitleEmpty ||
        amountIsInvalid ||
        _isPriceEmpty ||
        _isShortDescriptionEmpty ||
        _isLongDescriptionEmpty ||
        _isDurationEmpty ||
        _isImageEmpty ||
        timeIsInvalid) {
      return;
    }

    Service newservice = Service(
        name: _titleController.text,
        price: enteredPrice,
        shortDescription: _shortDescriptionController.text,
        longDescription: _longDescriptionController.text,
        duration: duration,
        image: base64Image);

    _addservice(newservice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left side for fields
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MainTitle(title: 'Dodavanje nove usluge'),
                  SizedBox(height: 20),
                  // Title Field
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Naziv',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        if (_isTitleEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'Obavezno polje',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Price Field
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Cijena',
                            suffixText: 'BAM',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        if (_isPriceEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'Obavezno polje',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Short Description Field
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _shortDescriptionController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Kratki opis',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        if (_isShortDescriptionEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'Obavezno polje',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Long Description Field
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _longDescriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Duži opis',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        if (_isLongDescriptionEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'Obavezno polje',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Duration Field
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _durationController,
                          decoration: const InputDecoration(
                            labelText: 'Vrijeme trajanja',
                            suffixText: 'min',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        if (_isDurationEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'Obavezno polje',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Right side for image placeholder
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    const Text('Slika:', style: TextStyle(fontSize: 16)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: _openFilePicker,
                        child: _image != null
                            ? Image.file(
                                _image!,
                                width: 350,
                                height: 350,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/pravaslika.png',
                                width: 350,
                                height: 350,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    if (_isImageEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Obavezno polje',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: _submitData,
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 15),
            ),
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
          child: const Text('Dodaj uslugu'),
        ),
      ),
    );
  }
}
