import 'package:book_beauty/models/user.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:book_beauty/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final UserProvider _userProvider = UserProvider();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _handleRegistration() async {
    setState(() {});
    if (_formKey.currentState!.validate()) {
      User newUser = User(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        passwordConfirmed: _confirmPasswordController.text,
      );
      var u = await _userProvider.registrate(newUser);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration was successfully!'), backgroundColor: Colors.green),
      );
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logoBB2.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 100,
                ),
              ],
            ),
          ),
          Positioned.fill(
            top: 100,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 190, 187, 168).withOpacity(0.4),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ListView(
                    children: [
                      _buildLabel('First name'),
                      _buildTextField(_firstNameController),
                      _buildLabel('Last name'),
                      _buildTextField(_lastNameController),
                      _buildLabel('Address'),
                      _buildTextField(_addressController),
                      _buildLabel('Email'),
                      _buildTextField(_emailController, isEmail: true),
                      _buildLabel('Telephone number'),
                      _buildTextField(_phoneController, isPhone: true),
                      _buildLabel('Username'),
                      _buildTextField(_usernameController),
                      _buildLabel('Password'),
                      _buildTextField(_passwordController, obscureText: true, isPassword: true),
                      _buildLabel('Confirm password'),
                      _buildTextField(_confirmPasswordController, obscureText: true, isPasswordConfirmed: true),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleRegistration,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 174, 185, 201),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Registrate',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 59, 60, 61),
                            ),
                          ),      
                        ),
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Do you have already account?",
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => const LoginScreen()));
                          },
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                              color: Color.fromARGB(255, 30, 121, 240),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color.fromARGB(255, 60, 78, 87),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {
  bool obscureText = false,
  bool isEmail = false,
  bool isPassword = false,
  bool isPasswordConfirmed = false,
  bool isPhone = false, // <-- NEW
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required.';
        }
        if (isEmail && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Wrong email format.';
        }
        if (isPhone && !RegExp(r'^\+?\d{7,15}$').hasMatch(value)) {
          return 'Invalid phone number format.';
        }
        if (isPassword && !RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(value)) {
          return 'Password must contain at least 8 characters including numbers and letters.';
        }
        if (isPasswordConfirmed && _confirmPasswordController.text != _passwordController.text) {
          return 'Passwords are not the same.';
        }
        return null;
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}
}