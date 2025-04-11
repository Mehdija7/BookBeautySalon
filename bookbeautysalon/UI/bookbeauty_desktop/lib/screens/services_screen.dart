import 'dart:convert';
import 'dart:io';
import 'package:bookbeauty_desktop/models/service.dart';
import 'package:bookbeauty_desktop/providers/appointment_provider.dart';
import 'package:bookbeauty_desktop/providers/service_provider.dart';
import 'package:bookbeauty_desktop/screens/new_service_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late List<Service> _registeredServices = [];
  ServiceProvider serviceProvider = ServiceProvider();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      var result = await serviceProvider.get();
      setState(() {
        _registeredServices = result.result.cast<Service>();
        isLoading = false;
      });
      print(_registeredServices);
    } catch (e) {
      print(
          "*****************************ERROR MESSAGE $e ***********************************");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToNewServiceScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewserviceScreen()),
    );

    if (result == 'service_added') {
      _fetchServices();
    }
  }

  void _navigateToEditServiceScreen(Service service) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditServiceScreen(service: service)),
    );

    if (result == 'service_edited') {
      _fetchServices();
    }
  }

  void delete() async {}
  void _deleteService(Service service) async {
    bool shouldDelete = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Warning'),
              content: const Text('Are you sure about deleting this service?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); 
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ) ??
        false;

    if (shouldDelete) {
      setState(() {
        _registeredServices.remove(service); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _navigateToNewServiceScreen,
              icon: const Icon(Icons.add),
              padding: const EdgeInsets.only(left: 40, right: 40),
            ),
          ],
        ),
        isLoading
            ? const CircularProgressIndicator() 
            : _registeredServices.isEmpty
                ? const Text("The list is empty.")
                : Expanded(
                    child: ListView.builder(
                      itemCount: _registeredServices.length,
                      itemBuilder: (context, index) {
                        var service = _registeredServices[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.name!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    service.shortDescription!,
                                    style: const TextStyle(fontSize: 16),
                                  ),

                                  const SizedBox(height: 8),
                                  Text(
                                    'Price: ${service.price} BAM',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () {
                                            _navigateToEditServiceScreen(
                                                service); 
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _deleteService(
                                                service); 
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ],
    );
  }
}

class EditServiceScreen extends StatefulWidget {
  final Service service;

  const EditServiceScreen({super.key, required this.service});

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final _nameController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _longDescriptionController = TextEditingController();
  final _priceController = TextEditingController();
  ServiceProvider serviceProvider = ServiceProvider();
  File? _image;
  String? base64Image;
  String? fileUrl;

  bool _isNameEmpty = false;
  bool _isShortDescriptionEmpty = false;
  bool _isLongDescriptionEmpty = false;
  bool _isPriceEmpty = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.service.name!;
    _shortDescriptionController.text = widget.service.shortDescription!;
    _longDescriptionController.text = widget.service.longDescription!;
    _priceController.text = widget.service.price.toString();
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

  Future<void> _saveChanges() async {
    final enteredPrice = double.tryParse(_priceController.text);

    setState(() {
      _isNameEmpty = _nameController.text.trim().isEmpty;
      _isShortDescriptionEmpty =
          _shortDescriptionController.text.trim().isEmpty;
      _isLongDescriptionEmpty = _longDescriptionController.text.trim().isEmpty;
      _isPriceEmpty = _priceController.text.trim().isEmpty;
    });

    if (_isNameEmpty ||
        _isShortDescriptionEmpty ||
        _isLongDescriptionEmpty ||
        _isPriceEmpty ||
        enteredPrice == null ||
        enteredPrice <= 0) {
      return;
    }

    widget.service.name = _nameController.text;
    widget.service.shortDescription = _shortDescriptionController.text;
    widget.service.longDescription = _longDescriptionController.text;
    widget.service.price = double.parse(_priceController.text);

    await serviceProvider.update(widget.service.serviceId!, widget.service);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Service edited successfully.',
        ),
        backgroundColor: Colors.lightGreen,
      ),
    );
    Navigator.pop(context, 'service_edited');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit service")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _openFilePicker,
                child: _image != null
                    ? Image.file(
                        _image!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : widget.service.image != null
                        ? Image.memory(
                            base64Decode(widget.service.image!),
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/images/logoBB.png", 
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: _nameController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              if (_isNameEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'The field is required.',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: _shortDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Short description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              if (_isShortDescriptionEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'The field is required.',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: _longDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Long description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
              ),
              if (_isLongDescriptionEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'The field is required.',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    suffixText: 'BAM',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              if (_isPriceEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'The field is required.',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
