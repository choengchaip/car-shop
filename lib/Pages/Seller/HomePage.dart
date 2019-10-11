import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'Components/AdDescription.dart';
import 'Components/ContactPage.dart';
import 'Components/LocationPage.dart';
import 'Components/RegistrationYear.dart';
import 'Components/VehicleDetails.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sa_project/Pages/Buyer/PostDetail.dart';

import 'MainPage.dart';

class home_page extends StatefulWidget {
  _home_page createState() => _home_page();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final _db = Firestore.instance;

class _home_page extends State<home_page> {
  TextStyle detailText = TextStyle(
      color: Color(0xff434343), fontSize: 16, fontWeight: FontWeight.bold);

  TextStyle nameText = TextStyle(
      color: Color(0xff434343), fontSize: 14, fontWeight: FontWeight.bold);
  TextStyle subText = TextStyle(color: Color(0xff434343), fontSize: 14);
  TextStyle nextText =
      TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle createText =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

  TextStyle whiteText =
      TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold);
  TextStyle redText = TextStyle(color: Color(0xffff4141), fontSize: 14);

  TextStyle contactText = TextStyle(
      color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);
  List<DocumentSnapshot> postData;

  var colors = [
    {"name": "All", "color": 0xff},
    {"name": "White", "color": 0xffffffff},
    {"name": "Green", "color": 0xff6DA06D},
    {"name": "Grey", "color": 0xffA8A8A},
    {"name": "Red", "color": 0xffff4141},
    {"name": "Gold", "color": 0xffFBFF95},
    {"name": "Black", "color": 0xff000000},
    {"name": "Sliver", "color": 0xffc9c9c9},
    {"name": "Blue", "color": 0xff4694FD},
    {"name": "Brown", "color": 0xffA29A5E},
    {"name": "Beige", "color": 0xffF2EED0},
    {"name": "Pink", "color": 0xffEFB3EA},
    {"name": "Light Blue", "color": 0xffB2D3FF},
    {"name": "Violet", "color": 0xffCDC9FF},
    {"name": "Yellow", "color": 0xffFFFF4A},
    {"name": "Orange", "color": 0xffFFBC79},
    {"name": "Other", "color": 0xff},
  ];
  var selectColors = [
    {"name": "Green", "color": 0xff6DA06D},
    {"name": "Red", "color": 0xffff4141},
    {"name": "Gold", "color": 0xffFBFF95},
    {"name": "Sliver", "color": 0xffc9c9c9},
    {"name": "Blue", "color": 0xff4694FD},
    {"name": "Brown", "color": 0xffA29A5E},
    {"name": "Beige", "color": 0xffF2EED0},
    {"name": "Pink", "color": 0xffEFB3EA},
    {"name": "Light Blue", "color": 0xffB2D3FF},
    {"name": "Violet", "color": 0xffCDC9FF},
    {"name": "Yellow", "color": 0xffFFFF4A},
    {"name": "Orange", "color": 0xffFFBC79},
  ];

  var selectColor = {"name": "All", "color": 0xff};

  String displayName = "Loading ...";

  Future getUserData() async {
    FirebaseUser user = await _auth.currentUser();
    setState(() {
      displayName = user.displayName;
      carData["uid"] = user.uid;
    });
  }

  bool requirePlate = true;

  //firest_page
  TextEditingController plateNumber = TextEditingController();
  TextEditingController refNumber = TextEditingController();
  TextEditingController _mileage = TextEditingController();
  TextEditingController _price = TextEditingController();

  //second_page

  PageController _scrollController = PageController(initialPage: 0);
  PageController _listController = PageController(initialPage: 0);
  List<File> images = List<File>();
  int progress = 0;

  bool p1 = false;
  bool p2 = false;
  bool p3 = false;
  bool p4 = false;
  bool p5 = false;
  bool p6 = false;
  bool p7 = false;
  bool p8 = false;

