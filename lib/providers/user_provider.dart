import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String name = '';
  String email = '';

  UserProvider() {
    init();
  }

  void init() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    name = sp.getString('auth_user_name') ?? '';
    email = sp.getString('auth_user_email') ?? '';
    notifyListeners();
    print('notifyListeners init');
  }
}
