import 'package:chat_app/services/home_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/chat_user.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
        title: Text('Chats - ${user.email!.split('@')[0]}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
      ),
      body: StreamBuilder<List<ChatUser>>(
        stream: HomeServices.getAllUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final users = snapshot.data!.toList();
          if (users.isEmpty) {
            return const Center(
              child: Text("No Users Found"),
            );
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final regUser = users[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        receiverId: regUser.id,
                        receiverEmail: regUser.email,
                      ),
                    ),
                  );
                },
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(
                  regUser.email.split('@')[0],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(([user.uid, regUser.id]..sort()).join('_'))
                      .collection('messages')
                      .orderBy('date', descending: true)
                      .limit(1)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text("Tap to start a chat.");
                    }

                    final lastMsg = snapshot.data!.docs.first;
                    final text = lastMsg['text'];
                    final Timestamp ts = lastMsg['date'];
                    final DateTime dt = ts.toDate();
                    final bool isMe = lastMsg['senderId'] == user.uid;

                    final timeString =
                        "${dt.hour % 12 == 0 ? 12
                        : dt.hour % 12}:${dt.minute.toString().padLeft(2, '0')} "
                        "${dt.hour >= 12 ? 'PM' : 'AM'}";

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isMe
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          timeString,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
