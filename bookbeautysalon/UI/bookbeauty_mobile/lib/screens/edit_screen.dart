import 'package:book_beauty/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:book_beauty/models/user.dart';
import 'package:book_beauty/screens/profile_screen.dart';

class EditScreen extends StatefulWidget {
  final User user;

  EditScreen({super.key, required this.user});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordConfirmedController;

  UserProvider userProvider = UserProvider();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address);
    _passwordController = TextEditingController(text: widget.user.password);
    _passwordConfirmedController =
        TextEditingController(text: widget.user.passwordConfirmed);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _passwordConfirmedController.dispose();
    super.dispose();
  }

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        widget.user.firstName = _firstNameController.text;
        widget.user.lastName = _lastNameController.text;
        widget.user.username = _usernameController.text;
        widget.user.email = _emailController.text;
        widget.user.phone = _phoneController.text;
        widget.user.address = _addressController.text;
        widget.user.password = _passwordController.text == ""
            ? widget.user.password
            : _passwordController.text;
        widget.user.passwordConfirmed = _passwordConfirmedController.text == ""
            ? widget.user.password
            : _passwordConfirmedController.text;
      });
      try {
        var r = await userProvider.update(widget.user.userId!, widget.user);
        UserProvider.globaluser = r;
        UserProvider.globalUserId = r.userId;
        await userProvider.authenticate(r.username!, r.password!);
        print(r);
      } catch (e) {
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Podaci uspjesno sacuvani!'),
          backgroundColor: Colors.lightGreen,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update user. Please check your inputs.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Ime', _firstNameController),
              _buildTextField('Prezime', _lastNameController),
              _buildTextField('Korisnicko ime', _usernameController),
              _buildTextField('Email', _emailController),
              _buildTextField('Telefon', _phoneController),
              _buildTextField('Adresa', _addressController),
              _buildTextField('Lozinka', _passwordController, isPassword: true),
              _buildTextField('Potvrdite lozinku', _passwordConfirmedController,
                  isPassword: true),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _saveUser,
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              labelText: label,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
