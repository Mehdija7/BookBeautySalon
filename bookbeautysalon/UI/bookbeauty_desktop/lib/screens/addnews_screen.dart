import 'package:bookbeauty_desktop/models/news.dart';
import 'package:bookbeauty_desktop/providers/news_provider.dart';
import 'package:bookbeauty_desktop/providers/user_provider.dart';
import 'package:flutter/material.dart';

class AddnewsScreen extends StatefulWidget {
  const AddnewsScreen({super.key});

  @override
  State<AddnewsScreen> createState() => _AddnewsScreenState();
}

class _AddnewsScreenState extends State<AddnewsScreen> {
  final _formKey = GlobalKey<FormState>();
  final NewsProvider newsProvider = NewsProvider();
  final UserProvider userProvider = UserProvider();
  String? title;
  String? text;

  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Naslov je obavezan';
    }
    return null;
  }

  String? validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Content is required';
    }
    return null;
  }

  Future<void> submitData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Title: $title');
      print('Content: $text');

      News news = News(
        dateTime: DateTime.now(),
        title: title,
        text: text,
        hairdresserId: UserProvider.globalUserId,
      );
      var response = await newsProvider.insert(news);
      _formKey.currentState!.reset();
      setState(() {
        text = "";
        title = "";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Novost dodana uspjesno',
          ),
          backgroundColor: Colors.lightGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj novost'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Naslov',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (value) => title = value,
                validator: validateTitle,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Sadrzaj',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (value) => text = value,
                validator: validateText,
                maxLines: 15,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16.0),
              Center(
                // Centering the button
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      submitData();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return const Color.fromARGB(255, 111, 160, 103);
                          }
                          return const Color.fromARGB(255, 150, 216, 156);
                        },
                      ),
                      foregroundColor: WidgetStateProperty.all<Color>(
                          const Color.fromARGB(255, 245, 245, 245)),
                    ),
                    child: const Text('Dodaj novost'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
