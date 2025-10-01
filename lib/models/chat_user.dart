class ChatUser{
  String id;
  String email;
  String date;
  ChatUser({required this.id,required this.email,required this.date});


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'email': email,

    };
  }

  // Create from Map
  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      id: map['id'] as String ,
      date: map['date'].toString(),
      email: map['email'] as String
    );
  }

}