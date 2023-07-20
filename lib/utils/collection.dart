import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class Collection {
  static CollectionReference users = db.collection('users');
  static CollectionReference posts = db.collection('posts');
  static CollectionReference tickets = db.collection('tickets');
  static CollectionReference blockKeywords = db.collection('block_keywords');
}
