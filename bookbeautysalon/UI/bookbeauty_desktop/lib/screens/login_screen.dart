import 'package:bookbeauty_desktop/providers/user_provider.dart';
import 'package:bookbeauty_desktop/screens/home_screen.dart';
import 'package:bookbeauty_desktop/utils.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                    decoration: const InputDecoration(
                        labelText: "Username", prefixIcon: Icon(Icons.email)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.password)),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        UserProvider provider = UserProvider();

                        print(
                            "credentials: ${_usernameController.text} : ${_passwordController.text}");
                        Authorization.username = _usernameController.text;
                        Authorization.password = _passwordController.text;

                        if (_usernameController.text.trim() == "" ||
                            _passwordController.text.trim() == "") {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text("Error"),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("OK"))
                                    ],
                                    content: const Text(
                                        'Neispravni podaci za prijavu'),
                                  ));
                        }
                        try {
                          var data = await provider.authenticate(
                              Authorization.username!, Authorization.password!);
                          var roles = await provider.getRoles(data.userId!);
                          bool isAdmin = roles
                              .where(
                                  (r) => r.role!.name!.toLowerCase() == 'admin')
                              .isNotEmpty;
                          bool isHairdresser = roles
                              .where((r) =>
                                  r.role!.name!.toLowerCase() == 'frizer')
                              .isNotEmpty;
                          if (isAdmin || isHairdresser) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  isAdmin: isAdmin,
                                ),
                              ),
                            );
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text("Greška"),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("OK"))
                                      ],
                                      content: const Text(
                                          'Neispravni podaci za prijavu'),
                                    ));
                          }
                        } on Exception catch (e) {}
                      },
                      child: const Text("Login"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
