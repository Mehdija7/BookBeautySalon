import 'package:bookbeauty_desktop/models/category.dart';
import 'package:bookbeauty_desktop/providers/category_provider.dart';
import 'package:bookbeauty_desktop/widgets/product/new_category.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late List<Category> _registeredCategories = [];
  CategoryProvider categoryProvider = CategoryProvider();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      var result = await categoryProvider.get();
      setState(() {
        _registeredCategories = result.result;
        isLoading = false;
      });
    } catch (e) {
      print(
          "*****************************ERROR MESSAGE $e ***********************************");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addCategory(String category) async {
    Category newcategory = Category(name: category);
    await categoryProvider.insert(newcategory);
    await _fetchCategories();
    setState(() {});
  }

  void _openAddCategoryOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewCategory(_addCategory),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _openAddCategoryOverlay,
                    icon: const Icon(Icons.add),
                    padding: const EdgeInsets.only(left: 40, right: 40),
                  ),
                ],
              ),
              if (_registeredCategories.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: _registeredCategories.length,
                    itemBuilder: (ctx, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          title: Text(
                            _registeredCategories[index].name!,
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                const Text("Trenutno nema kategorija")
            ],
          );
  }
}