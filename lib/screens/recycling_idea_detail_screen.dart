import 'package:flutter/material.dart';

class RecyclingIdeaDetailScreen extends StatelessWidget {
  final String path;
  const RecyclingIdeaDetailScreen({Key? key, required this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycling Ideas for your Item'),
      ),
      body: Image.asset(path, fit: BoxFit.fill),
    );
  }
}
