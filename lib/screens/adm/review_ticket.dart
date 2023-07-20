import 'package:flutter/material.dart';
import 'package:saah/models/ticket.dart';
import 'package:saah/utils/collection.dart';
import 'package:saah/widgets/adm/review_ticket_card.dart';

class ReviewTicket extends StatefulWidget {
  const ReviewTicket({Key? key}) : super(key: key);

  @override
  State<ReviewTicket> createState() => _ReviewTicketState();
}

class _ReviewTicketState extends State<ReviewTicket> {
  var tickets = [];

  void fetchActiveTickets() {
    Collection.tickets.where('active', isEqualTo: 1).get().then((value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          tickets = value.docs.toList();
        });
      }
    });
  }

  removeFromList(String id) {
    setState(() {
      tickets.removeWhere((e) => e.id == id);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchActiveTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Icon(
            Icons.calendar_today,
            size: 50,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 20),
          tickets.isEmpty
              ? const Center(
                  child: Text(
                    'No Ticket Active',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: tickets.length,
                  itemBuilder: (context, index) => ReviewTicketCard(
                    ticket: Ticket(
                      id: tickets[index]['id'],
                      title: tickets[index]['title'],
                      description: tickets[index]['description'],
                      email: tickets[index]['email'],
                      name: tickets[index]['name'],
                      active: tickets[index]['active'],
                      status: tickets[index]['status'],
                    ),
                    removeFromList: removeFromList,
                  ),
                ),
        ],
      ),
    );
  }
}
