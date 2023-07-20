import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:saah/screens/adm/block_keyword_screen.dart';
import 'package:saah/screens/auth/change_password.dart';
import 'package:saah/screens/my_product_screen.dart';
import 'package:saah/screens/report_ticket.dart';
import 'package:saah/utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  bool _isAdmin = false;

  getSharedPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String data = sp.getString('auth_user_name') ?? 'user name not found';
    bool isAdmin = sp.getBool('auth_user_is_admin') ?? false;
    setState(() {
      _name = data;
      _isAdmin = isAdmin;
    });
  }

  @override
  void initState() {
    getSharedPreferences();
    super.initState();
  }

  void _signOut() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('auth_user_name');
    if (sp.getBool('google_login') ?? false) {
      await GoogleSignIn().disconnect();
      sp.remove('google_login');
    }
    await FirebaseAuth.instance.signOut().whenComplete(() {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.authScreen,
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChangePassword(),
                ),
              );
            },
            icon: const Icon(Icons.lock),
            label: const Text('Change Password'),
          ),
          if (_isAdmin) const SizedBox(height: 20),
          if (_isAdmin)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BlockKeywordScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.block),
              label: const Text('Keywords Block'),
            ),
          if (!_isAdmin) const SizedBox(height: 20),
          if (!_isAdmin)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ReportTicket(),
                  ),
                );
              },
              icon: const Icon(Icons.report),
              label: const Text('Report Ticket'),
            ),
          if (!_isAdmin) const SizedBox(height: 20),
          if (!_isAdmin)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyProductScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
              label: const Text('My Posts'),
            ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _signOut,
            icon: const Icon(Icons.power_settings_new),
            label: const Text('Sign-out'),
          ),
        ],
      ),
    );
  }
}
