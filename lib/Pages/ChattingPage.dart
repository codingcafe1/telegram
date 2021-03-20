import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telegramchatapp/Widgets/FullImageWidget.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatelessWidget {
  final String receiverId;
  final String receiverAvatar;
  final String receiverName;

  Chat({
    Key key,
    @required this.receiverId, @required this.receiverAvatar, @required this.receiverName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage: CachedNetworkImageProvider(receiverAvatar),
            ),
          )
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          receiverName,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
       body: ChatScreen(receiverId: receiverId, receiverAvatar: receiverAvatar),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverAvatar;
  
  ChatScreen({
    Key key,
    @required this.receiverId,
    @required this.receiverAvatar,
  }) : super(key: key);

  @override
  State createState() => ChatScreenState(receiverId: receiverId, receiverAvatar: receiverAvatar);
}

class ChatScreenState extends State<ChatScreen> {
  final String receiverId;
  final String receiverAvatar;

  ChatScreenState({
    Key key,
    @required this.receiverId,
    @required this.receiverAvatar,
  });

  final ScrollController listScrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool isDisplaySticker;
  bool isLoading;

  File cameraImageFile;
  File galleryImageFile;
  String imageUrl;

  String chatId;
  SharedPreferences preferences;
  String id;
  var listMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(onFocusChange);

    isDisplaySticker = false;
    isLoading = false;

    chatId = "";

