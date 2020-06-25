import 'package:apli/methods/firebase_methods.dart';
import 'package:apli/utils/Utils.dart';
import 'package:flutter/material.dart';

class PhoneVerificationScreen extends StatefulWidget {
  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  FirebaseMethods _methods = FirebaseMethods();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  FocusNode phoneFocus = FocusNode();
  FocusNode codeFocus = FocusNode();

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
            padding: const EdgeInsets.all(40.0),
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
                children: <Widget>[
                  SizedBox(height: 50),
                  Text(
                    "First verify your Mobile Number",
                    style: signStyle,
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: codeController,
                    focusNode: codeFocus,
                    validator: (String code) => codeValidator(code),
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(phoneFocus);
                    },
                    style: labelStyle,
                    decoration: InputDecoration(
                        hintText: "91",
                        labelText: "Country Code",
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
                    controller: phoneController,
                    focusNode: phoneFocus,
                    validator: (String ph) => phoneNumverValidator(ph),
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                    },
                    style: labelStyle,
                    decoration: InputDecoration(
                        labelText: "Phone Number",
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
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white12,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text("Send Code", style: signStyle),
                    ),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();

                      if (_formKey.currentState.validate()) {
                        String phoneNumber = "+" +
                            codeController.text.trim() +
                            phoneController.text.trim();
                        _methods.sendCodeToPhoneNumber(
                            phonenumber: phoneNumber, context: context);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
