import 'package:flutter/material.dart';
import 'package:saah/screens/adm/adm_home_screen.dart';
import 'package:saah/screens/adm/review_ticket.dart';
import 'package:saah/screens/profile_screen.dart';
import 'package:saah/utils/collection.dart';
import 'package:saah/utils/routes.dart';
import 'package:saah/widgets/badge.dart';

class AdmTabScreen extends StatefulWidget {
  const AdmTabScreen({Key? key}) : super(key: key);
  @override
  State<AdmTabScreen> createState() => _AdmTabScreenState();
}

class _AdmTabScreenState extends State<AdmTabScreen> {
  List<Map<String, Object>> tabScreenList = [];
  int _ticketCount = 0;

  Future<void> ticketCount() async {
    Collection.tickets.where('active', isEqualTo: 1).get().then((value) {
      setState(() {
        _ticketCount = value.docs.length;
      });
    });
  }

  @override
  void initState() {
    tabScreenList = [
      {
        'tab': const AdmHomeScreen(),
        'title': 'Home',
      },
      {
        'tab': const ReviewTicket(),
        'title': 'Review Tickets',
      },
      {
        'tab': const ProfileScreen(),
        'title': 'Manage',
      },
    ];
    ticketCount();
    super.initState();
  }

  int _selectedTabIndex = 0;

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
      body: tabScreenList[_selectedTabIndex]['tab'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Manage',
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
