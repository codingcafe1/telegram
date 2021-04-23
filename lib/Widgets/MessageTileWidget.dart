import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final DateTime timeStamp = DateTime.now();

  MessageTile({ this.message, this.sender, this.sentByMe });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: sentByMe ? 0 : 24, right: sentByMe ? 0 : 24),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft ,
      child: Container (
        margin: sentByMe ? EdgeInsets.only(left: 20.0) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 8.0, bottom: 12.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
          borderRadius: sentByMe ? BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
            bottomLeft: Radius.circular(12.0),
          )
              :
          BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0),
          ),
          color: sentByMe ? Theme.of(context).primaryColor : Theme.of(context).dividerColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text(sender.toUpperCase(), textAlign: TextAlign.start,
            //   style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -0.5),),
            SizedBox(height: 7.0),
            Text(message, textAlign: TextAlign.start, style: TextStyle(fontSize: 15.0, color: Theme.of(context).buttonColor),),
            Text(
              DateFormat("HH:mm").format(timeStamp),
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 12.0,
                  color: Theme.of(context).buttonColor),),
          ],
        ),
      ),
    );
  }
}
