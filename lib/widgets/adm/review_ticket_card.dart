import 'package:flutter/material.dart';
import 'package:saah/models/ticket.dart';
import 'package:saah/utils/collection.dart';

class ReviewTicketCard extends StatelessWidget {
  final Ticket ticket;
  final removeFromList;
  const ReviewTicketCard(
      {Key? key, required this.ticket, required this.removeFromList})
      : super(key: key);

  _approvedTicket(BuildContext context, String id) async {
    Collection.tickets.doc(id).update({
      'active': 0,
      'status': 'Approved',
    }).whenComplete(() {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Ticket Approved')));
      removeFromList(id);
    });
  }

  _ignoreTicket(BuildContext context, String id) {
    Collection.tickets.doc(id).update({
      'active': 2,
      'status': 'Rejected',
    }).whenComplete(() {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Ticket Ignored')));
      removeFromList(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              ticket.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 10),
                Text('Ticket reported by ${ticket.name}'),
              ],
            ),
            const SizedBox(height: 10),
            Text(ticket.description),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _approvedTicket(context, ticket.id),
                  child: const Text('Approve'),
                ),
                ElevatedButton(
                  onPressed: () => _ignoreTicket(context, ticket.id),
                  child: const Text('Ignore'),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
