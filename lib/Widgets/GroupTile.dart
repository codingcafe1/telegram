import 'package:flutter/material.dart';
import 'package:telegramchatapp/Pages/GroupChatPage.dart';

import 'package:telegramchatapp/AppLocalizations.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupId;
  final String groupName;

  GroupTile({ this.userName, this.groupId, this.groupName });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => GroupChatPage(groupId: groupId, userName: userName, groupName: groupName )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).buttonColor),),
          ),
          title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text(AppLocalizations.of(context).joinedGroupHint +  "$userName", style: TextStyle(fontSize: 13.0),),
        ),
      ),
    );
  }
}