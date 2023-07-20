import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saah/models/product.dart';
import 'package:saah/providers/product_provider.dart';
import 'package:saah/providers/user_provider.dart';
import 'package:saah/utils/collection.dart';
import 'package:saah/utils/routes.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(title: const Text('Post Details')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Provider.of<UserProvider>(context, listen: false).email ==
                product.email)
              PopupMenuButton(
                onSelected: (value) => value == 1
                    ? onDelete()
                    : Navigator.of(context).pushNamed(
                        Routes.editProductScreen,
                        arguments: widget.product,
                      ),
                child: const Icon(Icons.more_horiz, size: 50),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Text("Delete"),
                    value: 1,
                  ),
                  const PopupMenuItem(
                    child: Text("Edit"),
                    value: 2,
                  )
                ],
              ),
            Center(
              child: Text(
                product.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Center(
                child: Image.network(
                  product.image,
                  height: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Description: ${product.description}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Posted by: ${product.name}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Email: ${product.email}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Category: ${product.type}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDelete() {
    Collection.posts.doc(widget.product.id).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Post successfully Deleted'),
    ));
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Provider.of<ProductProvider>(context, listen: false)
        .filterProductsByEmail(userProvider.email);
    Navigator.of(context).pop();
  }
}
