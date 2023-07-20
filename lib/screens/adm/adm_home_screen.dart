import 'package:flutter/material.dart';
import 'package:saah/models/product.dart';
import 'package:saah/utils/collection.dart';
import 'package:saah/widgets/adm/product_card.dart';

class AdmHomeScreen extends StatefulWidget {
  const AdmHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdmHomeScreen> createState() => _AdmHomeScreenState();
}

class _AdmHomeScreenState extends State<AdmHomeScreen> {
  var products = [];
  void fetchUnverifiedPosts() {
    Collection.posts.where('verified', isEqualTo: false).get().then((value) {
      if (value.docs.isNotEmpty) {
        // UserModel userModel =
        // UserModel.fromJson(value.docs.first.data());
        setState(() {
          products = value.docs.toList();
        });
      }
    });
  }

  removeFromList(String id) {
    setState(() {
      products.removeWhere((e) => e.id == id);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUnverifiedPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 25,
            width: double.infinity,
            child: Text(
              'Hey, Admin',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(
            height: 25,
            width: double.infinity,
            child: Text(
              'POSTS TO BE ACCEPTED',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          products.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: products.length,
                    itemBuilder: (context, index) => ProductCard(
                      product: Product(
                        id: products[index]['id'],
                        title: products[index]['title'],
                        description: products[index]['description'],
                        email: products[index]['email'],
                        name: products[index]['name'],
                        image: products[index]['image'],
                        type: products[index]['type'],
                      ),
                      removeFromList: removeFromList,
                    ),
                  ),
                )
              : const Center(
                  child: Text(
                    'No Post Pending',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
        ],
      ),
    );
  }
}
