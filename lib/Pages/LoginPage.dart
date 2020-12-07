import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telegramchatapp/Pages/HomePage.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:telegramchatapp/Pages/PhoneLoginPage.dart';

import 'package:telegramchatapp/AppLocalizations.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen ({Key key}): super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  BuildContext _buildContext;

  double _deviceHeight;
  double _deviceWidth;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  SharedPreferences preferences;

  bool isLoggedIn = false;
  bool isLoading = false;
  FirebaseUser currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isSingedIn();
  }

  void isSingedIn() async {
    this.setState(() {
      isLoggedIn = true;
    });

    preferences = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(currentUserId: preferences.getString("id"))));
    }

    this.setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;

    _deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    _deviceWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(_buildContext).welcomeToHive,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(_buildContext).buttonColor
                  )
              ),
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              onTap: controlSignInWithGoogle,
              child: Center(
                child: Column(
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhoneSignInScreen()));
                        },
                      icon: Icon(
                        Icons.phone,
                        color: Colors.blue,
                      ),
                      label: Text(
                        "Sign-In using Phone",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Container(
                      width: 270.0,
                      height: 65.0,
                      decoration: BoxDecoration(
                        image: DecorationImage (
                            image: AssetImage ("assets/images/google_signin_button.png"),
                          fit: BoxFit.cover
                      ),
                    )),
                    Padding(
                        padding: EdgeInsets.all(1.0),
                    child: isLoading ? circularProgress() :  Container(),)],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Null> controlSignInWithGoogle () async {
    var preferences = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    FirebaseUser firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

    // Sign in success
    if (firebaseUser != null) {
      // Check if the user has already signed up
      final QuerySnapshot resultQuery = await Firestore.instance
          .collection("users").where("id", isEqualTo: firebaseUser.uid).getDocuments();

      final List<DocumentSnapshot> documentSnapshot = resultQuery.documents;

      if (documentSnapshot.length == 0) {
        // This is a new user and we should register it
        Firestore.instance.collection("users").document(firebaseUser.uid).setData({
          "nickname": firebaseUser.displayName,
          "photoUrl": firebaseUser.photoUrl,
          "id": firebaseUser.uid,
          "aboutMe": "I'm using Hive Chat",
          "createdAt": DateTime.now().microsecondsSinceEpoch.toString(),
          "chattingWith": null
        });

        // Write data
        currentUser = firebaseUser;
        await preferences.setString("id", currentUser.uid);
        await preferences.setString("nickname", currentUser.displayName);
        await preferences.setString("photoUrl", currentUser.photoUrl);
      } else {  // User exists
        currentUser = firebaseUser;
        await preferences.setString("id", documentSnapshot[0]["id"]);
        await preferences.setString("nickname", documentSnapshot[0]["nickname"]);
        await preferences.setString("photoUrl", documentSnapshot[0]["photoUrl"]);
        await preferences.setString("aboutMe", documentSnapshot[0]["aboutMe"]);
      }

      Fluttertoast.showToast(msg: AppLocalizations.of(_buildContext).loginSuccessMessageSnackbar ,);
      this.setState(() {
        isLoading = false;
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(currentUserId: firebaseUser.uid)));

    } else {  // Sign in failed
      Fluttertoast.showToast(msg: AppLocalizations.of(_buildContext).pleaseTryAgainWarningSnackbar ,);
      this.setState(() {
        isLoading = false;
      });
    }
  }
}
