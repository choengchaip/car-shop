import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './RegisterPage.dart';
import 'Pages/Buyer/MainPage.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class login_page extends StatefulWidget {
  _login_page createState() => _login_page();
}

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
final db = Firestore.instance;
bool IsHas = false;

Future logInWithGoogle() async {
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
}

Future loginWithFacebook() async {
  final facebookLogin = FacebookLogin();
  final result = await facebookLogin.logIn(['email']);
  final token = result.accessToken.token;
  final graphResponse = await http.get(
      'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
  final profile = json.decode(graphResponse.body);

  final AuthCredential credential = FacebookAuthProvider.getCredential(
    accessToken: token,
  );
  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  user.updateEmail(profile['email']);
}

void _noUserFound(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("ไม่พบผู้ใช้"),
          content: Text("กรุณาใส่ อีเมลล์ / รหัสผ่าน ให้ถูกต้อง"),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("ตกลง")),
          ],
        );
      });
}

Future logInWithEmail(BuildContext context) async {
  try {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
            email: _email.text, password: _password.text))
        .user;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return main_page(0);
    }));
  } catch (e) {
    _noUserFound(context);
    print(e);
  }
}

TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();
bool _emailValidate = true;
bool _passwordValidate = true;
FocusNode _emailScope = FocusNode();
FocusNode _passwordScope = FocusNode();

bool keyboardExpand = false;
ScrollController _scrollController = ScrollController();

class _login_page extends State<login_page> with TickerProviderStateMixin {
  AnimationController _loadingAnimate;

  Future check() async {
    final FirebaseUser user = await _auth.currentUser();
    print("current user => ${user}");
    if (user == null) {
      await _googleSignIn.signOut();
    }else{
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {return main_page(0);}));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadingAnimate =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    _loadingAnimate.repeat();
    _loadingAnimate.addListener(() {
      if (_loadingAnimate.status == AnimationStatus.completed) {
        print("Yes");
      }
    });
    super.initState();
    check();
  }

  @override
  void dispose() {
    _loadingAnimate.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    var loadingPopup = () async {
      showDialog(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_loadingAnimate),
              child: Container(
                padding: EdgeInsets.all(50),
                child: Image.asset("assets/icons/logo.png"),
              ),
            ),
          );
        },
      );
    };
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
              Container(
                height: _height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/icons/logo.png",
                        width: 200,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _emailScope.requestFocus();
                                },
                                child: Container(
                                  height: 40,
                                  width: 280,
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      color: _emailValidate
                                          ? Colors.white
                                          : Color(0xffFFE7E6),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Color(0xffE8E8E8), width: 1)),
                                  child: IgnorePointer(
                                    child: TextField(
                                      focusNode: _emailScope,
                                      controller: _email,
                                      decoration: InputDecoration.collapsed(
                                          hintText: "อีเมลล์"),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _passwordScope.requestFocus();
                                  print(_height / 3);
                                },
                                child: Container(
                                  height: 40,
                                  width: 280,
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      color: _passwordValidate
                                          ? Colors.white
                                          : Color(0xffFFE7E6),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Color(0xffE8E8E8), width: 1)),
                                  child: IgnorePointer(
                                    child: TextField(
                                      focusNode: _passwordScope,
                                      controller: _password,
                                      decoration: InputDecoration.collapsed(
                                          hintText: "รหัสผ่าน"),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if (_email.text.isEmpty) {
                                    setState(() {
                                      _emailValidate = false;
                                    });
                                    return;
                                  } else {
                                    setState(() {
                                      _emailValidate = true;
                                    });
                                  }

                                  if (_password.text.isEmpty) {
                                    setState(() {
                                      _passwordValidate = false;
                                    });
                                    return;
                                  } else {
                                    setState(() {
                                      _passwordValidate = true;
                                    });
                                  }
                                  loadingPopup();
                                  logInWithEmail(context);
                                },
                                child: Container(
                                  height: 40,
                                  width: 280,
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Color(0xffE8E8E8), width: 1)),
                                  child: Text("เข้าสู่ระบบ"),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              register_page()));
                                },
                                child: Container(
                                  height: 40,
                                  width: 280,
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Color(0xffE8E8E8), width: 1)),
                                  child: Text("สมัครสมาชิก"),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 280,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Divider(),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "หรือ",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Divider(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  print("checking ..");
                                  loadingPopup();
                                  logInWithGoogle().then((err) {
                                    checkUser().then((err) {
                                      if (IsHas) {
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return main_page(0);
                                        }));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    register_page()));
                                      }
                                    });
                                  }).catchError((e) {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 280,
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Color(0xffE8E8E8), width: 1)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/icons/google.png",
                                        width: 25,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "เข้าสู่ระบบด้วย Google",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  print("checking ..");
                                  loadingPopup();
                                  loginWithFacebook().then((e) {
                                    checkUser().then((ee) {
                                      if (IsHas) {
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return main_page(0);
                                        }));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    register_page()));
                                      }
                                    });
                                  }).catchError((e) {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 280,
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xff385c8e),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/icons/facebook.png",
                                        width: 25,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("เข้าสู่ระบบด้วย Facebook",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
