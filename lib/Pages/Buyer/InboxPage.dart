import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'PostDetail.dart';

class inbox_page extends StatefulWidget {
  _inbox_page createState() => _inbox_page();
}

class _inbox_page extends State<inbox_page> {
  TextStyle topbarText =
      TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

  TextStyle profileText = TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);
  TextStyle bodyText = TextStyle(color: Colors.black, fontSize: 14);

  TextStyle detailText = TextStyle(color: Colors.black, fontSize: 16);

  TextStyle logoutText = TextStyle(
      color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);

  final Firestore _db = Firestore.instance;

  List<DocumentSnapshot> _data = List<DocumentSnapshot>();
  List<DocumentSnapshot> noti = List<DocumentSnapshot>();
  List<String> postImage = List<String>();
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  Future checkInbox() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print('Loading ...');
    _db.collection("notifications").where(user.uid).snapshots().listen((docs) {
      setState(() {
        noti = docs.documents;
      });
      docs.documents.forEach((data) {
        _db.collection('post').document(data.data['post']).get().then((d) {
          setState(() {
            _data.add(d);
          });
          loadImage(data.data['post']);
        });
      });
    });
  }

  Future checkNotification(String post)async{
    _db.collection('notifications').document(post).updateData({'checked': true});
  }

  Future loadImage(String post) async {
    String url = await FirebaseStorage.instance
        .ref()
        .child('post_photo')
        .child(post)
        .child('0')
        .getDownloadURL();
    setState(() {
      postImage.add(url);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInbox();
    _firebaseMessaging.getToken().then((token) {

    });
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
                  child: _data.length == 0 ? Container(
                          alignment: Alignment.center,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Image.asset(
                                    "assets/icons/sleep.png",
                                    width: 100,
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  child: Text(
                                    "No notifications",
                                    style: profileText,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text(
                                    "Stay tuned! Notifications about your\nactivity will show up here.",
                                    style: detailText,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      : Container(
                          child: ListView.builder(
                              itemCount: noti.length ,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    checkNotification(noti[index].documentID).then((err){
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                            return post_detail(_data[index]);
                                          }));
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    padding: EdgeInsets.only(
                                        top: 5, bottom: 5, left: 5, right: 5),
                                    height: 120,
                                    color: noti[index].data['checked'] ? Color(0xfff1f1f1) : Color(0xffffe3e3),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 120 * 4 / 3,
                                          child: postImage.length < index + 1
                                              ? Image.asset('assets/icons/logo.png')
                                              : Image.network(
                                                  postImage[index],
                                                  fit: BoxFit.fitWidth,
                                                ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(noti.length < index+1 ? '' : noti[index].data['title'],style: profileText),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(noti.length < index+1 ? '' : noti[index].data['body'],style: bodyText,),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 80,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffc0c0c0),
                                                      borderRadius: BorderRadius.all(Radius.circular(6))
                                                    ),
                                                    child: Text(DateFormat('yyyy-MM-dd').format(noti[index].data['date'].toDate()).toString(),style: bodyText,),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
