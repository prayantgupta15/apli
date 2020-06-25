import 'package:apli/homeScreens/HomeScreen.dart';
import 'package:apli/methods/firebase_methods.dart';
import 'package:apli/signScreen/signInScreen.dart';
import 'package:apli/utils/Utils.dart';
import 'package:flutter/material.dart';

class CheckLoginScreen extends StatefulWidget {
  @override
  _CheckLoginScreenState createState() => _CheckLoginScreenState();
}

class _CheckLoginScreenState extends State<CheckLoginScreen> {
  FirebaseMethods _methods = FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: _methods.getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("snapshot" + snapshot.data.runtimeType.toString());
              //LOGGED IN
              return HomeScreen(
                currentUser: snapshot.data,
              );
            } else {
              //TO BE LOG IN
              return signinScreen();
            }
          },
        ),
      ),
    );
  }
}
