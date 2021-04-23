import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String nickname;
  final String photoUrl;
  final String createdAt;

  User({
    this.uid,
    this.nickname,
    this.photoUrl,
    this.createdAt,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      uid: doc.documentID,
      photoUrl: doc['photoUrl'],
      nickname: doc['nickname'],
      createdAt: doc['createdAt'],
    );
  }
}