import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Pages/LoginPage.dart';

import 'package:telegramchatapp/AppLocalizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('he', 'IL'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color.fromRGBO(255,193,58, 1),
          accentColor: Color.fromRGBO(255,164,1, 1),
          buttonColor: Color.fromRGBO(28, 28, 28, 1),
          dividerColor: Color.fromRGBO(196, 196, 196, 1),
          backgroundColor: Color.fromRGBO(244, 244, 244, 1),
          errorColor: Color.fromRGBO(255,69,0, 1),
          disabledColor: Color.fromRGBO(196, 196, 196, 1),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Montserrat'
      ),
      title: 'Telegram Clone',
      home: LoginScreen(),
    );
  }
}