    readLocal();
  }

  readLocal () async {
    preferences = await SharedPreferences.getInstance();
    id = preferences.getString("id") ?? "";

    if (id.hashCode <= receiverId.hashCode) {
      chatId = '$id-$receiverId';
    } else {
      chatId = '$receiverId-$id';
    }
    
    Firestore.instance.collection("users").document(id).updateData({'chattingWith': receiverId});

    setState(() {

    });
  }

  onFocusChange () {
    if (focusNode.hasFocus) {
      // Hide stickers when ever soft keybaord
      setState(() {
        isDisplaySticker = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // Create List of messages
              createMessagesList(),

              // Show imoji stickers
              (isDisplaySticker ? createStickers() : Container()),

              // Input Controllers
              createInput(),
            ],
          ),
          createLoading(),
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  createLoading () {
    return Positioned(
        child: isLoading ? CircularProgressIndicator() : Container());
  }

  Future<bool> onBackPress () {
    if (isDisplaySticker) {
      setState(() {
        isDisplaySticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  createStickers () {
    return Container(
      child: Column (
        children: <Widget>[
          Row (
            children: <Widget>[
              FlatButton (
                onPressed: () => onSendMessage("mimi1", 2),
                child: Image.asset (
                  "images/mimi1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton (
                onPressed: () => onSendMessage("mimi2", 2),
                child: Image.asset (
                  "images/mimi2.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton (
                onPressed: () => onSendMessage("mimi3", 2),
                child: Image.asset (
                  "images/mimi3.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row (
            children: <Widget>[
              FlatButton (
                onPressed: () => onSendMessage("mimi4", 2),
                child: Image.asset (
                  "images/mimi4.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton (
                onPressed: () => onSendMessage("mimi5", 2),
                child: Image.asset (
                  "images/mimi5.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton (
                onPressed: () => onSendMessage("mimi6", 2),
                child: Image.asset (
                  "images/mimi6.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row (
            children: <Widget>[
              FlatButton (
                onPressed: () => onSendMessage("mimi7", 2),
                child: Image.asset (
                  "images/mimi7.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton (
                onPressed: () => onSendMessage("mimi8", 2),
                child: Image.asset (
                  "images/mimi8.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton (
                onPressed: () => onSendMessage("mimi9", 2),
                child: Image.asset (
                  "images/mimi9.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
        border: Border (top: BorderSide(color: Colors.grey, width: 0.5),),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  void getSticker () {
    focusNode.unfocus();
    setState(() {
      isDisplaySticker = !isDisplaySticker;
    });
  }

  createMessagesList () {
    return Flexible(
      child: chatId == ""
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),),
          )
      : StreamBuilder(
        stream: Firestore.instance.collection("messages")
            .document(chatId)
            .collection(chatId).orderBy("timestamp", descending: true)
              .limit(20).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),),
            );
          } else {
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => createItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        }
      )
    );
  }

  bool isLastMessageRight (int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]["idFrom"] != id) || index == 0) {
      return true;
    }

    return false;
  }


  bool isLastMessageLeft (int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]["idFrom"] == id) || index == 0) {
      return true;
    }

    return false;
  }

  Widget displayTextMessage (int index, DocumentSnapshot document, String type) {
    var textColor = type == 'me' ? Colors.white : Colors.black;
    return Container(
      child: Text(
        document["content"],
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500
        )
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      width: 200.0,
      decoration: BoxDecoration (
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0),
    );
  }

  Widget displayImage (int index, DocumentSnapshot document, String type) {
    return Container (
      child: FlatButton(
        child: Material(
          child: CachedNetworkImage (
            placeholder: (context, url) => Container(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
              ),
              width: 200.0,
              height: 200.0,
              padding: EdgeInsets.all(70.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            errorWidget: (context, url, error) => Material (
              child: Image.asset("images/img_not_available.jpeg", width: 200.0, height: 200.0, fit: BoxFit.cover),
              borderRadius: BorderRadius.all(Radius.circular(8)),
              clipBehavior: Clip.hardEdge,
            ),
            imageUrl: document["content"],
            width: 200.0,
            height: 200.0,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          clipBehavior: Clip.hardEdge,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => FullPhoto(url: document["content"])
          ));
        },
      ),
      margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0),
    );
  }

  Widget displaySticker (int index, DocumentSnapshot document, String type) {
    return Container(
      child: Image.asset(
        "images/${document['content']}.gif",
        width: 200.0,
        height: 200.0,
        fit: BoxFit.cover,
      ),
      margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0),
    );
  }

  Widget createItem (int index, DocumentSnapshot document) {
    // Sender messages - right side
    if (document["idFrom"] == id) {
      return Row (
        children: <Widget>[
          // Text message
          document["type"] == 0
            ? displayTextMessage(index, document, 'me')
            : document["type"] == 1
            ? displayImage(index, document, 'me')
            // Sticker .gif message
            : displaySticker(index, document, 'me'),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else { // Receiver side - left side
      return Container (
        child: Column (
          children: <Widget>[
            Row (
              children: <Widget>[
                isLastMessageLeft(index)
                  ? Material (
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                        ),
                        width: 35.0,
                        height: 35.0,
                        padding: EdgeInsets.all(10.0),
                      ),
                      imageUrl: receiverAvatar,
                      width: 35.0,
                      height: 35.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(18.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  )
                  : Container (width: 35.0),
                    // Display messages
                    document["type"] == 0
                    ? displayTextMessage(index, document, null)
                    : document["type"] == 1
                    ? displayImage(index, document, null)
                // Sticker .gif message
                    : displaySticker(index, document, null),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),

            // Message time
            isLastMessageLeft(index)
              ? Container (
                  child: Text(
                    DateFormat("dd MMMM, hh:mm:aa")
                        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(document["timestamp"]))),
                    style: TextStyle (color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic),
                  ),
                  margin: EdgeInsets.only(left: 50.0, top: 50.0, bottom: 5.0),
                )
              : Container ()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  createInput () {
    return Container(
      child: Row(
        children: <Widget>[
          // Pick image icon button - TODO: extend to have selection between gallery and camera
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                color: Colors.lightBlueAccent,
                onPressed: getGalleryImage,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                color: Colors.lightBlueAccent,
                onPressed: getCameraImage,
              ),
            ),
            color: Colors.white,
          ),
          // Emoji button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                color: Colors.lightBlueAccent,
                onPressed: getSticker,
              ),
            ),
            color: Colors.white,
          ),
          // Text field - input
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                    hintText: "Write here...",
                    hintStyle: TextStyle (
                      color: Colors.grey,
                    )
                ),
                  focusNode: focusNode,
              )
            ),
          ),

          // Send message icon button
          Material(
            child: Container (
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton (
                icon: Icon(Icons.send),
                color: Colors.lightBlueAccent,
                onPressed: () => onSendMessage(textEditingController.text, 0),
              ),
            ),
            color: Colors.white,
          )
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration (
        border: Border (
          top: BorderSide (
            color: Colors.grey,
            width: 0.5
          )
        ),
        color: Colors.white,
      ),
    );
  }

  Future getGalleryImage () async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        galleryImageFile = File(pickedFile.path);
        isLoading = true;
      }

      uploadImageFile(galleryImageFile);
    });
  }

  Future getCameraImage () async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        cameraImageFile = File(pickedFile.path);
        isLoading = true;
      }

      uploadImageFile(cameraImageFile);
    });
  }

  Future uploadImageFile (imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference = FirebaseStorage.instance.ref().child("Chat Images").child(fileName);

    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
        imageUrl = downloadUrl;
        setState(() {
          isLoading = false;
          onSendMessage(imageUrl, 1);
        });
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error: " + error);
    });
  }

  void onSendMessage (String messageContent, int type) {
    // type = 0 it's a text message
    // type = 1 it's an image file
    // type = 2 it's an Emoji

    if (messageContent != "") {
      textEditingController.clear();

      var docRef = Firestore.instance.collection("messages")
        .document(chatId)
        .collection(chatId).document(DateTime.now().millisecondsSinceEpoch.toString());
      
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(docRef, {
          "idFrom": id,
          "idTo": receiverId,
          "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "content": messageContent,
          "type": type,
        }, );
      });
      listScrollController.animateTo(0.0, duration: Duration(microseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: "Empty message, cannot be sent");
    }
  }
}
