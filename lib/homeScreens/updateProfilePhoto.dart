import 'package:apli/Model/CollectionUser.dart';
import 'package:apli/methods/firebase_methods.dart';
import 'package:apli/utils/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;

class UpdateDPScreen extends StatefulWidget {
  UserModel currentCollectionUser;
  UpdateDPScreen({@required this.currentCollectionUser});
  @override
  _UpdateDPScreenState createState() => _UpdateDPScreenState();
}

class _UpdateDPScreenState extends State<UpdateDPScreen> {
  FirebaseMethods _methods = FirebaseMethods();
  bool isLoading = false;

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        isLoading = false;
        _uploadedFileURL = fileURL;
        Navigator.pop(context);
      });
      updateDP();
    });
  }

  openOptions() async {
    showModalBottomSheet(
        backgroundColor: Colors.white12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo, color: Colors.white),
                  title: Text(
                    "Gallery",
                    style: signStyle,
                  ),
                  onTap: () async {
                    await ImagePicker.pickImage(source: ImageSource.gallery)
                        .then((image) {
                      setState(() {
                        Navigator.pop(context);
                        _image = image;
                      });
                    });
                  },
                ),
                Divider(
                  color: Colors.deepPurpleAccent,
                  thickness: 2,
                ),
                ListTile(
                  leading: Icon(Icons.camera, color: Colors.white),
                  title: Text(
                    "Camera",
                    style: signStyle,
                  ),
                  onTap: () async {
                    await ImagePicker.pickImage(source: ImageSource.camera)
                        .then((image) {
                      setState(() {
                        Navigator.pop(context);
                        _image = image;
                      });
                    });
                  },
                ),
              ],
            ),
          );
        });
  }

  clearSection() {
    setState(() {
      _image = null;
      _uploadedFileURL = "";
    });
  }

  updateDP() {
    widget.currentCollectionUser.profilephoto = _uploadedFileURL;
    _methods.updateProfile(
        widget.currentCollectionUser.uid, widget.currentCollectionUser);
  }

  removeDP() {
    widget.currentCollectionUser.profilephoto = "";
    _methods.updateProfile(
        widget.currentCollectionUser.uid, widget.currentCollectionUser);
  }

  File _image;
  String _uploadedFileURL;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.blue,
                  Colors.deepPurple,
                  Colors.deepPurpleAccent
                ])),
            child: Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    SizedBox(height: 40),
                    Text("Update DP", style: headingStyle),
                    SizedBox(height: 30),
                    Container(
                      height: 200,
                      color: Colors.white12,
                      child: _image != null
                          ? Image.file(_image)
                          : Center(
                              child: Text(
                                "No Image Selected",
                                style: labelStyle,
                              ),
                            ),
                    ),
                    SizedBox(height: 20),
                    _image == null
                        ? FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.white12,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Choose File",
                                style: signStyle,
                              ),
                            ),
                            onPressed: openOptions)
                        : Container(),
                    !isLoading && _image != null
                        ? FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.white12,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Upload",
                                style: signStyle,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                                uploadFile();
                              });
                            })
                        : Container(),
                    SizedBox(height: 20),
                    _image != null
                        ? FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.white12,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Clear",
                                style: signStyle,
                              ),
                            ),
                            onPressed: clearSection)
                        : Container(),
                    SizedBox(height: 30),
                    FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.redAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "Remove Profile Photo",
                            style: signStyle,
                          ),
                        ),
                        onPressed: () {
                          removeDP();
                          Navigator.pop(context);
                        })
                  ],
                ),
                isLoading
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Uploading..", style: signStyle),
                          CircularProgressIndicator(),
                        ],
                      ))
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
