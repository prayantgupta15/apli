import 'package:apli/checkLoginScreen.dart';
import 'package:apli/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
          context,
          MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => CheckLoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.blue,
              Colors.deepPurple,
              Colors.deepPurpleAccent
            ])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.deepPurpleAccent,
                  enabled: true,
                  child: Text("Apli",
                      style: TextStyle(
                          fontFamily: 'Pacifico',
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
              SizedBox(height: 20),
              Text(
                "A platform to share photos",
                style: labelStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
