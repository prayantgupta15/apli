import 'package:apli/Model/CollectionUser.dart';
import 'package:apli/Model/imageModel.dart';
import 'package:apli/homeScreens/UploadScreen.dart';
import 'package:apli/homeScreens/updateProfilePhoto.dart';
import 'package:apli/methods/firebase_methods.dart';
import 'package:apli/signScreen/signInScreen.dart';
import 'package:apli/utils/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  FirebaseUser currentUser;
  HomeScreen({@required this.currentUser});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseMethods _methods = FirebaseMethods();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  drawer() {
    return Drawer(
      child: StreamBuilder(
          stream: Firestore.instance
              .collection("users")
              .document(widget.currentUser.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            TextEditingController userNameController = TextEditingController(
                text: snapshot.data[UserModel.USERNAME_KEY]);

            TextEditingController phoneNumberController =
                TextEditingController(text: snapshot.data[UserModel.PH_NO_KEY]);
            TextEditingController emailController =
                TextEditingController(text: snapshot.data[UserModel.EMAIL_KEY]);

            return Container(
              color: Colors.deepPurpleAccent,
              child: ListView(
                children: <Widget>[
//                  ACCOUNT HEADER
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                    ),
                    currentAccountPicture: GestureDetector(
                      onTap: () {
                        UserModel collectionUser = UserModel(
                            uid: widget.currentUser.uid,
                            isPhoneVerified: true,
                            username: userNameController.text,
                            email: snapshot.data[UserModel.EMAIL_KEY],
                            profilephoto:
                                snapshot.data[UserModel.PROFILE_PHOTO_KEY],
                            phoneNumber: snapshot.data[UserModel.PH_NO_KEY]);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateDPScreen(
                                      currentCollectionUser: collectionUser,
                                    )));
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(snapshot
                                        .data[UserModel.PROFILE_PHOTO_KEY] ==
                                    null ||
                                snapshot.data[UserModel.PROFILE_PHOTO_KEY] == ""
                            ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcScwlFdK4Fmpad8A_e9TgXmNnb0wP1IwU6x1w&usqp=CAU'
                            : snapshot.data[UserModel.PROFILE_PHOTO_KEY]),
                      ),
                    ),
                    accountName: Text(
                      (snapshot.data[UserModel.USERNAME_KEY] == null)
                          ? "Hello, User"
                          : 'Hello, ${snapshot.data[UserModel.USERNAME_KEY]}',
                      style: signStyle,
                    ),
                    accountEmail: Text(
                      snapshot.data[UserModel.EMAIL_KEY],
                      style: labelStyle,
                    ),
                  ),
                  Divider(
                    color: Colors.deepPurple,
                    thickness: 2,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            enabled: true,
                            controller: userNameController,
                            validator: (String name) {
                              if (name.isEmpty)
                                return "UserName cannot be empty";
                            },
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                            style: labelStyle,
                            decoration: InputDecoration(
                                labelText: "User Name",
                                labelStyle: labelStyle,
                                enabledBorder: myBorder,
                                focusedBorder: myBorder,
                                errorBorder: errorBorder,
                                border: myBorder,
                                errorStyle: errorStyle,
                                hintText: snapshot.data[UserModel.USERNAME_KEY],
                                filled: true,
                                fillColor: Colors.white12),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: emailController,
                            enabled: false,
                            style: labelStyle,
                            decoration: InputDecoration(
                              labelText: "Email(Cannot be changed)",
                              labelStyle: labelStyle,
                              border: myBorder,
                              filled: true,
                              fillColor: Colors.white12,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: phoneNumberController,
                            enabled: false,
                            style: labelStyle,
                            decoration: InputDecoration(
                              labelText: "Phone Number(Cannot be changed)",
                              labelStyle: labelStyle,
                              border: myBorder,
                              filled: true,
                              fillColor: Colors.white12,
                            ),
                          ),
                          SizedBox(height: 20),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.white12,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Update Profile",
                                style: signStyle,
                              ),
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState.validate()) {
                                UserModel collectionUser = UserModel(
                                    uid: widget.currentUser.uid,
                                    isPhoneVerified: true,
                                    username: userNameController.text,
                                    email: snapshot.data[UserModel.EMAIL_KEY],
                                    profilephoto: snapshot
                                        .data[UserModel.PROFILE_PHOTO_KEY],
                                    phoneNumber:
                                        snapshot.data[UserModel.PH_NO_KEY]);
                                _methods.updateProfile(
                                    widget.currentUser.uid, collectionUser);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.deepPurple,
                    thickness: 2,
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white12,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("LogOut", style: signStyle),
                    ),
                    onPressed: () async {
                      await _methods.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => signinScreen()),
                        ModalRoute.withName(''),
                      );
                    },
                  )
                ],
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("users")
            .document(widget.currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) => SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                drawer: drawer(),
                appBar: AppBar(
                  backgroundColor: Colors.deepPurpleAccent,
                  elevation: 0,
                  title: Text(
                    "HI, " + (snapshot.data[UserModel.USERNAME_KEY]),
                    style: signStyle,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(40))),
                ),
                body: StreamBuilder(
                  stream: Firestore.instance
                      .collection("Image_Collection")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                    if (snapshots.data == null)
                      return Center(child: CircularProgressIndicator());
                    else {
                      return ListView.builder(
                          itemCount: snapshots.data.documents.length,
                          itemBuilder: (context, index) {
                            return imageItem(snapshots.data.documents[index]);
                          });
                    }
                  },
                ),
                floatingActionButton: FloatingActionButton.extended(
                  icon: Icon(Icons.share),
                  label: Text("Share Images", style: labelStyle),
                  tooltip: "Click To share Images",
                  backgroundColor: Colors.deepPurpleAccent,
                  onPressed: () {
                    if (snapshot.data[UserModel.ISPHONE_VERIFIED_KEY])
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => UploadScreen(
                                    userID:
                                        snapshot.data[UserModel.USER_ID_KEY],
                                  )));
                    else {
                      PhoneNotVerifiedDialog(context);
                    }
                  },
                ),
              ),
            ));
  }

  imageItem(DocumentSnapshot snapshot) {
    return FutureBuilder(
        future: _methods.getUploaderName(snapshot.data[ImageModel.USERID_KEY]),
        builder: (context, uploaderNameSnapshot) => Container(
              color: Colors.deepPurpleAccent.withOpacity(0.2),
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(uploaderNameSnapshot.data.toString(),
                      style: uploaderStyle),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 250,
                    ),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              snapshot.data[ImageModel.IMG_URL_KEY]),
                        ),
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Text("#" + snapshot.data[ImageModel.HASHTAG_KEY],
                      style: imgDetailsStyle),
                  Text(
                    snapshot.data[ImageModel.NAME_KEY],
                    style: imgDetailsStyle,
                  ),
                  Text(
                    snapshot.data[ImageModel.TIME_KEY]
                        .toDate()
                        .toIso8601String()
                        .substring(0, 10),
                    style: imgDateStyle,
                  ),
                  Text(
                    snapshot.data[ImageModel.TIME_KEY]
                        .toDate()
                        .toIso8601String()
                        .substring(11, 16),
                    style: imgDateStyle,
                  )
                ],
              ),
            ));
  }
}
