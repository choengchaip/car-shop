import 'package:flutter/material.dart';
import 'package:sa_project/Pages/Seller/MainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sa_project/LoginPage.dart';
import './AccountPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class profile_page extends StatefulWidget {
  _profile_page createState() => _profile_page();
}

class _profile_page extends State<profile_page> {

  TextStyle topbarText = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

  TextStyle profileText = TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);

  TextStyle detailText = TextStyle(color: Colors.black, fontSize: 16);

  TextStyle logoutText = TextStyle(color: Color(0xffff4141), fontSize: 16,fontWeight: FontWeight.bold);

  final Firestore _db = Firestore.instance;

  Future logout()async{
    print("logging out ...");
    await FirebaseAuth.instance.signOut();
    print("logged out");
  }

  var userData;
  String _images;

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
    return Container(
      color: Color(0xffff4141),
      child: SafeArea(
        child: Container(
          color: Color(0xffE5E5E5),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      color: Color(0xffff4141),
                      child: Text(
                        "บัญชี",
                        style: topbarText,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return account_page();
                                }));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.grey)]
                                ),
                                alignment: Alignment.center,
                                height: 80,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: _images == null ? AssetImage("assets/icons/loading.gif") : NetworkImage(_images),
                                    maxRadius: 25,
                                  ),
                                  title: Text(userData == null ? "Loading ..." : userData["firstname"]+" "+userData["lastname"],style: profileText,),
                                  subtitle: Text("View and Edit your Profile"),
                                  trailing: Icon(Icons.arrow_forward_ios,size: 20,),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 20,right: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.grey)]
                              ),
                              alignment: Alignment.centerLeft,
                              height: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Switch to Selling",style: detailText,),
                                  Switch(value: false,activeColor: Color(0xffff4141), onChanged: (key){
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                      return main_page();
                                    }));
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 20,right: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.grey)]
                              ),
                              alignment: Alignment.centerLeft,
                              height: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Inbox Notifications",style: detailText,),
                                  Switch(value: false, onChanged: (key){}),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.grey)]
                              ),
                              alignment: Alignment.centerLeft,
                              height: 60,
                              child: Text("Privacy policy & Terms of use",style: detailText,),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.grey)]
                              ),
                              alignment: Alignment.centerLeft,
                              height: 60,
                              child: Text("Help & Feedback",style: detailText,),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.grey)]
                              ),
                              alignment: Alignment.centerLeft,
                              height: 60,
                              child: Text("Rate Us",style: detailText,),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.grey)]
                              ),
                              alignment: Alignment.centerLeft,
                              height: 60,
                              child: Text("Share this app",style: detailText,),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: ()async {
                                await logout().then((e){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                    return login_page();
                                  }));
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [BoxShadow(color: Colors.grey)]
                                ),
                                alignment: Alignment.center,
                                height: 60,
                                child: Text("Logout",style: logoutText,),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
