
class UserStatus {
  final String name;
  final String uid;
  final String profilePic;
  final String phoneNumber;
  final DateTime lastTimeStatus;

  UserStatus({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.phoneNumber,
    required this.lastTimeStatus,
  });

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,
      'lastTimeStatus': lastTimeStatus.millisecondsSinceEpoch,
    };
  }

  factory UserStatus.fromMap(Map<String, dynamic> map) {
    return UserStatus(
      name: map['name'] as String,
      uid: map['uid'] as String,
      profilePic: map['profilePic'] as String,
      phoneNumber: map['phoneNumber'] as String,
      lastTimeStatus: DateTime.fromMillisecondsSinceEpoch(map['lastTimeStatus']),
    );
  }
}