  String toMoney(String money) {
    //1200000
    //
    String tmp = "";
    String data = "";
    int count = 1;
    for (int i = money.length - 1; i >= 0; i--) {
      tmp += money[i];
      if (count % 3 == 0 && i > 0) {
        tmp += ",";
        count = 1;
        continue;
      }
      count++;
    }
    for (int i = tmp.length - 1; i >= 0; i--) {
      data += tmp[i];
    }
    return data;
  }

  Future imageSelect() async {
    final file =
        await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 500);

    if (file != null) {
      setState(() {
        images.add(file);
      });
      if (!p1) {
        setState(() {
          progress += 1;
          p1 = true;
        });
      }
    }
  }

  String _text = "";
  var _images;

  checkContact() async {
    final FirebaseUser user = await _auth.currentUser();
    final DocumentSnapshot ref =
        await _db.collection("buyer").document(user.uid).get();
    if (ref.data != null) {
      if (ref.data["passpord"] != "" && ref.data["phone"] != "") {
        setState(() {
          p8 = true;
          progress += 1;
        });
      }
    }
  }

  Future getCarData() async {
    final FirebaseUser user = await _auth.currentUser();
    _db
        .collection("post")
        .where("uid", isEqualTo: user.uid)
        .getDocuments()
        .then((data) {
      List<DocumentSnapshot> a = data.documents;
      setState(() {
        postData = a;
        getCarImages();
      });
    });
  }

  Future getCarImages() async {
    List<List<String>> img = [];
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child("post_photo");

    for (int i = 0; i < postData.length; i++) {
      List<String> tmp = [];
      for (int j = 0; j < postData[i].data["size"]; j++) {
        String _url = await storageRef
            .child(postData[i].documentID)
            .child(j.toString())
            .getDownloadURL()
            .catchError((err) {
          return null;
        });
        tmp.add(_url);
      }
      img.add(tmp);
    }
    setState(() {
      _images = img;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    checkContact();
    getCarData();
  }

  Map<String, dynamic> carData = {"uid": ""};

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kBottomNavigationBarHeight -
        MediaQuery.of(context).padding.bottom;

    uploadContent() async {
      setState(() {
        carData["date"] = new DateTime.now().toUtc();
      });
      final DocumentReference ref = await _db.collection("post").add(carData);
      print(ref.documentID);
      await _db
          .collection("post")
          .document(ref.documentID)
          .updateData({"size": images.length});

      for (int i = 0; i < images.length; i++) {
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child("post_photo")
            .child(ref.documentID)
            .child(i.toString());
        StorageUploadTask storageUploadTask =
            storageReference.putFile(images[i]);
        await (await storageUploadTask.onComplete).ref.getDownloadURL();
      }
      await _db.collection("clicks").add({"clicks": 0, "post": ref.documentID});
    }

    void _showDialog(String body) {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("ข้อมูลไม่ครบ"),
            content: new Text(body),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    var loadingPopup = () {
      showDialog(
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
    };

    Future<bool> checkData() async {
      if (!p1) {
        _showDialog("กรุณาเพิ่มรูปภาพ");
        return false;
      }
      if (!p2) {
        _showDialog("กรุณาใส่ข้อมูลรถยนต์");
        return false;
      }
      if (!p3) {
        _showDialog("กรุณาใส่ข้อมูลสถานที่");
        return false;
      }
      if (!p4) {
        _showDialog("กรุณาใส่ปีที่จดทะเบียนรถ");
        return false;
      }
      if (!p5) {
        _showDialog("กรุณาใส่เลขไมล์");
        return false;
      }
      if (!p6) {
        _showDialog("กรุณาใส่ราคารถยนต์");
        return false;
      }
      if (!p7) {
        _showDialog("กรุณาใส่รายละเอียดโพส");
        return false;
      }
      if (!p8) {
        _showDialog("กรุณาอัพเดทข้อมูลการติดต่อ");
        return false;
      }

      if (progress == 8) {
        loadingPopup();
        await uploadContent().then((e) {
          return true;
        });
      }
      return false;
    }

    int k = (progress) + 1;
    Widget a(int index) {
      k--;
      return Expanded(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            color: k > 0 ? Color(0xff6DA06D) : Colors.grey,
          ),
          height: 7,
          margin: EdgeInsets.only(right: 5),
        ),
      );
    }

    Future deletePost(DocumentSnapshot postData) async {
      await _db.collection("age_clicks").where("post", isEqualTo: postData.documentID).getDocuments().then((docs){
        docs.documents.forEach((data){
          _db.runTransaction((Transaction myTran) async {
            await myTran.delete(data.reference);
          });
        });
      });

      await _db.collection("clicks").where("post", isEqualTo: postData.documentID).getDocuments().then((docs){
        docs.documents.forEach((data){
          _db.runTransaction((Transaction myTran) async {
            await myTran.delete(data.reference);
          });
        });
      });

      await _db.collection("headerComment").where("post", isEqualTo: postData.documentID).getDocuments().then((docs){
        docs.documents.forEach((data){
          _db.runTransaction((Transaction myTran) async {
            await myTran.delete(data.reference);
          });
        });
      });

      await _db.collection("subComment").where("post", isEqualTo: postData.documentID).getDocuments().then((docs){
        docs.documents.forEach((data){
          _db.runTransaction((Transaction myTran) async {
            await myTran.delete(data.reference);
          });
        });
      });

      await _db.runTransaction((Transaction myTran) async {
        DocumentReference ref = _db.collection("post").document(postData.documentID);
        await myTran.delete(ref);
      });

    }

    Future deleteTest() async {
      await _db.collection("dummy").where("key",isEqualTo: "123").getDocuments().then((docs){
        docs.documents.forEach((data){
          DocumentReference ref = data.reference;
          _db.runTransaction((Transaction myTran) async {
            await myTran.delete(ref);
          });
        });
      });
    }

    deleteAlert(DocumentSnapshot postData) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Confirm delete ?"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
                FlatButton(
                  onPressed: () {
                    deletePost(postData).then((e){
                      getCarData();
                    });
                    print("Deleted");
                    Navigator.of(context).pop();
                  },
                  child: Text("Confirm"),
                ),
              ],
            );
          });
    }

    double _width = MediaQuery.of(context).size.width;

    Widget firstPage = Container(
      child: Column(
        children: <Widget>[
          Container(
            child: InkWell(
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 50,
                      color: Color(0xffff4141),
                      child: Text(
                        "Create Ad",
                        style: createText,
                      ),
                      alignment: Alignment.center,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      height: 50,
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _listController.animateToPage(0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          });
                        },
                        child: Icon(
                          Icons.expand_more,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: 100,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Let's upload a vehicle",
                                textAlign: TextAlign.center,
                                style: detailText,
                                softWrap: false,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "A vehicle plate number or a reference\nnumber will help you find ads easily",
                                style: subText,
                                textAlign: TextAlign.center,
                                softWrap: false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  AnimatedContainer(
                    height: 100,
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        color: Color(
                            requirePlate == true ? 0xffffffff : 0xffffd1d1),
                        boxShadow: [BoxShadow(color: Colors.grey)]),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                              child: Icon(
                            Icons.directions_car,
                            color: Color(0xffff4141),
                          )),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 7,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Vehicle Plate Number *",
                                      style: detailText,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: TextField(
                                      controller: plateNumber,
                                      decoration: InputDecoration.collapsed(
                                          hintText:
                                              "Enter the vehicle's plate number"),
                                      style: subText,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    height: 100,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.grey)]),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                              child: Icon(
                            Icons.format_list_numbered,
                            color: Color(0xffff4141),
                          )),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 7,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Reference Number",
                                      style: detailText,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: TextField(
                                      controller: refNumber,
                                      decoration: InputDecoration.collapsed(
                                          hintText:
                                              "Any number to identify the vehicle"),
                                      style: subText,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                              ],
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
          InkWell(
            onTap: () {
              if (plateNumber.text == "") {
                setState(() {
                  requirePlate = false;
                });
                return;
              }

              _scrollController.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
              carData.addAll({"plateNumber": plateNumber.text});
            },
            child: Container(
              height: 65,
              alignment: Alignment.center,
              color: Color(0xffFBFF95),
              child: Text(
                "NEXT",
                style: nextText,
              ),
            ),
          ),
        ],
      ),
    );

    Widget secondPage = Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            color: Color(0xffff4141),
            alignment: Alignment.center,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 50,
                  color: Color(0xffff4141),
                  child: Text(
                    "Ad Details",
                    style: createText,
                  ),
                  alignment: Alignment.center,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _listController.animateToPage(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      });
                    },
                    child: Icon(
                      Icons.expand_more,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Color(0xffe5e5e5),
            height: 45,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Progress",
                          style: subText,
                        ),
                        Text(
                          progress.toString() + "/8",
                          style: subText,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.topCenter,
                    child: Row(children: List.generate(8, a)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xfff2f2f2),
              child: ListView(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: 130,
                    padding: EdgeInsets.only(top: 15),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  color: Color(0xffff4141),
                                  height: 35,
                                  child: Text(
                                    "Used",
                                    style: whiteText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "Vehicle Plate Number / Reference Number",
                                    style: subText,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    refNumber.text == ""
                                        ? plateNumber.text
                                        : plateNumber.text +
                                            "/" +
                                            refNumber.text,
                                    style: detailText,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    height: images.length > 0 ? 180 * 0.75 : 0,
                    color: Colors.white,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                            images.length > 0 ? images.length : 0, (index) {
                          return Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 180 * 0.75,
                            width: 180,
                            child: Image.file(
                              images[index],
                              fit: BoxFit.cover,
                              height: 180 * 0.75,
                            ),
                          );
                        })),
                  ),
                  InkWell(
                    onTap: imageSelect,
                    child: Container(
                      color: Color(0xfff2f2f2),
                      height: 70,
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: DottedBorder(
                              color: Color(0xffff4141),
                              strokeWidth: 1,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            child: Icon(
                                              Icons.camera_enhance,
                                              color: Color(0xffff4141),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              "Add car photo",
                                              style: redText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  InkWell(
                    onTap: () async {
                      final data = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return vehicle_detail();
                      }));
                      setState(() {
                        carData.addAll(data);
                      });
                      if (!p2) {
                        setState(() {
                          p2 = true;
                          progress += 1;
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      alignment: Alignment.center,
                      height: 60,
                      decoration: BoxDecoration(
                        color: p2 == true ? Color(0xffD9FFDB) : Colors.white,
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xfff2f2f2), width: 1.5),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          (Icons.directions_car),
                          size: 22,
                          color: Color(0xffff4141),
                        ),
                        title: Text(
                          "Vehicle Details",
                          style: subText,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final data = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return location_page();
                      }));
                      setState(() {
                        Map<String, String> a = Map<String, String>();
                        a["location"] = data;
                        carData.addAll(a);
                      });
                      if (!p3) {
                        p3 = true;
                        progress += 1;
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      alignment: Alignment.center,
                      height: 60,
                      decoration: BoxDecoration(
                        color: p3 == true ? Color(0xffD9FFDB) : Colors.white,
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xfff2f2f2), width: 1.5),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          (Icons.location_on),
                          size: 22,
                          color: Color(0xffff4141),
                        ),
                        title: Text(
                          "Location",
                          style: subText,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final data = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return regis_page();
                          },
                        ),
                      );
                      setState(() {
                        Map<String, String> a = Map<String, String>();
                        a["regis_year"] = data;
                        carData.addAll(a);
                      });
                      if (!p4) {
                        p4 = true;
                        progress += 1;
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      alignment: Alignment.center,
                      height: 60,
                      decoration: BoxDecoration(
                        color: p4 == true ? Color(0xffD9FFDB) : Colors.white,
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xfff2f2f2), width: 1.5),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          (Icons.calendar_today),
                          size: 21,
                          color: Color(0xffff4141),
                        ),
                        title: Text(
                          "Registration Year",
                          style: subText,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    alignment: Alignment.center,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      border: Border(
                        bottom:
                            BorderSide(color: Color(0xfff2f2f2), width: 1.5),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Icon(
                              Icons.update,
                              color: Color(0xffff41414),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(flex: 1, child: Container()),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Text(
                                        "Mileage",
                                        style: subText,
                                      ),
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: TextField(
                                        controller: _mileage,
                                        onChanged: (key) {
                                          if (key == "") {
                                            setState(() {
                                              p5 = false;
                                              progress -= 1;
                                            });
                                          } else if (key != "") {
                                            setState(() {
                                              Map<String, String> string =
                                                  Map<String, String>();
                                              string["mileage"] = _mileage.text;
                                              carData.addAll(string);
                                            });
                                            if (!p5) {
                                              setState(() {
                                                p5 = true;
                                                progress += 1;
                                              });
                                            }
                                          }
                                        },
                                        style: subText,
                                        decoration: InputDecoration.collapsed(
                                            hintText: "Enter the mileage"),
                                      ),
                                    )),
                                Expanded(flex: 1, child: Container()),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text(
                              "KM",
                              style: detailText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    alignment: Alignment.center,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      border: Border(
                        bottom:
                            BorderSide(color: Color(0xfff2f2f2), width: 1.5),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Icon(
                              Icons.monetization_on,
                              color: Color(0xffff41414),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(flex: 1, child: Container()),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Text(
                                        "Price",
                                        style: subText,
                                      ),
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: TextField(
                                        controller: _price,
                                        onChanged: (key) {
                                          if (key == "") {
                                            setState(() {
                                              p6 = false;
                                              progress -= 1;
                                            });
                                          } else if (key != "") {
                                            setState(() {
                                              Map<String, String> string =
                                                  Map<String, String>();
                                              string["price"] = _price.text;
                                              carData.addAll(string);
                                            });
                                            if (!p6) {
                                              setState(() {
                                                p6 = true;
                                                progress += 1;
                                              });
                                            }
                                          }
                                        },
                                        style: subText,
                                        decoration: InputDecoration.collapsed(
                                            hintText: "Enter the price"),
                                      ),
                                    )),
                                Expanded(flex: 1, child: Container()),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text(
                              "Bath",
                              style: detailText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final data = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ad_page(_text);
                      }));
                      setState(() {
                        _text = data;
                        Map<String, String> string = Map<String, String>();
                        string["ad_description"] = _text;
                        carData.addAll(string);
                      });
                      if (!p7) {
                        p7 = true;
                        progress += 1;
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xfff2f2f2), width: 1.5),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Icon(
                                Icons.text_fields,
                                color: Color(0xffff41414),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(flex: 1, child: Container()),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text(
                                          "Ad Description",
                                          style: subText,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: TextField(
                                          enabled: false,
                                          style: subText,
                                          decoration: InputDecoration.collapsed(
                                              hintText: _text),
                                        ),
                                      )),
                                  Expanded(flex: 1, child: Container()),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 61,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      selectColor["name"] != "All" &&
                                              selectColor["name"] != "Other"
                                          ? Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color:
                                                    Color(selectColor["color"]),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(100),
                                                ),
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),
                                            )
                                          : selectColor["name"] == "All"
                                              ? Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(100),
                                                      ),
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/icons/color.png"))),
                                                )
                                              : Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(100),
                                                      ),
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/icons/no-color.png"))),
                                                )
                                    ],
                                  ),
                                ),
                                Container(
                                    child: Text(
                                  selectColor["name"],
                                  style: subText,
                                )),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: List.generate(
                                colors.length,
                                (index) {
                                  return Column(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          Map<String, String> a =
                                              Map<String, String>();
                                          setState(() {
                                            selectColor["name"] =
                                                colors[index]["name"];
                                            selectColor["color"] =
                                                colors[index]["color"];
                                            a["color"] = selectColor["name"];
                                            carData.addAll(a);
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 40),
                                          height: 40,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              colors[index]["name"] !=
                                                          "Other" &&
                                                      colors[index]["name"] !=
                                                          "All"
                                                  ? Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                            colors[index]
                                                                ["color"]),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(100),
                                                        ),
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                      ),
                                                    )
                                                  : colors[index]["name"] ==
                                                          "All"
                                                      ? Container(
                                                          height: 30,
                                                          width: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            100),
                                                                  ),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey),
                                                                  image: DecorationImage(
                                                                      image: AssetImage(
                                                                          "assets/icons/color.png"))),
                                                        )
                                                      : Container(
                                                          height: 30,
                                                          width: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            100),
                                                                  ),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey),
                                                                  image: DecorationImage(
                                                                      image: AssetImage(
                                                                          "assets/icons/no-color.png"),
                                                                      fit: BoxFit
                                                                          .cover)),
                                                        )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(right: 40),
                                          child: Text(
                                            colors[index]["name"],
                                            style: subText,
                                          )),
                                    ],
                                  );
                                },
                              ),
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
                    onTap: () async {
                      final data = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return contact_page();
                          },
                        ),
                      );
                      if (data != null) {
                        if (!p8) {
                          p8 = true;
                          progress += 1;
                        }
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xfff2f2f2), width: 1.5),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Icon(
                                Icons.perm_contact_calendar,
                                color: Color(0xffff41414),
                                size: 22,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(flex: 1, child: Container()),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "Contact Information",
                                          style: subText,
                                        ),
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Text(displayName == null ? "Loading ..." : displayName,
                                        style: nameText,
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 1, child: Container()),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                                child: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              bool com = await checkData();
              if (com) {
                await getCarData().then((e) {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => main_page()));
                });
              }
            },
            child: Container(
              height: 65,
              alignment: Alignment.center,
              color: Color(0xffFBFF95),
              child: Text(
                "PUBLISH",
                style: nextText,
              ),
            ),
          ),
        ],
      ),
    );

    Widget listCar = Container(
        child: PageView(
      controller: _listController,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(
//            padding: EdgeInsets.only(bottom: 20),
          height: _height,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 50,
                            color: Color(0xffff4141),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 5, bottom: 5),
                                    child:
                                        Image.asset("assets/icons/logo2.png"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Container(
                        child: ListView(
                          children: List.generate(
                            postData == null ? 0 : postData.length + 1,
                            (index) {
                              return GestureDetector(
                                onLongPress: () {
                                  deleteAlert(postData[index]);
                                },
                                child: index < postData.length
                                    ? Container(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15, top: 15),
                                        margin: EdgeInsets.only(bottom: 1.5),
                                        height: _width * 0.75 + 75,
                                        color: Colors.white,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black,
                                                    blurRadius: 1)
                                              ]),
                                          width: _width,
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return post_detail(
                                                          postData[index]);
                                                    }));
                                                  },
                                                  child: Container(
                                                      child: Stack(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    children: <Widget>[
                                                      PageView(
                                                          children: List.generate(
                                                              postData == null
                                                                  ? 0
                                                                  : postData[index]
                                                                          .data[
                                                                      "size"],
                                                              (i) {
                                                        return Container(
                                                          child: _images == null
                                                              ? Image.asset(
                                                                  "assets/icons/loading.gif",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : _images[index]
                                                                          [i] ==
                                                                      null
                                                                  ? Text(
                                                                      "No images found.",
                                                                      style:
                                                                          detailText,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    )
                                                                  : Image
                                                                      .network(
                                                                      _images[index]
                                                                          [i],
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                        );
                                                      })),
                                                      Container(
                                                        height: 35,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        color: Colors.black26,
                                                        child: Text(
                                                          postData == null
                                                              ? "Loading ..."
                                                              : toMoney(postData[
                                                                              index]
                                                                          .data[
                                                                      "price"]) +
                                                                  " บาท",
                                                          style: whiteText,
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return post_detail(
                                                        postData[index]);
                                                  }));
                                                },
                                                child: Container(
                                                  height: 50,
                                                  padding: EdgeInsets.only(
                                                      top: 3, bottom: 3),
                                                  color: Colors.white,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 10,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  postData ==
                                                                          null
                                                                      ? "Loading ..."
                                                                      : postData[index].data["year"] +
                                                                          " " +
                                                                          postData[index].data[
                                                                              "band"] +
                                                                          " " +
                                                                          postData[index].data[
                                                                              "gene"] +
                                                                          " " +
                                                                          postData[index]
                                                                              .data["geneDetail"],
                                                                  style:
                                                                      nameText,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 5,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 10),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  child: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(2),
                                                                          child:
                                                                              Image.asset(
                                                                            "assets/icons/speed.png",
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            7,
                                                                      ),
                                                                      Expanded(
                                                                        flex: 4,
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Text(
                                                                            postData == null
                                                                                ? "Loading ..."
                                                                                : postData[index].data["mileage"] + " " + "KM",
                                                                            style:
                                                                                subText,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  child: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(1.6),
                                                                          child:
                                                                              Image.asset(
                                                                            "assets/icons/gear.png",
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            7,
                                                                      ),
                                                                      Expanded(
                                                                        flex: 4,
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Text(
                                                                            postData == null
                                                                                ? "Loading ..."
                                                                                : postData[index].data["gearType"],
                                                                            style:
                                                                                subText,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        top: BorderSide(
                                                            color: Color(
                                                                0xffE5E5E5)))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.phone,
                                                      size: 22,
                                                      color: Color(0xffff4141),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Contact",
                                                      style: contactText,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15, top: 15),
                                        margin: EdgeInsets.only(bottom: 15),
                                        height: 70,
                                        child: Text(
                                          "To post more than 3 Ad\nContact Us",
                                          style: subText,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _listController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        });
                      },
                      child: Container(
                        height: 65,
                        color: Color(0xffff4141),
                        alignment: Alignment.center,
                        child: Text(
                          "Create Ad",
                          style: createText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          color: Colors.white,
          height: _height,
          curve: Curves.easeIn,
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _scrollController,
            children: <Widget>[firstPage, secondPage],
          ),
        ),
      ],
    ));

    // TODO: implement build
    return Container(
      color: Color(0xffff4141),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints cons) {
            return Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        height: _height,
                        alignment: Alignment.center,
                        color: Colors.white,
                        child: postData == null
                            ? Text(
                                "Loading ...",
                              )
                            : postData.length == 0
                                ? PageView(
                                    controller: _listController,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Container(
                                                        height: 50,
                                                        color:
                                                            Color(0xffff4141),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 5,
                                                                        bottom:
                                                                            5),
                                                                child: Image.asset(
                                                                    "assets/icons/logo2.png"),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(),
                                                      ),
                                                      Expanded(
                                                        flex: 5,
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 40,
                                                                  bottom: 20),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 20),
                                                          child: Image.asset(
                                                              "assets/icons/contract.png"),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          child: Text(
                                                            "Sell your car\nCreate your ad for free",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: detailText,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _listController.nextPage(
                                                                        duration: Duration(
                                                                            milliseconds:
                                                                                500),
                                                                        curve: Curves
                                                                            .easeInOut);
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      color: Color(
                                                                          0xffff4141),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(4))),
                                                                  child: Text(
                                                                    "Create Ad",
                                                                    style:
                                                                        createText,
                                                                  ),
                                                                  height: 40,
                                                                  width: 165,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Text(
                                                                "To post more than 3 Ad\nContact Us",
                                                                style: subText,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        color: Colors.white,
                                        curve: Curves.easeIn,
                                        child: PageView(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          controller: _scrollController,
                                          children: <Widget>[
                                            firstPage,
                                            secondPage
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : listCar),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
