import 'package:flutter/material.dart';

class NewCategory extends StatefulWidget {
  const NewCategory(this.onAddCategory, {super.key});

  final void Function(String category) onAddCategory;

  @override
  State<NewCategory> createState() {
    return _NewCategoryState();
  }
}

class _NewCategoryState extends State<NewCategory> {
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constrains) {
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _titleController,
                        maxLength: 50,
                        decoration: const InputDecoration(label: Text('Naziv')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Odustani'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_titleController.text.trim().isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Polje naziv je obavezno"),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"))
                              ],
                            ),
                          );
                        } else {
                          try {
                            widget.onAddCategory(_titleController.text.trim());

                            Navigator.pop(context);
                          } on Exception catch (e) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Desila se greska"),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("OK"))
                                ],
                                content: Text(e.toString()),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Spremi',
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
