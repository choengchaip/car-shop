import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import './Pages/Buyer/MainPage.dart';
import 'LoginPage.dart';
import 'package:flutter/services.dart';

class register_page extends StatefulWidget {
  _register_page createState() => _register_page();
}

final db = Firestore.instance;
var userData = {"email": "", "firstname": "", "lastname": "", "mobile": ""};
bool isRegis = true;
File _image;
final _auth = FirebaseAuth.instance;

class _register_page extends State<register_page> {
  TextStyle textField = TextStyle(fontWeight: FontWeight.bold);

  TextStyle confirmText =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.white);

  bool IsHas = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  Future getUserData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user);
    if (user == null) {
      setState(() {
        isRegis = true;
      });
      return;
    }
    setState(() {
      isRegis = false;
    });
    List<String> names = user.displayName.split(" ");
    String firstName = names[0];
    String lastName = names[1];
    setState(() {
      userData["email"] = user.email;
      userData["firstname"] = firstName;
      userData["lastname"] = lastName;
      userData["mobile"] = user.phoneNumber;
      _firstname.text = userData["firstname"];
      _lastname.text = userData["lastname"];
      _phone.text = userData["mobile"];
      _email.text = userData["email"];
    });
  }

  Future imagesUpload() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future checkUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var id = user.uid;
    DocumentSnapshot snapshot =
        await db.collection("accounts").document(id).get();

    setState(() {
      if (snapshot.data == null) {
        IsHas = false;
      } else {
        IsHas = true;
      }
    });
  }

  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _repassword = TextEditingController();

  bool keyboardExpand = false;

  @override
  Widget build(BuildContext context) {
    loadingPopup() {
      return showDialog(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child: Image.asset("assets/icons/logo.png"),
              color: Colors.black12,
            ),
          );
        },
      );
    }

    Future uploadData() async {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      StorageReference storageRef =
          FirebaseStorage.instance.ref().child("user_photo").child(user.uid);

      await db
          .collection("accounts")
          .document(user.uid)
          .setData({"status": true}).then((err) {
        print("Success:1 /");
      });

      await db
          .collection("seller")
          .document(user.uid)
          .setData(userData)
          .then((err) {
        print("Success:2 /");
      });

      if (_image != null) {
        StorageUploadTask mission = storageRef.putFile(_image);
        mission.onComplete.then((err) {
          print("Success:3 /");
          checkUser().then((s) {
            if (IsHas) {
              if (!isRegis) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("สมัครสมาชิกสำเร็จ!"),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("ตกลง"))
                        ],
                      );
                    });
              } else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return main_page(0);
                }));
              }
            } else {
              Navigator.of(context).pop();
            }
          });
        });
      } else {
        await checkUser().then((s) {
          print("Success:3 /");
          if (IsHas) {
            if(!isRegis){
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                    return main_page(0);
                  }));
            }
          } else {
            Navigator.of(context).pop();
          }
        });
      }
    }

    Future _validateAlert(String header) async {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(header),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("ตกลง"),
                )
              ],
            );
          });
    }

    Future _successAlert(String header) async {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(header),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                      return login_page();
                    }));
                  },
                  child: Text("ตกลง"),
                )
              ],
            );
          });
    }

    Future registerWithEmail() async {
      print("registering ..");
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _email.text, password: _password.text);
      }on PlatformException{

      }
      await uploadData();
      await checkUser();
      if (IsHas) {
        _successAlert("สมัครสมาชิกสำเร็จ!");
      } else {
        _validateAlert("สมัครสมาชิกม่สำเร็จ");
      }
    }

    bool confirmData() {
      print("checking ..");
      if (_image == null ||
          _firstname.text.isEmpty ||
          _lastname.text.isEmpty ||
          _phone.text.isEmpty ||
          _age.text.isEmpty ||
          _email.text.isEmpty) {
        _validateAlert("กรุณาใส่ข้อมูลให้ครบ");
        return false;
      }
      if (_password.text != _repassword.text) {
        _validateAlert("รหัสผ่านไม่ตรงกัน");
        return false;
      } else {
        setState(() {
          userData["firstname"] = _firstname.text;
          userData["lastname"] = _lastname.text;
          userData["mobile"] = _phone.text;
          userData["age"] = _age.text;
          userData["email"] = _email.text;
        });
        return true;
      }
    }

    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Color(0xffff4141),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  color: Color(0xffff4141),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: ListView(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height -
                              25 -
                              MediaQuery.of(context).padding.bottom -
                              MediaQuery.of(context).padding.top -
                              60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 150,
                                alignment: Alignment.center,
                                width: 150,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    image: DecorationImage(
                                        image: _image == null
                                            ? AssetImage(
                                                "assets/icons/logo.png")
                                            : FileImage(_image),
                                        fit: BoxFit.cover)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      imagesUpload();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 120,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Color(0xffFFE7E6),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Text(
                                        "อัพโหลดรูปภาพ",
                                        style: textField,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    width: _width - 80,
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        color: Color(0xffFFE7E6),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: TextField(
                                      controller: _email,
                                      enabled: isRegis
                                          ? true
                                          : userData == null
                                              ? true
                                              : userData['email'] == null ||
                                                      userData['email'].isEmpty
                                                  ? true
                                                  : false,
                                      decoration: InputDecoration.collapsed(
                                          hintText: isRegis
                                              ? 'อีเมลล์'
                                              : userData == null
                                                  ? 'Loading...'
                                                  : userData['email'] == null ||
                                                          userData['email']
                                                              .isEmpty
                                                      ? 'อีเมลล์'
                                                      : userData["email"]),
                                      style: textField,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    width: _width - 80,
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        color: Color(0xffFFE7E6),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: TextField(
                                      controller: _password,
                                      decoration: InputDecoration.collapsed(
                                          hintText: "รหัสผ่าน"),
                                      style: textField,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    width: _width - 80,
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        color: Color(0xffFFE7E6),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: TextField(
                                      controller: _repassword,
                                      decoration: InputDecoration.collapsed(
                                          hintText: "ยืนยันรหัสผ่าน"),
                                      style: textField,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 40,
                                        width: (_width - 79) / 2,
                                        padding: EdgeInsets.only(left: 10),
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            color: Color(0xff9AFF9E),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: TextField(
                                          controller: _firstname,
                                          decoration: InputDecoration.collapsed(
                                              hintText: "ชื่อจริง"),
                                          style: textField,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 40,
                                        width: (_width - 79) / 2,
                                        padding: EdgeInsets.only(left: 10),
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            color: Color(0xffFFC9EC),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: TextField(
                                          controller: _lastname,
                                          decoration: InputDecoration.collapsed(
                                              hintText: "นามสกุล"),
                                          style: textField,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    width: _width - 80,
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        color: Color(0xffFFE7E6),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: TextField(
                                      controller: _age,
                                      decoration: InputDecoration.collapsed(
                                          hintText: "อายุ"),
                                      style: textField,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    width: _width - 80,
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        color: Color(0xffFFC9C9),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: TextField(
                                      controller: _phone,
                                      decoration: InputDecoration.collapsed(
                                          hintText: "เบอร์โทรศัพท์"),
                                      style: textField,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (confirmData()) {
                      if (isRegis) {
                        print("Upload 1");
                        registerWithEmail();
//                      _auth.createUserWithEmailAndPassword(email: _email.text, password: _register_page)
                      } else {
//                      uploadData();
                      }
                    }
                  },
                  child: Container(
                    color: Color(0xffff4141),
                    height: 60,
                    alignment: Alignment.center,
                    child: Text(
                      "สมัครสมาชิก",
                      style: confirmText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
