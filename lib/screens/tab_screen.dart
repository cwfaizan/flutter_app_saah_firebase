import 'package:flutter/material.dart';
import 'package:saah/screens/home_screen.dart';
import 'package:saah/screens/profile_screen.dart';
import 'package:saah/screens/scan_screen.dart';
import 'package:saah/utils/collection.dart';
import 'package:saah/utils/routes.dart';
import 'package:saah/widgets/app_drawer.dart';
import 'package:saah/widgets/badge.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);
  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, Object>> tabScreenList = [];
  int _ticketCount = 0;
  int _selectedTabIndex = 0;

  Future<void> ticketCount() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Collection.tickets
        .where('active', isNotEqualTo: 1)
        .where('email', isEqualTo: sp.getString('auth_user_email'))
        .get()
        .then((value) {
      setState(() {
        _ticketCount = value.docs.length;
      });
    });
  }

  @override
  void initState() {
    tabScreenList = [
      {
        'tab': const HomeScreen(),
        'title': 'Home',
      },
      {
        'tab': const ScanScreen(),
        'title': 'Scan',
      },
      {
        'tab': const ProfileScreen(),
        'title': 'Edit Profile',
      },
    ];
    ticketCount();
    super.initState();
  }

  void _selectedTab(int index) {
    setState(() {
      _selectedTabIndex = index;
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
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                Routes.editProductScreen,
              );
            },
          ),
          Badge(
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.notificationScreen);
              },
              icon: const Icon(
                Icons.notification_important,
              ),
            ),
            value: _ticketCount.toString(),
            color: Colors.amberAccent,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: tabScreenList[_selectedTabIndex]['tab'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
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
