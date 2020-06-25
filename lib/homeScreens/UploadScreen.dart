import 'package:apli/Model/CollectionUser.dart';
import 'package:apli/Model/imageModel.dart';
import 'package:apli/utils/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;

class UploadScreen extends StatefulWidget {
  String userID;

  UploadScreen({@required this.userID});
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  TextEditingController hashTagController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  FocusNode hashNode = FocusNode();
  FocusNode nameNode = FocusNode();

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
        ImageModel imageModel = ImageModel(
            uid: widget.userID,
            image_url: fileURL,
            name: nameController.text,
            hashtag: hashTagController.text,
            time: DateTime.now());
        Firestore.instance
            .collection("Image_Collection")
            .add(imageModel.toJson());
        Navigator.pop(context);
      });
    });
  }

  clearSection() {
    setState(() {
      _image = null;
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

  File _image;
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
                    Text("Share Image", style: headingStyle),
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
                    _image != null
                        ? TextField(
                            focusNode: hashNode,
                            controller: hashTagController,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (str) {
                              FocusScope.of(context).requestFocus(nameNode);
                            },
                            style: labelStyle,
                            decoration: InputDecoration(
                                labelText: "Hashtags",
                                labelStyle: labelStyle,
                                enabledBorder: myBorder,
                                focusedBorder: myBorder,
                                border: myBorder,
                                filled: true,
                                fillColor: Colors.white12),
                          )
                        : Container(),
                    SizedBox(height: 20),
                    _image != null
                        ? TextField(
                            focusNode: nameNode,
                            onSubmitted: (str) {
                              FocusScope.of(context).unfocus();
                            },
                            controller: nameController,
                            style: labelStyle,
                            decoration: InputDecoration(
                                labelText: "PhotoName",
                                labelStyle: labelStyle,
                                enabledBorder: myBorder,
                                focusedBorder: myBorder,
                                border: myBorder,
                                filled: true,
                                fillColor: Colors.white12),
                          )
                        : Container(),
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
                    SizedBox(height: 50),
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
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
