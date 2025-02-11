import 'package:bookbeauty_desktop/models/user.dart';
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

  final UserProvider userProvider = UserProvider();

  @override
  void initState() {
    super.initState();
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
          // Dusty blue
          ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Heading
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                "Dodavanje novog frizera",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF607D8B), // Dusty Blue for title
                    ),
              ),
            ),

            // Input Fields
            _buildTextField('Ime', firstNameController),
            _buildTextField('Prezime', lastNameController),
            _buildTextField('Korisnicko ime', usernameController),
            _buildTextField('Email', emailController),
            _buildTextField('Broj telefona', phoneController),
            _buildTextField('Adresa', addressController),
            _buildTextField('Lozinka', passwordController),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _submitdata,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF607D8B), // Dusty blue button
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Dodaj frizera',
                  style: TextStyle(color: Colors.white),
                ),
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
          labelStyle: const TextStyle(
              color: Color(0xFF607D8B)), // Dusty blue for labels
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Color(0xFF607D8B)), // Dusty blue border color
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF607D8B)),
          ),
        ),
      ),
    );
  }
}
