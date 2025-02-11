import 'package:book_beauty/models/user.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:book_beauty/screens/login_screen.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
  }

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
          title: const Text('Greška'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('U redu'),
            ),
          ],
        );
      },
    );
  }

  void _handleRegistration() async {
    final String firstName = _firstNameController.text;
    final String lastName = _lastNameController.text;
    final String username = _usernameController.text;
    final String address = _addressController.text;
    final String email = _emailController.text;
    final String phone = _phoneController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        username.isEmpty ||
        address.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showErrorDialog('Sva polja je obavezno ispuniti');
    } else if (password != confirmPassword) {
      _showErrorDialog('Lozinke se ne podudaraju');
    } else {
      User newUser = new User(
          firstName: firstName,
          lastName: lastName,
          address: address,
          phone: phone,
          email: email,
          username: username,
          password: password,
          passwordConfirmed: confirmPassword);
      var u = await _userProvider.registrate(newUser);

      // var ur = await _userProvider.addRole(u.userId!, 'Korisnik');
      print(u.username);
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
                  height: 200,
                ),
              ],
            ),
          ),
          Positioned.fill(
            top: 200,
            child: Container(
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 190, 187, 168).withOpacity(0.4),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                child: ListView(
                  children: [
                    _buildLabel('Ime'),
                    _buildTextField(_firstNameController),
                    _buildLabel('Prezime'),
                    _buildTextField(_lastNameController),
                    _buildLabel('Adresa'),
                    _buildTextField(_addressController),
                    _buildLabel('Email'),
                    _buildTextField(_emailController),
                    _buildLabel('Broj telefona'),
                    _buildTextField(_phoneController),
                    _buildLabel('Korisnicko ime'),
                    _buildTextField(_usernameController),
                    _buildLabel('Lozinka'),
                    _buildTextField(_passwordController, obscureText: true),
                    _buildLabel('Lozinka potvrda'),
                    _buildTextField(_confirmPasswordController,
                        obscureText: true),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleRegistration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 174, 185, 201),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Registruj se',
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
                          "Imate kreiran račun?",
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => const LoginScreen()));
                          },
                          child: const Text(
                            "Prijava",
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

  Widget _buildTextField(TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          fillColor: Colors.white.withOpacity(0.8),
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
