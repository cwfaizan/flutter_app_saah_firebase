import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class Collection {
  static CollectionReference signUp = db.collection('users');
}
