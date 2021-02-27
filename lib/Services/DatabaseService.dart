import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({
    this.uid
  });

  // Collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference groupCollection = Firestore.instance.collection('groups');

  // Update userdata
  Future updateUserData(String nickname, String email, String password) async {
    return await userCollection.document(uid).setData({
      'nickname': nickname,
      'email': email,
      'password': password,
      'groups': [],
      'photoUrl': ''
    });
  }

  // Create group
  Future createGroup(String userName, String groupName) async {
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      // 'messages': ,
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });

    await groupDocRef.updateData({
      'members': FieldValue.arrayUnion([uid + '_' + userName]),
      'groupId': groupDocRef.documentID
    });

    DocumentReference userDocRef = userCollection.document(uid);
    return await userDocRef.updateData({
      'groups': FieldValue.arrayUnion([groupDocRef.documentID + '_' + groupName])
    });
  }

// Toggling the user group join
  Future togglingGroupJoin(String groupId, String groupName, String userName) async {

    DocumentReference userDocRef = userCollection.document(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.document(groupId);

    List<dynamic> groups = await userDocSnapshot.data['groups'];

    if (groups.contains(groupId + '_' + groupName)) {
      // print('hey');
      await userDocRef.updateData({
        'groups': FieldValue.arrayRemove(([groupId + '_' + groupName])),
      });

      await groupDocRef.updateData({
        'members': FieldValue.arrayRemove([uid + '_' + userName]),
      });
    } else {
      // print ('nay');
      await userDocRef.updateData({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      await groupDocRef.updateData({
        'members': FieldValue.arrayUnion([uid + '_' + userName])
      });
    }
  }

  // has user joined the group
  Future<bool> isUserJoined(String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.document(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot.data['groups'];

    if (groups.contains(groupId + '_' + groupName)) {
      // print('he');
      return true;
    }
    return false;
  }

  // Get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where('email', isEqualTo: email).getDocuments();
    print(snapshot.documents[0].data);
    return snapshot;
  }

  // Get user groups
  getUserGroups () async {
    return Firestore.instance.collection('users').document(uid).snapshots();
  }

  // Send message
  sendMessage (String groupId, chatMessageData) {
    Firestore.instance.collection('groups').document(groupId).collection('messages').add(chatMessageData);
    Firestore.instance.collection('groups').document(groupId).updateData({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString()
    });
  }

  // Get chats of a particular group
  getChats (String groupId) async {
    return Firestore.instance.collection('groups').document(groupId).collection('messages').orderBy('time').snapshots();
  }

  // search groups
  searchByName (String groupName) {
    return Firestore.instance.collection('groups').where('groupName', isEqualTo: groupName).getDocuments();
  }
}
