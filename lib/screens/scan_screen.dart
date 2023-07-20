import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saah/screens/charity_screen.dart';
import 'package:saah/utils/routes.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

enum EnumProductName { table, chair, bottle }

class _ScanScreenState extends State<ScanScreen> {
  ImagePicker? _picker;
  File? _imageFile;

  @override
  void initState() {
    _picker = ImagePicker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: _pickImageFromCamera,
        child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: _imageFile != null
              ? Image.file(
                  _imageFile!,
                  width: 400.0,
                  height: 400.0,
                  fit: BoxFit.fitHeight,
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  width: 400,
                  height: 400,
                  child: const Icon(
                    Icons.camera_alt,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  void _pickImageFromCamera() async {
    final XFile? image = await _picker?.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(image!.path);
      showDialog(
        context: context,
        builder: (BuildContext context) => productTypeDialog(context),
      );
    });
  }

  Widget productTypeDialog(BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                child: const Text('Recycle'),
                onPressed: () {
                  Navigator.of(context).pop('dialog');
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => productItemTypeDialog(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 80),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop('dialog');
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CharityScreen(imageFile: _imageFile),
                  ));
                },
                child: const Text('Donate'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 80),
                ),
              ),
            ],
          ),
        ),
      );

  EnumProductName enumSelectedProductName = EnumProductName.table;
  Widget productItemTypeDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop('dialog');
                Navigator.of(context)
                    .pushNamed(Routes.recyclingIdeaScreen, arguments: 'table');
              },
              child: const Text('Table'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop('dialog');
                Navigator.of(context)
                    .pushNamed(Routes.recyclingIdeaScreen, arguments: 'chair');
              },
              child: const Text('Chair'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop('dialog');
                Navigator.of(context)
                    .pushNamed(Routes.recyclingIdeaScreen, arguments: 'bottle');
              },
              child: const Text('Bottle'),
            ),
          ],
        ),
      ),
    );
  }
}
