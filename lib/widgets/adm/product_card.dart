import 'package:flutter/material.dart';
import 'package:saah/utils/collection.dart';

import '../../models/product.dart';

class ProductCard extends StatelessWidget {
  Product product;
  final removeFromList;
  ProductCard({Key? key, required this.product, required this.removeFromList})
      : super(key: key);

  _postApproved(BuildContext context, String id) async {
    Collection.posts.doc(id).update({
      'verified': true,
    }).whenComplete(() {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Post Approved')));
      removeFromList(id);
    });
  }

  _postRejected(BuildContext context, String id) {
    removeFromList(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Post Rejected')));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  _postApproved(context, product.id);
                },
                icon: const Icon(Icons.done),
                label: const Text('Approve'),
              ),
              TextButton.icon(
                onPressed: () {
                  _postRejected(context, product.id);
                },
                icon: const Icon(Icons.close),
                label: const Text('Deny'),
                style: TextButton.styleFrom(primary: Colors.red),
              ),
            ],
          ),
          Image.network(product.image, height: 200, fit: BoxFit.cover),
          const SizedBox(height: 20),
          Text(
            product.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person),
              const SizedBox(width: 8),
              Text('Posted by ${product.name}'),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
