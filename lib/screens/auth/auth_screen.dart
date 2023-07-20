import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:saah/screens/adm/adm_tab_screen.dart';
import 'package:saah/screens/tab_screen.dart';
import 'package:saah/widgets/auth/auth_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/collection.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(
    TextEditingController emailController,
    TextEditingController phoneController,
    TextEditingController nameController,
    TextEditingController dobController,
    TextEditingController passwordController,
    String gender,
    bool isLogin,
  ) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    if (isLogin) {
      try {
        await _auth
            .signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        )
            .whenComplete(() {
          // if (credential?.user != null) {
          passwordController.clear();
          if (FirebaseAuth.instance.currentUser != null) {
            Collection.users
                .where('email', isEqualTo: emailController.text)
                .get()
                .then((value) {
              if (value.docs.isNotEmpty) {
                // UserModel userModel =
                // UserModel.fromJson(value.docs.first.data());
                sp.setString('auth_user_name', value.docs[0]['name']);
                sp.setString('auth_user_email', value.docs[0]['email']);
                sp.setBool('auth_user_is_admin', value.docs[0]['is_admin']);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => value.docs[0]['is_admin']
                        ? const AdmTabScreen()
                        : const TabScreen(),
                  ),
                );
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
        await _auth
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        )
            .then((value) {
          String id = Timestamp.now().millisecondsSinceEpoch.toString();

          Collection.users.doc(FirebaseAuth.instance.currentUser!.uid).set({
            'id': id,
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'phone': phoneController.text,
            'dob': dobController.text,
            'gender': gender,
            'is_admin': false,
            // 'date_time': DateTime.now().toUtc().toString(),
          }).whenComplete(() {
            sp.setString('auth_user_name', nameController.text);
          });
          return null;
        });
        if (FirebaseAuth.instance.currentUser != null) {
          emailController.clear();
          phoneController.clear();
          nameController.clear();
          dobController.clear();
          passwordController.clear();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('Successfully Registered, please login to continue...'),
          ));
        }
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
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_submitAuthForm),
    );
  }
}
