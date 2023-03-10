
// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatContact {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String token;
  final bool? isOnline;
  final String lastMessage;

  ChatContact({
    required this.name,
    required this.profilePic,
    required this.contactId,
    required this.timeSent,
    required this.token,
    this.isOnline,
    required this.lastMessage,
  });

  
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'contactId': contactId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'token': token,
      'isOnline': isOnline,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      contactId: map['contactId'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      token: map['token'] as String,
      isOnline: map['isOnline'] ?? false,
      lastMessage: map['lastMessage'] as String,
    );
  }
}
