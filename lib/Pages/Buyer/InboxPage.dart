import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class inbox_page extends StatefulWidget {
  _inbox_page createState() => _inbox_page();
}

class _inbox_page extends State<inbox_page> {
  TextStyle topbarText =
      TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

  TextStyle profileText =
      TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);

  TextStyle detailText = TextStyle(color: Colors.black, fontSize: 16);

  TextStyle logoutText = TextStyle(
      color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);

  final Firestore _auth = Firestore.instance;

  DocumentSnapshot _data;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  checkInbox()async{
    DocumentSnapshot data = await _auth.collection("notification").document("a").get();
//    setState(() {
//      _data = data;
//    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInbox();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message){
        print('OnMess : ${message}');
      },
      onResume: (Map<String, dynamic> message){
        print('OnRes : ${message}');
      },
      onLaunch: (Map<String, dynamic> message){
        print('OnLau : ${message}');
      },
      onBackgroundMessage: (Map<String, dynamic> message){
        print('OnBackMess : ${message}');
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffff4141),
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        color: Color(0xffff4141),
                        child: Text(
                          "แจ้งเตือน",
                          style: topbarText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: _data != null ? StreamBuilder(
                    stream: _auth.collection("brand").snapshots(),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                        return Container(
                          child: CircularProgressIndicator(),
                        );
                      }else{
                        return Column(
                          children: List.generate(snapshot.data.documents.length, (index){
                            return Container(
                              child: Text(snapshot.data.documents[index].data["brand"]),
                            );
                          }),
                        );
                      }
                    },
                  ):Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Image.asset("assets/icons/sleep.png",width: 100,),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          child: Text("No notifications",style: profileText,),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Text("Stay tuned! Notifications about your\nactivity will show up here.",style: detailText,textAlign: TextAlign.center,),
                        ),
                      ],
                    ),
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
