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

  String? firstNameError;
  String? lastNameError;
  String? usernameError;
  String? emailError;
  String? phoneError;
  String? addressError;
  String? passwordError;

  @override
  void initState() {
    super.initState();
  }

  void _submitData() {
    String? firstName = firstNameController.text;
    String? lastName = lastNameController.text;
    String? username = usernameController.text;
    String? email = emailController.text;
    String? phone = phoneController.text;
    String? address = addressController.text;
    String? password = passwordController.text;

    bool isValid = true;

    setState(() {
      firstNameError = firstName.isEmpty ? 'Input field is required' : null;
      lastNameError = lastName.isEmpty ? 'Input field is required' : null;
      usernameError = username.isEmpty ? 'Input field is required' : null;
      emailError = _validateEmail(email) ? null : 'Wrong format for email (e.g. example@gmail.com)';
      phoneError = _validatePhone(phone) ? null : 'Wrong telephone number (e.g. 060 123 4567)';
      passwordError = _validatePassword(password) ? null : 'Password must contain at least 6 characters including letters and numbers';
    });

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        password.isEmpty ||
        emailError != null ||
        phoneError != null ||
        passwordError != null) {
      isValid = false;
    }

    if (isValid) {
      User newUser = User(
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
        _addUser(newUser);
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

  Future<void> _addUser(User newUser) async {
    try {
      var u = await userProvider.insert(newUser);
      var ur = await userProvider.addRole(u.userId!, 'Hairdresser');

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
          "Successfully added a hairdresser", const Color.fromARGB(255, 95, 167, 97));
      Navigator.pop(context, true);
    } catch (e) {
      _showSnackBar('Adding a hairdresser was unsuccessfully, server side error',
          const Color.fromARGB(255, 226, 98, 75));
    }
  }

  bool _validateEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    String emailPattern =
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  bool _validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    String phonePattern = r"^[0-9]{10,12}$"; 
    RegExp regExp = RegExp(phonePattern);
    return regExp.hasMatch(phone);
  }

  bool _validatePassword(String? password) {
    if (password == null || password.length < 6) return false;
    String passwordPattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$";
    RegExp regExp = RegExp(passwordPattern);
    return regExp.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                "Adding new hairdresser",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF607D8B),
                    ),
              ),
            ),

            _buildTextField('Name', firstNameController, firstNameError),
            _buildTextField('Lastname', lastNameController, lastNameError),
            _buildTextField('Username', usernameController, usernameError),
            _buildTextField('Email', emailController, emailError),
            _buildTextField('Telephone number', phoneController, phoneError),
            _buildTextField('Address', addressController, addressError),
            _buildTextField('Password', passwordController, passwordError),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF607D8B),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Add hairdresser',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String? error) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                  color: Color(0xFF607D8B)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color(0xFF607D8B)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF607D8B)),
              ),
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                error,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
