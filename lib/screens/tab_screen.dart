import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saah/screens/profile_screen.dart';
import 'package:saah/util/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabScreen extends StatefulWidget {
  final userModel;
  const TabScreen({Key? key, this.userModel}) : super(key: key);
  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, Object>> tabScreenList = [];

  @override
  @protected
  void initState() {
    tabScreenList = [
      {
        'tab': ProfileScreen(userModel: widget.userModel),
        'title': 'Home',
      },
      {
        'tab': ProfileScreen(userModel: widget.userModel),
        'title': 'Scan',
      },
      {
        'tab': ProfileScreen(userModel: widget.userModel),
        'title': 'Profile',
      },
    ];
  }

  int _selectedTabIndex = 0;

  void _selectedTab(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _signOut() async {
    // SharedPreferences sp = await SharedPreferences.getInstance();
    // sp.remove('auth_user_name');
    await FirebaseAuth.instance.signOut().whenComplete(() {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.authScreen,
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tabScreenList[_selectedTabIndex]['title'] as String),
        // automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      // drawer: MainDrawer(),
      body: tabScreenList[_selectedTabIndex]['tab'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Profile',
          )
        ],
        onTap: _selectedTab,
        currentIndex: _selectedTabIndex,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
      ),
    );
  }
}
