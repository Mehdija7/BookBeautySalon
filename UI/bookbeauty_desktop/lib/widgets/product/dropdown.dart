import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../providers/category_provider.dart';

class DropdownMenu extends StatefulWidget {
  final List<Category> categories;

  const DropdownMenu({super.key, required this.categories});

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  String? selectedValue = '';
  /*late List<Category> _registeredCategories = widget.categories!;
  CategoryProvider categoryProvider = CategoryProvider();*/

  @override
  void initState() {
    super.initState();
    if (widget.categories.isNotEmpty) {
      selectedValue = widget.categories[0].categoryId
          .toString(); // Make sure to use categoryId for the value
    }
    //_fetchCategories();
  }

  /*Future<void> _fetchCategories() async {
    try {
      var result = await categoryProvider.get();

      setState(() {
        _registeredCategories = result.result;
        selectedValue = _registeredCategories.first.name;
      });
      print(selectedValue);
    } catch (e) {
      print(
          "*****************************ERROR MESSAGE ${e} ***********************************");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return widget.categories.isEmpty
        ? const Text("Dodajte kategorije")
        : Padding(
            padding: const EdgeInsets.only(left: 20, top: 15),
            child: DropdownButton<String>(
              focusColor: Colors.transparent,
              value: selectedValue,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                });
              },
              items: widget.categories.map((Category category) {
                return DropdownMenuItem<String>(
                  value: category.categoryId
                      .toString(), // The value should be unique, use categoryId
                  child: Text(category.name!),
                );
              }).toList(),
            ),
          );
  }
}
