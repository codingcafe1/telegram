import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';


class PhoneSignInScreen extends StatefulWidget {
  @override
  _PhoneSignInScreenState createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  PhoneNumber _phoneNumber;

  String _message;
  String _verificationId;

  bool _isSMSsent = false;

  final TextEditingController _smsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Phone Sign In"),
    ),
    body: SingleChildScrollView(
      child: AnimatedContainer(
      duration: Duration(milliseconds: 500,),
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
        top: 20,
      ),
    child: Column(
      children: <Widget>[
    Container(
      margin: EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
    child: InternationalPhoneNumberInput(
      onInputChanged: (phoneNumberTxt) {
      _phoneNumber = phoneNumberTxt;
      },
      inputBorder: OutlineInputBorder(),
      initialCountry2LetterCode: 'US',
      )),
    ])
      ))
    );
  }
}