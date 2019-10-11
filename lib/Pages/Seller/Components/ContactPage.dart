import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class contact_page extends StatefulWidget {
  _contact_page createState() => _contact_page();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _db = Firestore.instance;

class _contact_page extends State<contact_page> {
  Map<String,dynamic> userData = Map<String,dynamic>();
  TextStyle detailText = TextStyle(
      color: Color(0xff434343), fontSize: 16, fontWeight: FontWeight.bold);

  TextStyle nameText = TextStyle(
      color: Color(0xff434343), fontSize: 14, fontWeight: FontWeight.bold);
  TextStyle subText = TextStyle(color: Color(0xff434343), fontSize: 14);
  TextStyle nextText =
      TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle createText =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

  TextStyle whiteText = TextStyle(color: Colors.white, fontSize: 14);
  TextStyle redText = TextStyle(color: Color(0xffff4141), fontSize: 14);

  TextStyle warnText = TextStyle(color: Color(0xff434343), fontSize: 13);
  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _passpord = TextEditingController();
  TextEditingController _about = TextEditingController();

  getUserData() async {
    final FirebaseUser user = await _auth.currentUser();
    Map<String, dynamic> data = Map<String, dynamic>();
    final DocumentSnapshot ref = await _db.collection("buyer").document(user.uid).get();
    data = ref.data;

    final StorageReference passportRef = await FirebaseStorage.instance
        .ref()
        .child("passport_photo")
        .child(user.uid);
    String url1 = await passportRef.getDownloadURL().catchError((key) {
      return null;
    });

    final StorageReference faceRef = await FirebaseStorage.instance
        .ref()
        .child("face_photo")
        .child(user.uid);
    String url2 = await faceRef.getDownloadURL().catchError((key) {
      return null;
    });

    setState(() {
      userData.addAll(data);
      _urlPassport = url1;
      _urlId = url2;
    });

    setState(() {
      _firstname.text = userData != null ? userData["firstName"] : "";
      _lastname.text = userData != null ? userData["lastName"] : "";
      _email.text = userData != null ? userData["email"] : "";
      _mobile.text = userData != null ? userData["phone"] : "";
      _passpord.text = userData != null ? userData["passpord"] : "";
      _about.text = userData != null ? userData["about"] : "";
    });

  }

  File _passportImage;
  File _faceImage;

  Future uploadImages() async {
    if ((_passportImage == null || _faceImage == null) &&
        (_urlId == null || _urlPassport == null)) {
      return;
    }
    final FirebaseUser user = await _auth.currentUser();
    if (_passportImage != null) {
      final StorageReference ref1 = FirebaseStorage.instance
          .ref()
          .child("passport_photo")
          .child(user.uid);
      ref1.putFile(_passportImage);
    }

    if (_faceImage != null) {
      final StorageReference ref2 =
          FirebaseStorage.instance.ref().child("face_photo").child(user.uid);
      ref2.putFile(_faceImage);
    }

  }

  String _urlId;
  String _urlPassport;

  Future idImage() async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 380);
    setState(() {
      _passportImage = file;
    });
  }

  Future faceImage() async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 380);
    setState(() {
      _faceImage = file;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {

    Future uploadData() async {
      final FirebaseUser user = await _auth.currentUser();
      var data = {
        "firstName": _firstname.text,
        "lastName": _lastname.text,
        "email": _email.text,
        "phone": _mobile.text,
        "passpord": _passpord.text,
        "about": _about.text,
        "clicks":0
      };
      userData.addAll(data);
      print(userData);
      await _db.collection("buyer").document(user.uid).setData(userData);
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Color(0xffff4141),
        title: Text(
          "Contact Information",
          style: createText,
        ),
      ),
      body: Container(
        color: Color(0xffE5E5E5),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "To protext our marketplace and guarantee a safe environment for both buyers and sellers we will verify your contact information",
                        style: warnText,
                      ),
                    ),
                    Container(
                      height: 60,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(color: Colors.grey),
                      ]),
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Name*",
                                style: subText,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: _firstname,
                                style: nameText,
                                decoration: InputDecoration.collapsed(
                                    hintText: "Enter firstname"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(color: Colors.grey),
                      ]),
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Last Name*",
                                style: subText,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: _lastname,
                                style: nameText,
                                decoration: InputDecoration.collapsed(
                                    hintText: "Enter lastname"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(color: Colors.grey),
                      ]),
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Email*",
                                style: subText,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: _email,
                                style: nameText,
                                decoration: InputDecoration.collapsed(
                                    hintText: "Enter e-mail"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(color: Colors.grey),
                      ]),
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Mobile Number*",
                                style: subText,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: _mobile,
                                style: nameText,
                                decoration: InputDecoration.collapsed(
                                    hintText: "Enter mobile number"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(color: Colors.grey),
                      ]),
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Shop Display Name",
                                style: subText,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: _passpord,
                                style: nameText,
                                decoration: InputDecoration.collapsed(
                                    hintText: "Enter id/passport number"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      decoration:
                      BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(color: Colors.grey),
                      ]),
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "About You",
                                style: subText,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: _about,
                                style: nameText,
                                decoration: InputDecoration.collapsed(
                                    hintText: "Enter detail about you"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(color: Colors.grey),
                      ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 60,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Avartar Image of your post",
                                      style: subText,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      idImage();
                                    },
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.add,
                                          size: 25,
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: _passportImage != null
                                ? 100 * 0.75
                                : _urlPassport != null ? 100 * 0.75 : 0,
                            width: 100,
                            child: _passportImage != null
                                ? Image.file(
                                    _passportImage,
                                    fit: BoxFit.cover,
                                  )
                                : _urlPassport != null
                                    ? Image.network(
                                        _urlPassport,
                                        fit: BoxFit.cover,
                                      )
                                    : Text("Loading ..."),
                          ),
                          SizedBox(
                            height: _passportImage != null
                                ? 20
                                : _urlPassport != null ? 20 : 0,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(color: Colors.grey),
                      ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 60,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Your post backgroud image",
                                      style: subText,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      faceImage();
                                    },
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.add,
                                          size: 25,
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: _faceImage != null
                                ? 100 * 0.75
                                : _urlId != null ? 100 * 0.75 : 0,
                            width: 100,
                            child: _faceImage != null
                                ? Image.file(
                                    _faceImage,
                                    fit: BoxFit.cover,
                                  )
                                : _urlId != null
                                    ? Image.network(
                                        _urlId,
                                        fit: BoxFit.cover,
                                      )
                                    : Text("Loading ..."),
                          ),
                          SizedBox(
                            height: _faceImage != null
                                ? 20
                                : _urlId != null ? 20 : 0,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: Text(
                        "Please make sure your information is updated and accurate so that interested buyers can contact you. Please verify your mobile number",
                        style: warnText,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Images of documents are for cehicle ownership verification only. It will not appear on your listing",
                        style: warnText,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async{
                await uploadImages();
                await uploadData().then((e){
                  Navigator.of(context).pop("Ok");
                });
              },
              child: Container(
                color: Color(0xffFBFF95),
                alignment: Alignment.center,
                height: 65,
                child: Text(
                  "Confirm",
                  style: nextText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
