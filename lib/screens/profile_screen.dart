import 'package:flutter/material.dart';
import 'package:saah/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel userModel;
  const ProfileScreen({Key? key, required this.userModel}) : super(key: key);

  getSharedPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? data = sp.getString('auth_user_name');
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Hello ${userModel.userName}'),
    );
  }
}
