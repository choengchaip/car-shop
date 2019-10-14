import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sa_project/Pages/Buyer/MainPage.dart';
import 'BestPosts.dart';
import 'CarAnalysis.dart';
import 'DealerPage.dart';
import 'dart:convert';

class admin_page extends StatefulWidget {
  @override
  _admin_page createState() => _admin_page();
}

class _admin_page extends State<admin_page> {
  TextStyle topbarText =
      TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle priceText = TextStyle(
      color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle detailText = TextStyle(
      color: Color(0xff434343), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle analText = TextStyle(
      color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle cancelText = TextStyle(
      color: Color(0xff0000F2), fontSize: 14, fontWeight: FontWeight.bold);
  TextStyle nameText = TextStyle(
      color: Color(0xff434343), fontSize: 14, fontWeight: FontWeight.bold);
  final _db = Firestore.instance;
  final _ref = FirebaseStorage.instance;
  DocumentSnapshot bestDealer;
  String bestDealerImage;
  DocumentSnapshot bestPost;
  String bestPostImage;

  TextEditingController _min = TextEditingController();
  TextEditingController _max = TextEditingController();

  Future getBestDealer() async {
    DocumentSnapshot dealer;
    await _db
        .collection('buyer')
        .orderBy('clicks', descending: true)
        .limit(1)
        .getDocuments()
        .then((docs) {
      docs.documents.forEach((data) {
        dealer = data;
      });
    });
    String url = await _ref
        .ref()
        .child('passport_photo')
        .child(dealer.documentID)
        .getDownloadURL();
    setState(() {
      bestDealerImage = url;
      bestDealer = dealer;
    });
  }

  Future getBestPost() async {
    DocumentSnapshot post;
    await _db
        .collection('clicks')
        .orderBy('clicks', descending: true)
        .limit(1)
        .getDocuments()
        .then((docs) {
      docs.documents.forEach((data) {
        post = data;
      });
    });
    String url = await _ref
        .ref()
        .child('post_photo')
        .child(post.data['post'])
        .child('0')
        .getDownloadURL();
    setState(() {
      bestPostImage = url;
      bestPost = post;
    });
  }

  confirmDialog(){
    showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("Enter Age"),
        content: Container(
          width: 100,
          height: 100,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 90,
                      child: Text('Min Age',style: cancelText,),
                    ),
                    Container(
                      child: Text(''),
                    ),
                    Container(
                      width: 90,
                      child: Text('Max Age',style: cancelText,),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 90,
                      child: TextField(
                        controller: _min,
                      ),
                    ),
                    Container(
                      child: Text('-'),
                    ),
                    Container(
                      width: 90,
                      child: TextField(
                        controller: _max,
                      ),
                    ),
                  ],
                ),
              ),
              Container(),
            ],
          )
        ),
        actions: <Widget>[
          FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Cancel")),
          FlatButton(onPressed: (){Navigator.push(context, MaterialPageRoute(
            builder: (context){
              if(_min.text.isNotEmpty && _max.text.isNotEmpty){
                return car_anal(min: int.parse(_min.text),max: int.parse(_max.text),);
              }else{
                return car_anal();
              }
            }
          ));}, child: Text("Confirm"))
        ],
      );

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBestDealer();
    getBestPost();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Page",
          style: topbarText,
        ),
        backgroundColor: Color(0xffff4141),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return main_page(2);
                }));
              })
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'All Clicks',
                        style: detailText,
                      ),
                    ),
                    Container(
                      height: 100,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top: BorderSide(color: Color(0xffe5e5e5)),
                              bottom: BorderSide(color: Color(0xffe5e5e5)))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text('1231',style: analText,),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Text('CLICKS',style: cancelText,),
                          ),
                        ],
                      )
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Best Dealer',
                        style: detailText,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top: BorderSide(color: Color(0xffe5e5e5)),
                              bottom: BorderSide(color: Color(0xffe5e5e5)))),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            width: 100,
                            height: 100,
                            child: CircleAvatar(
                              backgroundImage: bestDealerImage == null
                                  ? AssetImage('assets/icons/loading.gif')
                                  : NetworkImage(bestDealerImage),
                              backgroundColor: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                  bestDealer == null
                                      ? 'Loading ...'
                                      : bestDealer.data['passpord'],
                                  style: detailText),
                            ),
                          ),
                          Container(
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    'จำนวนการเข้าชม',
                                    style: nameText,
                                  ),
                                ),
                                Container(
                                  child: Text(bestDealer == null
                                      ? 'Loading ...'
                                      : bestDealer.data['clicks'].toString()),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return dealer_page();
                        }));
                      },
                      child: Container(
                        height: 25,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          'View all dealer clicks',
                          style: cancelText,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Best Post',
                        style: detailText,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top: BorderSide(color: Color(0xffe5e5e5)),
                              bottom: BorderSide(color: Color(0xffe5e5e5)))),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: (100 / 0.75) - 15,
                            height: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: bestPostImage == null
                                        ? AssetImage('assets/icons/loading.gif')
                                        : NetworkImage(bestPostImage),
                                    fit: BoxFit.cover)),
                          ),
                          Expanded(
                            child: Container(
                              height: 77,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text('POST ID : ', style: nameText),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                        bestPost == null
                                            ? 'Loading ...'
                                            : bestPost.data['post'],
                                        style: nameText),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    'จำนวนการเข้าชม',
                                    style: nameText,
                                  ),
                                ),
                                Container(
                                  child: Text(bestPost == null
                                      ? 'Loading ...'
                                      : bestPost.data['clicks'].toString()),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return best_post();
                        }));
                      },
                      child: Container(
                        height: 25,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          'View all post clicks',
                          style: cancelText,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => car_anal()));
                      },
                      child: Container(
                        height: 100,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                top: BorderSide(color: Color(0xffe5e5e5)),
                                bottom: BorderSide(color: Color(0xffe5e5e5)))),
                        child: Text(
                          'Car Analysis',
                          style: analText,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 100,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top: BorderSide(color: Color(0xffe5e5e5)),
                              bottom: BorderSide(color: Color(0xffe5e5e5)))),
                      child: Text(
                        'Age Analysis',
                        style: analText,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 100,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top: BorderSide(color: Color(0xffe5e5e5)),
                              bottom: BorderSide(color: Color(0xffe5e5e5)))),
                      child: Text(
                        'Price Analysis',
                        style: analText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
//                Navigator.push(context, MaterialPageRoute(builder: (context){
//                  return car_anal();
//                }));
                confirmDialog();
              },
              child: Container(
                height: 70,
                alignment: Alignment.center,
                color: Color(0xffff4141),
                child: Text(
                  "Analysis",
                  style: topbarText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
