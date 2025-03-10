import 'package:book_beauty/screens/home_screen.dart';
import 'package:book_beauty/utils.dart';
import 'package:flutter/material.dart';
import 'package:blur/blur.dart';
import '../screens/registration_screen.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
Flutter3DController controller = Flutter3DController();
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
  void initState(){
    super.initState();
     controller.onModelLoaded.addListener(() {
      debugPrint('model is loaded : ${controller.onModelLoaded.value}');
    });
  }
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/logoBB.png',
              fit: BoxFit.fill,
            ).blurred(blur: 2, blurColor: const Color.fromARGB(222, 158, 158, 158)),
          ),

          Center(
            child: Container(
              width: screenWidth * 0.85, 
              height: screenHeight * 0.60, 
              padding: EdgeInsets.all(screenWidth * 0.05), 
              decoration: BoxDecoration(
                color: const Color.fromARGB(210, 236, 236, 236),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blueGrey, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(241, 255, 255, 255),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Flutter3DViewer.obj(
                        src: 'assets/images/22.obj',
                        scale: 5,
                        cameraX: 2,
                        cameraY: 0,
                        cameraZ: 10,
                        onProgress: (double progressValue) {
                          debugPrint('model loading progress : $progressValue');
                        },
                        onLoad: (String modelAddress) {
                          debugPrint('model loaded : $modelAddress');
                        },
                        onError: (String error) {
                          debugPrint('model failed to load : $error');
                        },
                    ),
                  ),
                 /* Container(
                    width: screenWidth * 0.1, 
                    height: screenWidth * 0.1, 
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(231, 19, 31, 36),
                    ),
                    child: O3D.asset(
                    src: 'assets/images/22.glb',
                    controller: controller,
                     ),
                  ),
                  const SizedBox(height: 20),
                  */
                  // Title
                  Text(
                    "Book Beauty Salon",
                    style: GoogleFonts.bigShouldersDisplay(
                      fontSize: screenWidth * 0.06, 
                      fontWeight: FontWeight.w400,
                      color: const Color.fromARGB(255, 63, 71, 83),
                    ),
                  ),
                   SizedBox(height: screenHeight*0.01),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: Colors.blueGrey),
                      labelText: "Korisnicko ime",
                      labelStyle: const TextStyle(color: Colors.blueGrey),
                      filled: true,
                      fillColor: const Color.fromARGB(211, 219, 219, 219),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                   SizedBox(height: screenHeight*0.01),

                  // Password Field
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: Colors.blueGrey),
                      labelText: "Lozinka",
                      labelStyle: const TextStyle(color: Colors.blueGrey),
                      filled: true,
                      fillColor: const Color.fromARGB(236, 207, 206, 206),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Authorization.username = _usernameController.text;
                        Authorization.password = _passwordController.text;
                        if (_usernameController.text.trim().isEmpty ||
                            _passwordController.text.trim().isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Greska"),
                              content: const Text(
                                  "Popunite polja za unos korisnickog imena i lozinke"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                        } else {
                          try {
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
                                content: Text("${e.toString()} "),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02), 
                        backgroundColor: const Color(0xFFB0C4DE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Prijavi se",
                        style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white), 
                      ),
                    ),
                  ),
                   SizedBox(height: screenHeight*0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        'Nemate kreiran račun?',
                        style: TextStyle(color: Colors.blueGrey, fontSize: 12),                   
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
          ),
        ],
      ),
    );
  }

  Widget _buildHoverTextButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(foregroundColor: Colors.blueGrey),
      child: Text(
        label,
        style: TextStyle(
          color: const Color.fromARGB(255, 28, 92, 177,
          ),
          fontSize:12
        ),
      ),
    );
  }
}