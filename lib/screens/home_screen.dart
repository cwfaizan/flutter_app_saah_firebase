import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saah/models/product.dart';
import 'package:saah/providers/product_provider.dart';
import 'package:saah/providers/user_provider.dart';
import 'package:saah/widgets/product_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // final productProvider =
    //     Provider.of<ProductProvider>(context, listen: false);
    // final products =
    //     Provider.of<ProductProvider>(context, listen: false).products;
    return Container(
      color: Colors.black12,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              print('notifyListeners init Consumer');
              return Text(
                'Hello ${userProvider.name}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              print('notifyListeners fetchVerifiedProducts Consumer');
              return Expanded(
                child: productProvider.products.isEmpty
                    ? const Center(
                        child: Text(
                          'No Posts Found',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(10),
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.60,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
