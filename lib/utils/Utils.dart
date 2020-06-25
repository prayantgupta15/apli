import 'dart:math';

import 'package:apli/methods/firebase_methods.dart';
import 'package:apli/signScreen/signInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

String PHONE_NO = "";
emailValidator(String email) {
  email = email.trim();
  if (email.isEmpty)
    return "Enter Email";
  else {
    if (!email.contains('@', 0)) {
      return "Invalid Email";
    }
  }
}

pwdValidator(String pwd) {
  pwd = pwd.trim();
  if (pwd.isEmpty)
    return "Enter Password";
  else {
    if (pwd.length < 6) return "Minimum password length must be 6";
  }
}

codeValidator(String cd) {
  cd = cd.trim();
  if (cd.isEmpty)
    return "Enter Country Code";
  else {
    if (cd.length > 2 || cd.length < 1) return "Check Country code";
  }
}

phoneNumverValidator(String ph) {
  ph = ph.trim();
  if (ph.isEmpty)
    return "Enter Phone Number";
  else {
    if (ph.length != 10) return "Enter PhoneNumber with 10digits";
  }
}

smsValidator(String code) {
  if (code.isEmpty) return "Enter SMS Code";
}

showToast({@required String msg}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white,
      fontSize: 16.0);
}

acknowledgeDialog(BuildContext context, String email) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.deepPurpleAccent,
            title: Text(
              "Mail Verification Sent",
              style: signStyle,
            ),
            content: Text(
              "A verification email has been sent to ${email}. Click on the confirmation link in the email to activate you account." +
                  "After verifying go to Sign in Page to sign in.",
              style: labelStyle,
            ),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white12,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Sign In", style: signStyle),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => signinScreen()),
                    ModalRoute.withName(''),
                  );
                },
              )
            ],
          ));
}

EmailNotVerifiedDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.deepPurpleAccent,
            title: Text(
              "Sign In failed",
              style: signStyle,
            ),
            content: Text(
              "Email is not verified. Find verification link in the mail"
              " received after SignUp.",
              style: labelStyle,
            ),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white12,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("OK", style: signStyle),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ));
}

PhoneNotVerifiedDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.deepPurpleAccent,
            title: Text(
              "Hey",
              style: signStyle,
            ),
            content: Text(
              "Phone number is not verified. Open the side menu and follow the steps to verify phone number." +
                  "After phone is verified you can upload images",
              style: labelStyle,
            ),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white12,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("OK", style: signStyle),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ));
}

String getUserName(FirebaseUser user) {
  if (user.displayName != null)
    return user.displayName;
  else {
    return "${user.email.split('@')[0]}";
  }
}

TextStyle headingStyle = TextStyle(
  color: Colors.white,
  fontSize: 40,
  fontWeight: FontWeight.w500,
  fontFamily: 'Pacifico',
);

TextStyle labelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w500,
);
TextStyle errorStyle = TextStyle(
  color: Colors.redAccent,
  fontWeight: FontWeight.w500,
);
TextStyle signStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    fontFamily: 'Girassol');

TextStyle uploaderStyle = TextStyle(
    color: Colors.deepPurpleAccent,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    fontFamily: 'Girassol');

TextStyle imgDetailsStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w700,
  fontSize: 15,
);
TextStyle imgDateStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontSize: 10,
);
OutlineInputBorder myBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(color: Colors.white),
);
OutlineInputBorder errorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(color: Colors.redAccent),
);
