import 'package:book_beauty/providers/auth_provider.dart';
import 'package:book_beauty/providers/service_provider.dart';
import 'package:book_beauty/screens/home_screen.dart';
import 'package:book_beauty/utils.dart';
import 'package:flutter/material.dart';
import 'package:blur/blur.dart';
import '../screens/registration_screen.dart';
import 'package:book_beauty/providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserProvider _userProvider = UserProvider();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/logoBB.png',
              fit: BoxFit.cover,
            ).blurred(blur: 5, blurColor: Colors.grey.withOpacity(0.3)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueGrey[50]!.withOpacity(0.7),
                  ),
                  child: const Icon(
                    Icons.content_cut,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "BookBeauty",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB0C4DE), // Dusty blue color
                  ),
                ),
                const SizedBox(height: 50),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.person, color: Colors.blueGrey),
                    labelText: "Username",
                    labelStyle: const TextStyle(color: Colors.blueGrey),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.blueGrey),
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.blueGrey),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      print(
                          "credentials: ${_usernameController.text} : ${_passwordController.text}");
                      Authorization.username = _usernameController.text;
                      Authorization.password = _passwordController.text;
                      if (_usernameController.value.text.trim().isEmpty ||
                          _passwordController.value.text.trim().isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Greska"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK"),
                              ),
                            ],
                            content: const Text(
                                "Popunite polja za unos korisnickog imena i lozinke"),
                          ),
                        );
                      } else {
                        try {
                          print(
                              '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ${_usernameController.text}  ${_passwordController.text} ++++++++++++++++++++++++++++++++++++++++');
                          var data = await _userProvider.authenticate(
                              Authorization.username!, Authorization.password!);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(user: data),
                            ),
                          );
                        } on Exception catch (e) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Error"),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"))
                              ],
                              content: Text("${e.toString()} "),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: const Color(0xFFB0C4DE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Prijavi se",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Nemate kreiran račun?',
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                    _buildHoverTextButton(
                      label: "Registrujte se",
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const RegistrationScreen()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoverTextButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      onEnter: (event) => {},
      onExit: (event) => {},
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.blueGrey,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 28, 92, 177),
          ),
        ),
      ),
    );
  }
}
