import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:telegramchatapp/Pages/HomePage.dart';
import 'package:telegramchatapp/Shared/constants.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:telegramchatapp/Helpers/HelperFunctions.dart';
import 'package:telegramchatapp/Services/DatabaseService.dart';

import 'package:telegramchatapp/Services/AuthService.dart';
import 'package:telegramchatapp/Pages/PhoneLoginPage.dart';

import 'package:telegramchatapp/AppLocalizations.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen ({Key key}): super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  BuildContext _buildContext;

  double _deviceHeight;
  double _deviceWidth;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  SharedPreferences preferences;

  bool isLoggedIn = false;
  bool isLoading = false;
  FirebaseUser currentUser;

  final AuthService _auth = AuthService();
  bool _isLoading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

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

  _onSignIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _auth.signInWithEmailAndPassword(email, password).then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot = await DatabaseService().getUserData(email);


          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data['nickname']
          );

          print("Signed In");
          await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
            print("Logged in: $value");
          });
          await HelperFunctions.getUserEmailSharedPreference().then((value) {
            print("Email: $value");
          });
          await HelperFunctions.getUserNameSharedPreference().then((value) {
            print("Full Name: $value");
          });

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(currentUserId: userInfoSnapshot.documents[0].data['uid'])));
        }
        else {
          setState(() {
            error = 'Error signing in!';
            _isLoading = false;
          });
        }
      });
    }
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
        padding: EdgeInsets.symmetric(horizontal: 40.0),
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
            _backgroundImageWidget(),
            // Text(AppLocalizations.of(context).signInLabel,
            //   style: GoogleFonts.montserrat(
            //       textStyle: TextStyle(
            //           fontSize: 24.0,
            //           fontWeight: FontWeight.w700,
            //           color: Theme.of(_buildContext).buttonColor
            //       )
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            TextFormField(
              style: TextStyle(color: Theme.of(_buildContext).buttonColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
              decoration: textInputDecoration.copyWith(labelText: AppLocalizations.of(context).emailLabel),
              validator: (val) {
                return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : AppLocalizations.of(context).invalidEmailWarning;
              },

              onChanged: (val) {
                setState(() {
                  email = val;
                });
              },
            ),
            TextFormField(
              style: TextStyle(color: Theme.of(_buildContext).buttonColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
              decoration: textInputDecoration.copyWith(labelText: AppLocalizations.of(context).passwordLabel),
              validator: (val) => val.length < 6 ? AppLocalizations.of(context).passwordHint : null,
              obscureText: true,
              onChanged: (val) {
                setState(() {
                  password = val;
                });
              },
            ),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: RaisedButton(
                  elevation: 0.0,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  child: Text(AppLocalizations.of(context).signInLabel, style: TextStyle(color: Theme.of(context).buttonColor, fontSize: 16.0)),
                  onPressed: () {
                    _onSignIn();
                  }
              ),
            ),
            Text.rich(
              TextSpan(
                text: AppLocalizations.of(context).noHiveAccountYetLabel + ' ',
                style: TextStyle(color: Theme.of(context).buttonColor, fontSize: 14.0),
                children: <TextSpan>[
                  TextSpan(
                    text: AppLocalizations.of(context).registerLabel,
                    style: TextStyle(
                        color: Theme.of(context).buttonColor,
                        decoration: TextDecoration.underline
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      // widget.toggleView();
                    },
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: controlSignInWithGoogle,
              child: Center(
                child: Column(
                  children: <Widget>[
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
          "chattingWith": null,
          "email": googleUser.email
        });

        // Write data
        currentUser = firebaseUser;
        await preferences.setString("id", currentUser.uid);
        await preferences.setString("nickname", currentUser.displayName);
        await preferences.setString("photoUrl", currentUser.photoUrl);
        await preferences.setString("email", documentSnapshot[0]["email"]);
      } else {  // User exists
        currentUser = firebaseUser;
        await preferences.setString("id", documentSnapshot[0]["id"]);
        await preferences.setString("nickname", documentSnapshot[0]["nickname"]);
        await preferences.setString("photoUrl", documentSnapshot[0]["photoUrl"]);
        await preferences.setString("email", documentSnapshot[0]["email"]);
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

  Widget _backgroundImageWidget() {
    return Container(
      height: _deviceHeight * .25,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/hive-bee-on-boarding.png"),
          fit: BoxFit.contain,
        ),),
    );
  }
}
