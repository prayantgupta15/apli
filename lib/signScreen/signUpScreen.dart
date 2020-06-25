import 'package:apli/Model/CollectionUser.dart';
import 'package:apli/homeScreens/HomeScreen.dart';
import 'package:apli/methods/firebase_methods.dart';
import 'package:apli/signScreen/signInScreen.dart';
import 'package:apli/utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //TEXT FIELDS PARAMS
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  FocusNode _emailNode = FocusNode(), _pwdNode = FocusNode();
  bool obscure = true;

  FirebaseMethods _methods = FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.blue,
                  Colors.deepPurple,
                  Colors.deepPurpleAccent
                ])),
            child: Form(
              key: _formKey,
              child: ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  Center(
                    child: Text("SignUp", style: headingStyle),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Hey! " + PHONE_NO.toString(),
                    style: labelStyle,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    focusNode: _emailNode,
                    validator: (String email) => emailValidator(email),
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_pwdNode);
                    },
                    style: labelStyle,
                    decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: labelStyle,
                        enabledBorder: myBorder,
                        focusedBorder: myBorder,
                        errorBorder: errorBorder,
                        border: myBorder,
                        errorStyle: errorStyle,
                        filled: true,
                        fillColor: Colors.white12),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: pwdController,
                    focusNode: _pwdNode,
                    validator: (String pwd) => pwdValidator(pwd),
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                    },
                    style: labelStyle,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: labelStyle,
                      enabledBorder: myBorder,
                      focusedBorder: myBorder,
                      errorBorder: errorBorder,
                      border: myBorder,
                      errorStyle: errorStyle,
                      filled: true,
                      fillColor: Colors.white12,
                      suffixIcon: IconButton(
                        color: Colors.white,
                        icon: obscure
                            ? Icon(Icons.remove_red_eye)
                            : Icon(MdiIcons.eyeOff),
                        onPressed: () {
                          print("pressed");
                          obscure ? obscure = false : obscure = true;
                          setState(() {});
                        },
                      ),
                    ),
                    obscureText: obscure,
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white12,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text("Sign Up", style: signStyle),
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState.validate()) {
                        //REMOVE SPACES
                        emailController.text = emailController.text.trim();
                        pwdController.text = pwdController.text.trim();

                        //PERFORM SIGNUP
                        _methods
                            .signUp(
                                email: emailController.text,
                                pwd: pwdController.text)
                            .then((FirebaseUser user) {
                          //CHECK GOT USER OT NOT
                          if (user != null) {
                            acknowledgeDialog(context, emailController.text);
                          } else
                            print('Some Error Occurred');
                        });
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Text(
                        "Already have account?  ",
                        style: labelStyle,
                      ),
                      GestureDetector(
                        child: Text(
                          "SignIn!",
                          style: signStyle,
                        ),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => signinScreen()),
                            ModalRoute.withName(''),
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
