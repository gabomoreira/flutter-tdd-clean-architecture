import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ui/pages/pages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    final primaryColor = const Color.fromRGBO(0, 92, 99, 1);
    final primaryColorDark = const Color(0xFF004349);
    final primaryColorLight = const Color(0xFF4FBDBA);
    final backgroundColor = const Color(0xFFF6F6F6);
    final textColor = const Color(0xFF1C1C1C);

    return MaterialApp(
      title: "gabo's",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: primaryColor
        ),
        scaffoldBackgroundColor: backgroundColor,
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: primaryColorDark
          )
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColorLight),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          alignLabelWithHint: true
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            foregroundColor: Colors.white,
            backgroundColor: primaryColor,
            overlayColor: primaryColorLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            )
          )
        )
      ),
      home: LoginPage(),
    );
  }
}