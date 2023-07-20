import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saah/utils/collection.dart';

class BlockKeywordScreen extends StatefulWidget {
  const BlockKeywordScreen({Key? key}) : super(key: key);

  @override
  State<BlockKeywordScreen> createState() => _BlockKeywordScreenState();
}

class _BlockKeywordScreenState extends State<BlockKeywordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _kwController = TextEditingController();
  var keywords = [];

  _blockKeyword() {
    bool isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    String id = Timestamp.now().millisecondsSinceEpoch.toString();

    Collection.blockKeywords.doc(id).set({
      'id': id,
      'name': _kwController.text.trim(),
    }).whenComplete(() {
      final kw = _kwController.text;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('keyword $kw successfully blocked'),
      ));
      _getKeywords();
      _kwController.clear();
    });
  }

  _getKeywords() {
    Collection.blockKeywords.get().then((value) => {
          if (value.docs.isNotEmpty)
            {
              setState(() {
                keywords = value.docs.toList();
              })
            }
        });
  }

  @override
  void initState() {
    _getKeywords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keywords Block'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _kwController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Keyword',
                  prefixIcon: Icon(Icons.sort_by_alpha),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Keyword is required!';
                  }
                  if (value.isEmpty) {
                    return 'Keyword is required!';
                  }
                  if (value.length < 2) {
                    return 'Invalid Keyword';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton.icon(
                onPressed: _blockKeyword,
                icon: const Icon(Icons.block),
                label: const Text('Block Keyword'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: keywords.length,
                itemBuilder: (context, index) => Row(
                  children: [
                    Text(keywords[index]['name']),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => removeKeyword(keywords[index]['id']),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  removeKeyword(String id) {
    Collection.blockKeywords.doc(id).delete().whenComplete(() => {
          setState(() {
            keywords.removeWhere((e) => e.id == id);
          })
        });
  }
}
