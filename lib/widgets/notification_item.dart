import 'package:flutter/material.dart';
import 'package:saah/models/ticket.dart';

class NotificationItem extends StatefulWidget {
  final Ticket ticket;
  const NotificationItem({Key? key, required this.ticket}) : super(key: key);

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Reported Ticket ',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        Text(
          '${widget.ticket.title}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        Text(
          ' has ${widget.ticket.status}',
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }
}
