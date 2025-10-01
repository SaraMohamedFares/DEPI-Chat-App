import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String text;
  final Timestamp date;
  final String senderId;
  final String receiverId;
  List<String> users;

  // Main constructor
  Message({
    required this.id,
    required this.text,
    required this.date,
    required this.senderId,
    required this.receiverId,
    required this.users,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'date': date,
      'senderId': senderId,
      'receiverId': receiverId,
      'users': users,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      text: map['text'] as String,
      date: map['date'] as Timestamp,
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      users: List<String>.from(map['users'] ?? []),
    );
  }
}
