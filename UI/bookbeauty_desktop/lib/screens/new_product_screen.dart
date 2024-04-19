import 'package:bookbeauty_desktop/widgets/main_title.dart';
import 'package:flutter/material.dart';
import '../widgets/dropdown.dart' as categoriesmenu;
import '../widgets/new_image.dart';

class NewProductScreen extends StatelessWidget {
  const NewProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainTitle(title: 'Dodavanje novog proizvoda'),
                Padding(
                  padding: EdgeInsets.only(right: 200, left: 20, bottom: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Naziv',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 200, left: 20, bottom: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cijena',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 200, left: 20),
                  child: TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Opis proizvoda',
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      'Kategorija',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 114, 111, 111),
                          fontWeight: FontWeight.w600),
                    )),
                categoriesmenu.DropdownMenu(),
              ],
            ),
          ),
          FilePickerWidget(),
        ],
      ),
    );
  }
}
