import 'package:flutter/material.dart';
import 'package:saah/utils/collection.dart';

class ProductProvider with ChangeNotifier {
  var _products = [];

  ProductProvider() {
    fetchVerifiedProducts();
  }

  get products {
    return _products;
  }

  void filterProducts(String type) {
    Collection.posts.where('type', isEqualTo: type).get().then((value) {
      if (value.docs.isNotEmpty) {
        _products = value.docs.toList();
      } else {
        _products = [];
      }
      notifyListeners();
      print('notifyListeners filterProducts');
    });
  }

  void filterProductsByEmail(String email) {
    Collection.posts.where('email', isEqualTo: email).get().then((value) {
      if (value.docs.isNotEmpty) {
        _products = value.docs.toList();
      } else {
        _products = [];
      }
      notifyListeners();
      print('notifyListeners filterProductsByEmail $email');
    });
  }

  void fetchVerifiedProducts() {
    // Collection.posts.where('verified', isEqualTo: true).get().then((value) {
    Collection.posts.get().then((value) {
      if (value.docs.isNotEmpty) {
        _products = value.docs.toList();
        notifyListeners();
        print('notifyListeners fetchVerifiedProducts');
      }
    });
  }
}
