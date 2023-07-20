import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saah/models/product.dart';
import 'package:saah/providers/product_provider.dart';
import 'package:saah/widgets/product_item.dart';

import '../providers/user_provider.dart';

class MyProductScreen extends StatelessWidget {
  const MyProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Provider.of<ProductProvider>(context, listen: false)
        .filterProductsByEmail(userProvider.email);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_outline, size: 40),
                const SizedBox(width: 10),
                Text(
                  'Hi ${userProvider.name}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ],
            ),
            const Divider(),
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) =>
                  productProvider.products.isEmpty
                      ? const Text('No Posts Active')
                      : Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.60,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: productProvider.products.length,
                            itemBuilder: (context, index) => ProductItem(
                              product: Product(
                                id: productProvider.products[index]['id'],
                                title: productProvider.products[index]['title'],
                                description: productProvider.products[index]
                                    ['description'],
                                email: productProvider.products[index]['email'],
                                name: productProvider.products[index]['name'],
                                image: productProvider.products[index]['image'],
                                type: productProvider.products[index]['type'],
                              ),
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
