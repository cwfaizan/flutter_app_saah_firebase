import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saah/models/user_model.dart';
import 'package:saah/screens/tab_screen.dart';
import 'package:saah/util/routes.dart';
import 'package:saah/widgets/auth_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/collection.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(String email, String phone, String name, String dob,
      String gender, String password, bool isLogin) async {
    UserCredential? credential;
    SharedPreferences sp = await SharedPreferences.getInstance();

    if (isLogin) {
      try {
        credential = await _auth
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
            .whenComplete(() {
          // if (credential?.user != null) {
          if (FirebaseAuth.instance.currentUser != null) {
            FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: email)
                .get()
                .then((value) {
              if (value.docs.isNotEmpty) {
                UserModel userModel =
                    UserModel.fromJson(value.docs.first.data());
                sp.setString('auth_user_name', value.docs[0]['name']);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => TabScreen(
                    userModel: userModel,
                  ),
                ));
              }
            });
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("No user found for that email."),
          ));
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Wrong password provided for that user.'),
          ));
        }
      }
    } else {
      try {
        credential = await _auth
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((value) {
          String id = Timestamp.now().millisecondsSinceEpoch.toString();

          Collection.signUp.doc().set({
            'id': id,
            'name': name.trim(),
            'email': email.trim(),
            'phone': phone,
            'dob': dob,
            'gender': gender,
            'is_admin': false,
            // 'date_time': DateTime.now().toUtc().toString(),
          }).whenComplete(() {
            sp.setString('auth_user_name', name);
          });
          return null;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The password provided is too weak.'),
          ));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The account already exists for that email.'),
          ));
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm),
    );
  }
}
