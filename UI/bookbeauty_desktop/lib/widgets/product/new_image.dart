import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerWidget extends StatefulWidget {
  const FilePickerWidget({super.key});

  @override
  State createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  File? _image;

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Slika: '),
          Padding(
            padding: EdgeInsets.only(top: 0, right: 0),
            child: GestureDetector(
              onTap: _openFilePicker,
              child: _image != null
                  ? Image.file(
                      _image!,
                      width: 400,
                      height: 400,
                    )
                  : Image.asset(
                      'assets/images/pravaslika.png',
                      width: 400,
                      height: 400,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 500, top: 100),
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Color.fromARGB(255, 111, 160, 103);
                    }
                    return Color.fromARGB(255, 150, 216, 156);
                  },
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 245, 245, 245)),
              ),
              child: Text('Dodaj proizvod'),
            ),
          ),
        ],
      ),
    );
  }
}
