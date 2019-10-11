import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class account_page extends StatefulWidget {
  _account_page createState() => _account_page();
}

class _account_page extends State<account_page>{
  TextStyle topbarText =
      TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle profileText =
      TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle detailText = TextStyle(color: Colors.black, fontSize: 16);
  TextStyle imageText = TextStyle(color: Color(0xff434343), fontSize: 16);
  TextStyle logoutText = TextStyle(
      color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);

  TextStyle subText = TextStyle(color: Color(0xff434343), fontSize: 14);

  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _mobile = TextEditingController();

  final Firestore _db = Firestore.instance;
  var userData;
  String _images;
  File _file;

  Future imagePicker() async {
    final File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _file = file;
    });
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("user_photo").child(user.uid);
    final StorageUploadTask storageUploadTask = storageReference.putFile(_file);
    await storageUploadTask.onComplete.then((err) {
      print("Ok");
    });
  }

  Future getUserData() async {
    DocumentSnapshot data;
    String imgData;
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("user_photo").child(user.uid);
    imgData = await storageReference.getDownloadURL().catchError((err) {
      imgData = null;
    });
    data = await _db.collection("seller").document(user.uid).get();
    setState(() {
      userData = data;
      _images = imgData;
      _firstname.text = userData["firstname"];
      _lastname.text = userData["lastname"];
      _mobile.text = userData["mobile"];
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffff4141),
        title: Text(
          "ข้อมูลบัญชี",
          style: topbarText,
        ),
      ),
      body: Container(
        color: Color(0xffe5e5e5),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            image: DecorationImage(
                              image: _file == null
                                  ? userData == null
                                      ? AssetImage("assets/icons/loading.gif")
                                      : _images == null
                                          ? AssetImage("assets/icons/logo.png")
                                          : NetworkImage(_images)
                                  : FileImage(_file),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      imagePicker();
                    },
                    child: Container(
                      child: Text(
                        "Change Profile Photo",
                        style: imageText,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Username", style: detailText),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                userData == null
                                    ? "Loading ..."
                                    : userData["email"],
                                style: subText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Email", style: detailText),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                userData == null
                                    ? "Loading ..."
                                    : userData["email"],
                                style: subText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Firstname", style: detailText),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: _firstname,
                                decoration: InputDecoration.collapsed(
                                    hintText: "Enter firstname"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Lastname", style: detailText),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: _lastname,
                                decoration: InputDecoration.collapsed(
                                    hintText: "Enter lastname"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Mobile", style: detailText),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: _mobile,
                                decoration: InputDecoration.collapsed(
                                    hintText: "Enter mobile number"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
