import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../models/service.dart';

class NewService extends StatefulWidget {
  const NewService(this.onAddService, {super.key});

  final Future<void> Function(Service service, File image) onAddService;

  @override
  State<NewService> createState() {
    return _NewServiceState();
  }
}

class _NewServiceState extends State<NewService> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _longDescriptionController = TextEditingController();
  final _durationController = TextEditingController();
  File? _image;
  String? fileUrl;

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

  /*Future<void> _uploadFile(int id) async {
    if (_image == null) return;
    try {
      await uploadService.uploadFileService(_image!, id);
    } catch (e) {
      print('Error upload product: $e');
    }
  }*/

  void _showDialog() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Neispravan unos'),
              content: const Text(
                  'Molimo Vas unesite ispravan naziv, kratki opis,dugi opis, cijenu i vrijeme trajanja usluge.'),
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

  void _submitData() {
    final enteredPrice = double.tryParse(_priceController.text);
    final enteredDuration = int.tryParse(_durationController.text);
    final amountIsInvalid = enteredPrice == null || enteredPrice <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _shortDescriptionController.text.trim().isEmpty ||
        _longDescriptionController.text.trim().isEmpty ||
        _durationController.text.trim().isEmpty ||
        _image == null) {
      _showDialog();
      return;
    }
    var result = widget.onAddService(
        Service(
            name: _titleController.text,
            price: enteredPrice,
            shortDescription: _shortDescriptionController.text,
            longDescription: _longDescriptionController.text,
            duration: enteredDuration,
            image: ''),
        _image!);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constrains) {
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(label: Text('Naziv')),
                  ),
                  const SizedBox(width: 22),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        label: Text('Cijena'), prefixText: 'BAM'),
                  ),
                  TextField(
                    controller: _shortDescriptionController,
                    maxLines: 2,
                    decoration:
                        const InputDecoration(label: Text('Kratki opis')),
                  ),
                  TextField(
                    controller: _longDescriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(label: Text('Dugi opis')),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                        label: Text("Vrijeme trajanja"), prefixText: 'min'),
                  ),
                  const SizedBox(height: 15),
                  const Text('Slika: '),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
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
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Odustani'),
                      ),
                      ElevatedButton(
                        onPressed: _submitData,
                        child: const Text(
                          'Spremi',
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
