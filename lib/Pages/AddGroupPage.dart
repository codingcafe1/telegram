import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegramchatapp/AppLocalizations.dart';
import 'package:telegramchatapp/Helpers/HelperFunctions.dart';
import 'package:telegramchatapp/pages/LoginPage.dart';
import 'package:telegramchatapp/Pages/GroupChatPage.dart';
import 'package:telegramchatapp/Pages/AccountSettingsPage.dart';
import 'package:telegramchatapp/Pages/GroupSearchPage.dart';
import 'package:telegramchatapp/Services/AuthService.dart';
import 'package:telegramchatapp/Services/DatabaseService.dart';
import 'package:telegramchatapp/Widgets/GroupTile.dart';

class AddGroupPage extends StatefulWidget {
  @override
  _AddGroupPageState createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {

  // data
  final AuthService _auth = AuthService();
  FirebaseUser _user;
  String _groupName;
  String _email = '';
  Stream _groups;

  SharedPreferences preferences;
  String id = "";
  String nickname = "";
  String photoUrl = "";
  String aboutMe = "";
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    readDataFromLocal();
    _getUserAuthAndJoinedGroups();
  }

  void readDataFromLocal () async {
    preferences = await SharedPreferences.getInstance();

    id = preferences.getString('id');
    nickname = preferences.getString('nickname');
    photoUrl = preferences.getString('photoUrl');
    aboutMe = preferences.getString('aboutMe');

    print(nickname);
  }


  // widgets
  Widget noGroupWidget() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  _popupDialog(context);
                },
                child: Icon(Icons.add_circle, color: Theme.of(context).dividerColor, size: 75.0)
            ),
            SizedBox(height: 20.0),
            Text(AppLocalizations.of(context).joinGroupHint),
          ],
        )
    );
  }



  Widget groupsList() {
    return StreamBuilder(
      stream: _groups,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data['groups'] != null) {
            // print(snapshot.data['groups'].length);
            if(snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex = snapshot.data['groups'].length - index - 1;
                    return GroupTile(userName: snapshot.data['nickname'],
                        groupId: _destructureId(snapshot.data['groups'][reqIndex]),
                        groupName: _destructureName(snapshot.data['groups'][reqIndex]));
                  }
              );
            }
            else {
              return noGroupWidget();
            }
          }
          else {
            return noGroupWidget();
          }
        }
        else {
          return Center(
              child: CircularProgressIndicator()
          );
        }
      },
    );
  }


  // functions
  _getUserAuthAndJoinedGroups() async {
    preferences = await SharedPreferences.getInstance();

    print(preferences);

    _user = await FirebaseAuth.instance.currentUser();
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        nickname = value;
      });
    });
    print(nickname);
    DatabaseService(uid: _user.uid).getUserGroups().then((snapshots) {
      // print(snapshots);
      setState(() {
        _groups = snapshots;
      });
    });
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        _email = value;
      });
    });
  }


  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }


  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }


  void _popupDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text(AppLocalizations.of(context).cancelLabel),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget createButton = FlatButton(
      child: Text(AppLocalizations.of(context).createLabel),
      onPressed:  () async {
        if(_groupName != null) {
          await DatabaseService().getUserNameByEmail(_user.email).then((val) {
            DatabaseService(uid: _user.uid).createGroup(val, _groupName);
          });

          Navigator.of(context).pop();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(context).createGroupLabel),
      content: TextField(
          onChanged: (val) {
            _groupName = val;
          },
          style: TextStyle(
              fontSize: 15.0,
              height: 2.0,
              color: Theme.of(context).primaryColor
          )
      ),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  // Building the HomePage widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).groupsLabel, style: TextStyle(color: Theme.of(context).backgroundColor, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              icon: Icon(Icons.search, color: Theme.of(context).backgroundColor, size: 25.0),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupSearchPage()));
              }
          )
        ],
      ),

      body: groupsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _popupDialog(context);
        },
        child: Icon(Icons.add, color: Theme.of(context).backgroundColor, size: 30.0),
        backgroundColor: Theme.of(context).dividerColor,
        elevation: 0.0,
      ),
    );
  }
}