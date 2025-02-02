import 'dart:io';

import 'package:bookbeauty_desktop/models/category.dart';
import 'package:bookbeauty_desktop/models/service.dart';
import 'package:bookbeauty_desktop/providers/category_provider.dart';
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

  @override
  void initState() {
    super.initState();
  }

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
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
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
            'Molimo Vas unesite ispravna polja naziv, kratki opis, dugi opis, cijena, vrijeme trajanja te slika usluge .'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
    final duration = int.tryParse(_durationController.text);
    final amountIsInvalid = enteredPrice == null || enteredPrice <= 0;
    final timeIsInvalid = duration == null || duration <= 0;
    String? imagePath = fileUrl;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _titleController.text.trim().isEmpty ||
        _shortDescriptionController.text.trim().isEmpty ||
        _longDescriptionController.text.trim().isEmpty ||
        _durationController.text.trim().isEmpty ||
        imagePath == '' ||
        timeIsInvalid) {
      _showDialog();
      return;
    }
    Service newservice = Service(
        name: _titleController.text,
        price: enteredPrice,
        shortDescription: _shortDescriptionController.text,
        longDescription: _longDescriptionController.text,
        duration: duration,
        image: imagePath);
    _addservice(newservice);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MainTitle(title: 'Dodavanje nove usluge'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    controller: _shortDescriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Kratki opis ',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 200, left: 20),
                  child: TextField(
                    controller: _longDescriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Duzi opis ',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 200, left: 20, bottom: 20),
                  child: TextField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                        hintText: 'Vrijeme trajanja', suffixText: 'min'),
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
                    child: const Text('Dodaj uslugu'),
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
