import 'package:apli/homeScreens/HomeScreen.dart';
import 'package:apli/methods/firebase_methods.dart';
import 'package:apli/signScreen/signInScreen.dart';
import 'package:apli/checkLoginScreen.dart';
import 'package:apli/splashScreen.dart';
import 'package:apli/utils/Utils.dart';
import 'package:flutter/material.dart';

void main() => runApp(Apli());

class Apli extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Apli",
      home: SplashScreen(),
    );
  }
}
