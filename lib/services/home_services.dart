import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_user.dart';

class HomeServices{
  static final FirebaseFirestore _db= FirebaseFirestore.instance;
  static Stream<List<ChatUser>> getAllUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ChatUser.fromMap(doc.data())).toList());
  }
}
