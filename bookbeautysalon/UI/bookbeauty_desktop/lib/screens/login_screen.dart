import 'package:bookbeauty_desktop/providers/user_provider.dart';
import 'package:bookbeauty_desktop/screens/home_screen.dart';
import 'package:bookbeauty_desktop/utils.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _usernameError;
  String? _passwordError;
  String? _generalError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
            child: Card(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logoBB3.jpg",
                    height: 130,
                    width: 400,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: const Icon(Icons.email),
                      errorText: _usernameError,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.password),
                      errorText: _passwordError,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _usernameError = null;
                        _passwordError = null;
                        _generalError = null;
                      });

                      UserProvider provider = UserProvider();
                      String username = _usernameController.text.trim();
                      String password = _passwordController.text.trim();

                      if (username.isEmpty || password.isEmpty) {
                        setState(() {
                          if (username.isEmpty) _usernameError = "Username is required";
                          if (password.isEmpty) _passwordError = "Password is required";
                        });
                        return;
                      }

                      Authorization.username = username;
                      Authorization.password = password;

                      try {
                        var data = await provider.authenticate(
                          Authorization.username!, Authorization.password!);
                        var roles = await provider.getRoles(data.userId!);
                        bool isAdmin = roles
                            .where((r) => r.role!.name!.toLowerCase() == 'admin')
                            .isNotEmpty;
                        bool isHairdresser = roles
                            .where((r) => r.role!.name!.toLowerCase() == 'hairdresser')
                            .isNotEmpty;

                        if (isAdmin || isHairdresser) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(isAdmin: isAdmin),
                            ),
                          );
                        } else {
                          setState(() {
                            _generalError = "Password or username was incorrect.";
                          });
                        }
                      } on Exception catch (e) {
                        setState(() {
                          _generalError = "Password or username was incorrect.";
                        });
                      }
                    },
                    child: const Text("Log in"),
                  ),
                  if (_generalError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _generalError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
