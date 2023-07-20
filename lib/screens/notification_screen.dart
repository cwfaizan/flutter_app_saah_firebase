import 'package:flutter/material.dart';
import 'package:saah/models/ticket.dart';
import 'package:saah/widgets/notification_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/collection.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var _tickets;

  Future<void> tickets() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.getBool('auth_user_is_admin') ?? false) {
      Collection.tickets.where('active', isEqualTo: 1).get().then((value) {
        setState(() {
          _tickets = value.docs;
        });
      });
    } else {
      Collection.tickets
          .where('active', isNotEqualTo: 1)
          .where('email', isEqualTo: sp.getString('auth_user_email'))
          .get()
          .then((value) {
        setState(() {
          _tickets = value.docs;
        });
      });
    }
  }

  @override
  void initState() {
    tickets();
    super.initState();
  }

  Widget noNotificationActive() {
    return const Center(
      child: Text(
        'No notification is active',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _tickets == null
            ? noNotificationActive()
            : _tickets.isEmpty
                ? noNotificationActive()
                : ListView.builder(
                    itemCount: _tickets.length,
                    itemBuilder: (context, i) => NotificationItem(
                      ticket: Ticket(
                        id: _tickets[i]['id'],
                        title: _tickets[i]['title'],
                        description: _tickets[i]['description'],
                        name: _tickets[i]['name'],
                        email: _tickets[i]['email'],
                        active: _tickets[i]['active'],
                        status: _tickets[i]['status'],
                      ),
                    ),
                  ),
      ),
    );
  }
}
