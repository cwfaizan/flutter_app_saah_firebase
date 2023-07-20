import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saah/utils/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportTicket extends StatefulWidget {
  const ReportTicket({Key? key}) : super(key: key);

  @override
  State<ReportTicket> createState() => _ReportTicketState();
}

class _ReportTicketState extends State<ReportTicket> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _uploadTicket() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String id = Timestamp.now().millisecondsSinceEpoch.toString();
    Collection.tickets.doc(id).set({
      'id': id,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'email': sp.getString('auth_user_email') ?? 'admin@gamil.com',
      'name': sp.getString('auth_user_name') ?? 'Admin',
      'active': 1,
      'status': 'Pending',
    }).whenComplete(() {
      const snackBar = SnackBar(
        content: Text('Ticket successfully generated'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _titleController.clear();
      _descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Tickets'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text('Ticket Title'),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Enter Title',
                ),
              ),
              const SizedBox(height: 20),
              const Text('Ticket Description'),
              const SizedBox(height: 20),
              TextFormField(
                minLines: 5,
                maxLines: 7,
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Enter Description',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _uploadTicket,
                    child: const Text('Send'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
