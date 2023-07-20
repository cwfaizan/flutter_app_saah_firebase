import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saah/models/product.dart';
import 'package:saah/utils/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

enum PostType { recycle, borrow, donation }

class _EditProductScreenState extends State<EditProductScreen> {
  ImagePicker? _picker;
  File? _imageFile;
  PostType _postType = PostType.recycle;
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();
  bool imageAttached = false;

  void _pickImageFromGallery() async {
    final XFile? image = await _picker?.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(image!.path);
    });
  }

  void _pickImageFromCamera() async {
    final XFile? image = await _picker?.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(image!.path);
    });
  }

  @override
  void initState() {
    _picker = ImagePicker();
    super.initState();
  }

  var _initValues = {
    'id': '',
    'title': '',
    'description': '',
    'email': '',
    'name': '',
    'image': '',
    'type': '',
  };
  var _isInit = true;

  @override
  void didChangeDependencies() {
    _loadBlockKeywords();
    if (_isInit) {
      Product? product =
          ModalRoute.of(this.context)!.settings.arguments as Product;
      // ignore: unnecessary_null_comparison
      if (product != null) {
        _initValues = {
          'id': product.id,
          'title': product.title,
          'description': product.description,
          'email': product.email,
          'name': product.name,
          'image': product.image,
          'type': product.type,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    imageAttached = _imageFile != null ? true : false;
    return Scaffold(
      appBar: AppBar(title: const Text('New Post')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _pickImageFromCamera,
                    icon: const Icon(Icons.add_a_photo),
                    color: Theme.of(context).primaryColor,
                    iconSize: 50.0,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: _pickImageFromGallery,
                    icon: const Icon(Icons.add_to_photos),
                    color: Theme.of(context).primaryColor,
                    iconSize: 50.0,
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _titleController..text = _initValues['title'] ?? '',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Post Title'),
                validator: (value) {
                  if (value == null) {
                    return 'Title is required!';
                  }
                  if (value.isEmpty) {
                    return 'Title is required!';
                  }
                  var blockKeywords = [];
                  for (String title in value.split(' ')) {
                    if (blockKeywordList.contains(title.trim())) {
                      blockKeywords.add(title);
                    }
                  }
                  if (blockKeywords.isNotEmpty) {
                    return 'Keyword $blockKeywords not allowed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: Colors.red[200]),
                child: _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.fitHeight,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                        width: 200,
                        height: 200,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text('Post Type', textAlign: TextAlign.left),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<PostType>(
                      title: const Text(
                        'Recycle',
                        style: TextStyle(fontSize: 9),
                      ),
                      value: PostType.recycle,
                      groupValue: _postType,
                      onChanged: (value) {
                        setState(() {
                          _postType = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<PostType>(
                      title: const Text(
                        'Borrow',
                        style: TextStyle(fontSize: 9),
                      ),
                      value: PostType.borrow,
                      groupValue: _postType,
                      onChanged: (value) {
                        setState(() {
                          _postType = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<PostType>(
                      title: const Text(
                        'Donation',
                        style: TextStyle(fontSize: 7),
                      ),
                      value: PostType.donation,
                      groupValue: _postType,
                      onChanged: (value) {
                        setState(() {
                          _postType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                // initialValue: _initValues['description'],
                controller: _descriptionController
                  ..text = _initValues['description'] ?? '',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration:
                    const InputDecoration(labelText: 'Post Description'),
                validator: (value) {
                  if (value == null) {
                    return 'detail is required!';
                  }
                  if (value.isEmpty) {
                    return 'detail is required!';
                  }
                  var blockKeywords = [];
                  for (String title in value.split(' ')) {
                    if (blockKeywordList.contains(title.trim())) {
                      blockKeywords.add(title);
                    }
                  }
                  if (blockKeywords.isNotEmpty) {
                    return 'Keyword $blockKeywords not allowed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _uploadImage(context);
                    },
                    child: const Text('Post'),
                    style: ElevatedButton.styleFrom(
                        // minimumSize: const Size.fromWidth(20),
                        ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[200],
                      // minimumSize: const Size.fromHeight(20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<dynamic> blockKeywordList = [];
  void _loadBlockKeywords() {
    Collection.blockKeywords.get().then((value) {
      blockKeywordList = value.docs.map((e) => e['name']).toList();
    });
  }

  Future<void> _uploadPost(String imageUrl, BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String id =
        _initValues['id'] ?? Timestamp.now().millisecondsSinceEpoch.toString();
    Collection.posts.doc(id).set({
      'id': id,
      'title': _titleController.text.trim(),
      'image': imageUrl,
      'type': _postType == PostType.recycle
          ? 'Recycle'
          : _postType == PostType.borrow
              ? 'Borrow'
              : 'Donation',
      'description': _descriptionController.text,
      'email': sp.getString('auth_user_email') ?? 'saahproject1@gmail.com',
      'name': sp.getString('auth_user_name') ?? 'Sara',
      'verified': false,
      'date_time': DateTime.now(),
      // 'date_time': DateTime.now().toUtc().toString(),
    }).whenComplete(() {
      _titleController.clear();
      _descriptionController.clear();
      _imageFile = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post successfully upload'),
        ),
      );
      Navigator.of(context).pop();
    });
  }

  _uploadImage(BuildContext context) async {
    var isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    if (!imageAttached) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please attached Image'),
      ));
    }

    _formKey.currentState!.save();
    String fileName = basename(_imageFile!.path);
    final _fsChildRef =
        FirebaseStorage.instance.ref().child('images/$fileName');
    await _fsChildRef.putFile(_imageFile!).whenComplete(() async {
      String imageAddress = await _fsChildRef.getDownloadURL();
      _uploadPost(imageAddress, context);
    });
  }
}
