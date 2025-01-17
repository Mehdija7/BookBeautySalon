import 'package:book_beauty/widgets/buy_button.dart';
import 'package:flutter/material.dart';

class MyFormPage extends StatefulWidget {
  const MyFormPage({super.key});

  @override
  State createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  late String _nameErrorText = '';
  late String _phoneNumberErrorText = '';
  late String _addressErrorText = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Ime i prezime',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Ime Prezime',
                border: const OutlineInputBorder(),
                errorText: _nameErrorText,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite svoje ime i prezime';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Broj telefona',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '+387601237654',
                border: const OutlineInputBorder(),
                errorText: _phoneNumberErrorText,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite svoj broj telefona';
                }
                if (!isNumeric(value)) {
                  return 'Unesite validan broj telefona';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Adresa',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _addressController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Naziv Ulice, Naziv Grada',
                border: const OutlineInputBorder(),
                errorText: _addressErrorText,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite svoju adresu';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            BuyButton(
              validateInputs: _validateInputs,
              isFromOrder: false,
            ),
          ],
        ),
      ),
    );
  }

  bool _validateInputs() {
    bool isValid = true;

    if (_nameController.text.isEmpty) {
      setState(() {
        _nameErrorText = 'Unesite svoje ime i prezime';
      });
      isValid = false;
    }

    if (_phoneNumberController.text.isEmpty) {
      setState(() {
        _phoneNumberErrorText = 'Unesite vas broj telefona';
      });
      isValid = false;
    } else if (!isNumeric(_phoneNumberController.text)) {
      setState(() {
        _phoneNumberErrorText = 'Unesite validan broj telefona';
      });
      isValid = false;
    }

    if (_addressController.text.isEmpty) {
      setState(() {
        _addressErrorText = 'Unesite adresu';
      });
      isValid = false;
    }

    return isValid;
  }

  bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }
}
