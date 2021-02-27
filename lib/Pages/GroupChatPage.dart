import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telegramchatapp/AppLocalizations.dart';
import 'package:telegramchatapp/Services/DatabaseService.dart';
import 'package:telegramchatapp/Widgets/MessageTileWidget.dart';

class GroupChatPage extends StatefulWidget {
  final String groupId;
  final String userName;
  final String groupName;

  GroupChatPage ({
    this.groupId,
    this.userName,
    this.groupName
  });

  @override
  _GroupChatPageState createState () => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {

  Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();

  Widget _chatMessage () {
    return StreamBuilder (
      stream: _chats,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder (
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return MessageTile (
              message: snapshot.data.documents[index].data["message"],
              sender: snapshot.data.documents[index].data["sender"],
              sentByMe: widget.userName == snapshot.data.documents[index].data["sender"],
            );
          },
        )
            :
        Container();
      },
    );
  }

  _sendMessage () {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap =  {
        "message": messageEditingController.text,
        "sender": widget.userName,
        "time": DateTime.now().microsecondsSinceEpoch
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState () {
    super.initState();
    DatabaseService().getChats(widget.groupId).then((value) {
      setState(() {
        _chats = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar (
        title: Text(widget.groupName, style: TextStyle (color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black87,
        elevation: 0.0,
      ),
      body: Container (
        child: Stack (
          children: <Widget>[
            _chatMessage(),
            Container (
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container (
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: Colors.grey[700],
                child: Row (
                    children: <Widget>[
                      Expanded (
                        child: TextField (
                          controller: messageEditingController,
                          style: TextStyle (
                              color: Colors.white
                          ),
                          decoration: InputDecoration (
                              hintText: AppLocalizations.of(context).sendAMessageHint,
                              hintStyle: TextStyle (
                                  color: Colors.white38,
                                  fontSize: 16.0
                              ),
                              border: InputBorder.none
                          ),
                        ),
                      ),

                      SizedBox (width: 12.0,),

                      GestureDetector (
                        onTap: () {
                          _sendMessage();
                        },
                        child: Container (
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration (
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(50.0)
                          ),
                          child: Center(child: Icon(Icons.send, color: Colors.white,),),
                        ),
                      )
                    ]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}