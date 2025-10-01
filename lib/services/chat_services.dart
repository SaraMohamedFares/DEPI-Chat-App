import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices{
  static final FirebaseFirestore _db=FirebaseFirestore.instance;

  static Future <void> sendMessage(Message message)async{
    final users=message.users..sort();
    final chatRoomId=users.join('_');

    await _db
    .collection('chats')
    .doc(chatRoomId)
    .collection('messages')
    .doc(message.id)
    .set(message.toMap());
  }

  static Stream<List<Message>> getMessages (String senderId, String receiverId){
    final users=[senderId,receiverId]..sort();
    final chatRoomId=users.join('_');

    return _db
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('date',descending: true)
        .snapshots()
        .map(
        (snapshot)=> snapshot.docs.map((doc)=>Message.fromMap(doc.data())).toList(),
    );
  }
}