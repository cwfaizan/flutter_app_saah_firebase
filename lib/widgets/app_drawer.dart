import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saah/providers/product_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Saah'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            title: const Text('Recycle'),
            onTap: () {
              productProvider.filterProducts('Recycle');
              Navigator.of(context).pop();
              // filterPosts('recycle');
              // Navigator.of(context).pushReplacementNamed(Routes.tabScreen);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Borrow or Loan'),
            onTap: () {
              productProvider.filterProducts('Borrow');
              Navigator.of(context).pop();
              // filterPosts('borrow');
              // Navigator.of(context)
              //     .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Donate'),
            onTap: () {
              productProvider.filterProducts('Donate');
              Navigator.of(context).pop();
              // filterPosts('donate');
              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
