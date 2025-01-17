import 'package:bookbeauty_desktop/models/gender.dart';
import 'package:bookbeauty_desktop/models/user.dart';
import 'package:bookbeauty_desktop/providers/gender_provider.dart';
import 'package:bookbeauty_desktop/providers/user_provider.dart';
import 'package:flutter/material.dart';

class AddHairdresserScreen extends StatefulWidget {
  const AddHairdresserScreen({super.key});

  @override
  _AddHairdresserScreenState createState() => _AddHairdresserScreenState();
}

class _AddHairdresserScreenState extends State<AddHairdresserScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  String? selectedValue;
  final GenderProvider _genderProvider = GenderProvider();
  List<Gender> genderOptions = [];

  final UserProvider userProvider = UserProvider();

  @override
  void initState() {
    super.initState();
    _fetchGenders();
  }

  Future<void> _fetchGenders() async {
    try {
      var result = await _genderProvider.get();

      setState(() {
        genderOptions = result.result;
        if (genderOptions.isNotEmpty) {
          // Assign the first genderId as the selectedValue
          selectedValue = genderOptions[0].genderId.toString();
        }
      });
    } catch (e) {
      print(
          "*****************************ERROR MESSAGE $e ***********************************");
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Neispravan unos'),
        content: const Text('Molimo Vas popunite sva polja'),
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

  void _submitdata() {
    String? firstName = firstNameController.text;
    String? lastName = lastNameController.text;
    String? username = usernameController.text;
    String? email = emailController.text;
    String? phone = phoneController.text;
    String? address = addressController.text;
    String? password = passwordController.text;
    final selectedGenderId = int.tryParse(selectedValue!) ?? 1;

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        password.isEmpty) {
      _showDialog();
    } else {
      User newuser = User(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        phone: phone,
        address: address,
        genderId: selectedGenderId,
        password: password,
        passwordConfirmed: password,
      );

      try {
        _addUser(newuser);
        print('Successfully added a hairdresser');
      } catch (e) {
        print(e.toString());
      }
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

  Future<void> _addUser(User newuser) async {
    try {
      var u = await userProvider.insert(newuser);
      var ur = await userProvider.addRole(u.userId!, 'Frizer');

      setState(() {
        firstNameController.text = '';
        lastNameController.text = '';
        usernameController.text = '';
        emailController.text = '';
        phoneController.text = '';
        addressController.text = '';
        passwordController.text = '';
        genderController.text = '';
      });
      _showSnackBar(
          "Korisnik uspješno dodan", const Color.fromARGB(255, 95, 167, 97));
      Navigator.pop(context, true);
    } catch (e) {
      _showSnackBar('Neuspješno dodavanje korisnika',
          const Color.fromARGB(255, 226, 98, 75));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj frizera'),
        backgroundColor: const Color(0xFF607D8B), // Dusty blue
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Ime', firstNameController),
            _buildTextField('Prezime', lastNameController),
            _buildTextField('Korisnicko ime', usernameController),
            _buildTextField('Email', emailController),
            _buildTextField('Broj telefona', phoneController),
            _buildTextField('Adresa', addressController),
            _buildTextField('Lozinka', passwordController),
            const SizedBox(height: 20),
            const Text(
              'Spol',
              style: TextStyle(fontSize: 16, color: Color(0xFF455A64)), // Grey
            ),
            genderOptions.isEmpty
                ? const Text(" ")
                : Padding(
                    padding: const EdgeInsets.only(left: 20, top: 15),
                    child: DropdownButton<String>(
                      focusColor: Colors.transparent,
                      value: selectedValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                          genderController.text = selectedValue!;
                          print("Gender CONTROLLER: ${genderController.text}");
                        });
                      },
                      items: genderOptions.map((Gender gender) {
                        // Use genderId as the value
                        return DropdownMenuItem<String>(
                          value: gender.genderId.toString(),
                          child: Text(gender.name!),
                        );
                      }).toList(),
                      dropdownColor: const Color.fromARGB(255, 209, 203, 203),
                    ),
                  ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitdata,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF607D8B), // Dusty blue button
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Dodaj frizera'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF455A64)), // Grey
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color(0xFF607D8B)), // Dusty blue focus color
          ),
        ),
      ),
    );
  }
}
