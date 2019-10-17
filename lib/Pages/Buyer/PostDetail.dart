import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'DealerDetail.dart';

class post_detail extends StatefulWidget {
  DocumentSnapshot queryData;

  post_detail(this.queryData);

  _post_detail createState() => _post_detail(this.queryData);
}

class _post_detail extends State<post_detail> with TickerProviderStateMixin {
  DocumentSnapshot queryData;
  bool isAdmin = false;

  _post_detail(this.queryData);

  final Firestore _db = Firestore.instance;
  List<String> _images = [];
  String dealer_images;
  DocumentSnapshot dealerData;
  int carColor;

  TextStyle topbarText =
      TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle detailText = TextStyle(
      color: Color(0xff434343), fontSize: 16, fontWeight: FontWeight.bold);

  TextStyle priceText = TextStyle(
      color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);

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
  List<TextEditingController> _inputs = new List();
  List<FocusNode> _taps = new List();

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

  Future getData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user.uid == "zfSe7CpfZccnv1WOfvdeXuWq6Sh2") {
      setState(() {
        isAdmin = true;
      });
    }
    int size = queryData.data["size"];
    final StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("passport_photo")
        .child(queryData.data["uid"]);
    String data;
    data = await storageReference.getDownloadURL().catchError((e) {
      return null;
    });
    final DocumentSnapshot documentSnapshot =
        await _db.collection("buyer").document(queryData.data["uid"]).get();
    setState(() {
      dealerData = documentSnapshot;
      dealer_images = data;
    });
    for (int i = 0; i < size; i++) {
      String storageReference = await FirebaseStorage.instance
          .ref()
          .child("post_photo")
          .child(queryData.documentID)
          .child(i.toString())
          .getDownloadURL();
      setState(() {
        _images.add(storageReference);
      });
    }
    String tmp = queryData.data["color"];
    for (int i = 0; i < colors.length; i++) {
      if (tmp == colors[i]["name"]) {
        carColor = colors[i]["color"];
        break;
      }
    }
  }

  var myuser;
  bool isLoading = false;
  TextEditingController headerText = TextEditingController();
  FocusNode headerFocus = FocusNode();

  Future getUserData() async {
    var json = {};
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot data =
        await _db.collection("seller").document(user.uid).get();

    String url = await FirebaseStorage.instance
        .ref()
        .child("user_photo")
        .child(data.documentID)
        .getDownloadURL();

    json["uid"] = data.documentID;
    json["firstname"] = data.data["firstname"];
    json["lastname"] = data.data["lastname"];
    json["image"] = url;
    setState(() {
      myuser = json;
    });
  }

  Future saveToFav()async{
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    bool isHas = false;
    
    await _db.collection('favor').where('uid', isEqualTo: user.uid).where('post', isEqualTo: queryData.documentID).getDocuments().then((docs){
      docs.documents.forEach((data){
        isHas = true;
      });
    });
    
    if(isHas){
      alertDialog('Already Added.');
    }else{
      await _db.collection('favor').add({
        'uid': user.uid,
        'post': queryData.documentID
      });
      alertDialog('Added to Your Favor Cars.');
    }
  }

  Future<String> getProfileImage(String uid) async {
    String url = await FirebaseStorage.instance
        .ref()
        .child("user_photo")
        .child(uid)
        .getDownloadURL();
    return url;
  }

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

  Future onClick() async {
    String id = "";
    await _db
        .collection("clicks")
        .where("post", isEqualTo: queryData.documentID)
        .getDocuments()
        .then((docs) {
      docs.documents.forEach((data) {
        id = data.documentID;
      });
    });
    DocumentSnapshot data = await _db.collection("clicks").document(id).get();
    int clicks = data.data["clicks"];
    await _db
        .collection("clicks")
        .document(id)
        .updateData({"clicks": ++clicks});

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();

    DocumentSnapshot ageData =
        await _db.collection("seller").document(user.uid).get();
    await _db
        .collection("age_clicks")
        .add({"age": ageData.data["age"], "post": queryData.documentID});

    await _db
        .collection("brand_clicks")
        .where("brand", isEqualTo: queryData.data["band"])
        .getDocuments()
        .then((docs) {
      docs.documents.forEach((data) {
        clicks = data.data["clicks"];
        id = data.documentID;
      });
    });
    await _db
        .collection("brand_clicks")
        .document(id)
        .updateData({"clicks": ++clicks});
  }

  List<DocumentSnapshot> headerComment;
  List<String> headerImages;
  List<DocumentSnapshot> headerDetail;
  List<List<DocumentSnapshot>> subComment;
  var subImages;
  List<List<DocumentSnapshot>> subDetail;

  getBlogDetail() async {
    setState(() {
      isLoading = true;
    });

    List<DocumentSnapshot> hdata = List<DocumentSnapshot>();
    List<DocumentSnapshot> hdetail = List<DocumentSnapshot>();
    List<String> himg = List<String>();
    var hsetImg = {};
    List<DocumentSnapshot> ldetail = List<DocumentSnapshot>();
    List<String> limg = List<String>();
    var lsetImg = {};
    await _db
        .collection("headerComment")
        .orderBy("date")
        .where("post", isEqualTo: queryData.documentID)
        .getDocuments()
        .then((docs) {
      hdata = docs.documents;
    });

    for (int i = 0; i < hdata.length; i++) {
      String tmp = await getProfileImage(hdata[i].data["uid"]);
      DocumentSnapshot tmp2 =
          await _db.collection("seller").document(hdata[i].data["uid"]).get();
      himg.add(tmp);
      hdetail.add(tmp2);
    }

    List<List<DocumentSnapshot>> detailData = List<List<DocumentSnapshot>>();
    List<List<DocumentSnapshot>> finalData = List<List<DocumentSnapshot>>();
    for (int i = 0; i < hdata.length; i++) {
      await _db
          .collection("subComment")
          .orderBy("date")
          .where("headerID", isEqualTo: hdata[i].documentID)
          .where("post", isEqualTo: queryData.documentID)
          .getDocuments()
          .then((docs) {
        finalData.add(docs.documents);
      });
    }

    for (int i = 0; i < finalData.length; i++) {
      for (int j = 0; j < finalData[i].length; j++) {
        String tmp = await getProfileImage(finalData[i][j].data["uid"]);
        DocumentSnapshot tmp2 = await _db
            .collection("seller")
            .document(finalData[i][j].data["uid"])
            .get();
        lsetImg[finalData[i][j]["uid"]] = tmp;
        ldetail.add(tmp2);
      }
      detailData.add(ldetail);
    }

    setState(() {
      headerComment = hdata;
      headerImages = himg;
      headerDetail = hdetail;
    });

    setState(() {
      subComment = finalData;
      subImages = lsetImg;
      subDetail = detailData;
      isLoading = false;
    });
  }

  Future toComment(String headerId, String uid, String text) async {
    setState(() {
      keyBoardExpand = false;
    });
    await _db.collection("subComment").add({
      "date": new DateTime.now().toUtc(),
      "headerID": headerId,
      "post": queryData.documentID,
      "text": text,
      "uid": uid
    });
  }

  Future toHeader(String text, String uid) async {
    setState(() {
      keyBoardExpand = false;
    });
    await _db.collection("headerComment").add({
      "date": new DateTime.now().toUtc(),
      "post": queryData.documentID,
      "text": text,
      "uid": uid
    });
  }

  alertDialog(String head){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(head),
            actions: <Widget>[
              FlatButton(
                  child: Text('Ok'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  }
              ),
            ],
          );
        }
    );
  }

  void test() {
    _db.collection("subComment").getDocuments().then((docs) {
      _db
          .collection("subComment")
          .document(docs.documents[0].documentID)
          .updateData({"date": DateTime.now().toUtc()});
    });
  }

  bool contactExpand = false;
  bool keyBoardExpand = false;
  AnimationController _loadingAnimate;

  @override
  void initState() {
    _loadingAnimate =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    _loadingAnimate.repeat();
    _loadingAnimate.addListener(() {
      if (_loadingAnimate.status == AnimationStatus.completed) {
        print("Yes");
      }
    });
    // TODO: implement initState
    super.initState();
    getData();
    onClick();
    getBlogDetail();
    getUserData();
  }

  @override
  void dispose() {
    _loadingAnimate.dispose();
    super.dispose();
  }

  int section1 = 0;
  int section2 = 0;
  ScrollController _scrollController = ScrollController();

  void toPosition(TapDownDetails details) {
    double _y = details.globalPosition.dy;
    double _height = (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top) -
        (kBottomNavigationBarHeight + 60);
    double _mid = _height / 2;
    double _space = _y - _mid;
    double _currentPosition = _scrollController.position.pixels;
    print(_currentPosition);
    print(_space);
    setState(() {
      _scrollController.animateTo((_currentPosition + (_space)),
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    Future deletePost(DocumentSnapshot postData) async {
      await _db
          .collection("age_clicks")
          .where("post", isEqualTo: postData.documentID)
          .getDocuments()
          .then((docs) {
        docs.documents.forEach((data) {
          _db.runTransaction((Transaction myTran) async {
            await myTran.delete(data.reference);
          });
        });
      });

      await _db
          .collection("clicks")
          .where("post", isEqualTo: postData.documentID)
          .getDocuments()
          .then((docs) {
        docs.documents.forEach((data) {
          _db.runTransaction((Transaction myTran) async {
            await myTran.delete(data.reference);
          });
        });
      });

      await _db
          .collection("headerComment")
          .where("post", isEqualTo: postData.documentID)
          .getDocuments()
          .then((docs) {
        docs.documents.forEach((data) {
          _db.runTransaction((Transaction myTran) async {
            await myTran.delete(data.reference);
          });
        });
      });

      await _db
          .collection("subComment")
          .where("post", isEqualTo: postData.documentID)
          .getDocuments()
          .then((docs) {
        docs.documents.forEach((data) {
          _db.runTransaction((Transaction myTran) async {
            await myTran.delete(data.reference);
          });
        });
      });

      await _db.runTransaction((Transaction myTran) async {
        DocumentReference ref =
            _db.collection("post").document(postData.documentID);
        await myTran.delete(ref);
      });
    }

    deleteAlert(DocumentSnapshot postData) {
      showDialog(
          context: context,
          builder: (context) {
            return isAdmin
                ? AlertDialog(
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
                          deletePost(postData).then((e) async {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text("Confirm"),
                      ),
                    ],
                  )
                : AlertDialog(
                    title: Text("You are not admin"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
          });
    }

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
        color: Color(0xffff4141),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  keyBoardExpand = false;
                });
                FocusScope.of(context).unfocus();
                print("hi");
              },
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: _height,
                      color: Color(0xffe5e5e5),
                      child: Column(
                        children: <Widget>[
                          Container(
                              height: MediaQuery.of(context).padding.top,
                              color: Color(0xffff4141)),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            color: Color(0xffff4141),
                            child: Stack(
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
                                                padding: EdgeInsets.only(
                                                    top: 5, bottom: 5),
                                                child: Image.asset(
                                                    "assets/icons/logo2.png"),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      size: 20,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    child: Icon(
                                      Icons.dehaze,
                                      size: 20,
                                    ),
                                    onTap: () {
                                      deleteAlert(queryData);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: ListView(
                                controller: _scrollController,
                                padding: EdgeInsets.zero,
                                children: <Widget>[
                                  Container(
                                    width: _width,
                                    height: _width * 0.75,
                                    color: Colors.grey,
                                    child: PageView(
                                      children: List.generate(
                                          _images.length > 0
                                              ? _images.length
                                              : 0, (index) {
                                        return Container(
                                          child: _images.length > 0
                                              ? Image.network(
                                                  _images[index],
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  "assets/icons/loading.gif",
                                                  fit: BoxFit.cover,
                                                ),
                                        );
                                      }),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    height: 60,
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Color(0xffe5e5e5)))),
                                    child: Text(
                                      queryData.data["year"] +
                                          " " +
                                          queryData.data["band"] +
                                          " " +
                                          queryData.data["gene"] +
                                          " " +
                                          queryData.data["geneDetail"] +
                                          " " +
                                          queryData.data["color"],
                                      style: detailText,
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    padding: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 15,
                                        bottom: 15),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Color(0xffe5e5e5)))),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            child: Text(
                                                toMoney(queryData
                                                        .data["price"]) +
                                                    " Baht",
                                                style: priceText),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            saveToFav();
                                          },
                                          child: Container(
                                            child: Row(children: <Widget>[
                                              Container(
                                                width: 60,
                                                child: Icon(Icons.favorite,color: Color(0xffff4141),size: 25),
                                              ),
                                              Container(
                                                width: 60,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        left: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                child: Image.asset(
                                                  "assets/icons/calculator.png",
                                                  height: 19,
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 55,
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Detail",
                                      style: detailText,
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                  left: BorderSide(
                                                      color:
                                                          Color(0xffe5e5e5))),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      top: 10,
                                                      bottom: 10),
                                                  width: 60,
                                                  child: Icon(
                                                    Icons.calendar_today,
                                                    size: 20,
                                                    color: Color(0xffff4141),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      queryData.data["year"],
                                                      style: subText,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                  left: BorderSide(
                                                      color:
                                                          Color(0xffe5e5e5))),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      top: 10,
                                                      bottom: 10),
                                                  width: 60,
                                                  child: Image.asset(
                                                    "assets/icons/speed.png",
                                                    height: 20,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      queryData
                                                              .data["mileage"] +
                                                          " " +
                                                          "KM",
                                                      style: subText,
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
                                  Container(
                                    height: 50,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                  left: BorderSide(
                                                      color:
                                                          Color(0xffe5e5e5))),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      top: 10,
                                                      bottom: 10),
                                                  width: 60,
                                                  child: Icon(
                                                    Icons.location_on,
                                                    size: 20,
                                                    color: Color(0xffff4141),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      queryData
                                                          .data["location"],
                                                      style: subText,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                  left: BorderSide(
                                                      color:
                                                          Color(0xffe5e5e5))),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        left: 15,
                                                        right: 15,
                                                        top: 10,
                                                        bottom: 10),
                                                    width: 60,
                                                    child: Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width: 25,
                                                          height: 25,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey),
                                                              color: Color(
                                                                  carColor ==
                                                                          null
                                                                      ? 0xffffff
                                                                      : carColor),
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius.circular(
                                                                          100))),
                                                        ),
                                                      ],
                                                    )),
                                                Expanded(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      queryData.data["color"],
                                                      style: subText,
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
                                  Container(
                                    height: 50,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                  left: BorderSide(
                                                      color:
                                                          Color(0xffe5e5e5))),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        left: 15,
                                                        right: 15,
                                                        top: 10,
                                                        bottom: 10),
                                                    width: 60,
                                                    child: Image.asset(
                                                      "assets/icons/gear.png",
                                                      height: 21,
                                                    )),
                                                Expanded(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      queryData
                                                          .data["gearType"],
                                                      style: subText,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                  left: BorderSide(
                                                      color:
                                                          Color(0xffe5e5e5))),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      top: 10,
                                                      bottom: 10),
                                                  width: 60,
                                                  child: Icon(
                                                    Icons.directions_car,
                                                    color: Color(0xffff4141),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Used",
                                                      style: subText,
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
                                  Container(
                                    height: 55,
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Seller's Comments",
                                      style: detailText,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.all(15),
                                    alignment: Alignment.centerLeft,
                                    child:
                                        Text(queryData.data["ad_description"]),
                                  ),
                                  Container(
                                    height: 55,
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Equipments",
                                      style: detailText,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                section1 = 0;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border(
                                                      right: BorderSide(
                                                          color: Color(
                                                              0xffe5e5e5)))),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Safety",
                                                style: detailText,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                section1 = 1;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border(
                                                      right: BorderSide(
                                                          color: Color(
                                                              0xffe5e5e5)))),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Lighting",
                                                style: detailText,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                section1 = 2;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Entertainment",
                                                style: detailText,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: AnimatedAlign(
                                            curve: Curves.easeInOut,
                                            alignment: section1 == 0
                                                ? Alignment.centerLeft
                                                : section1 == 1
                                                    ? Alignment.center
                                                    : Alignment.centerRight,
                                            duration:
                                                Duration(milliseconds: 300),
                                            child: Container(
                                              width: _width / 3,
                                              height: 2,
                                              color: Color(0xffff4141),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    child: Stack(
                                      children: <Widget>[
                                        AnimatedOpacity(
                                          opacity: section1 == 0 ? 1 : 0,
                                          duration: Duration(milliseconds: 300),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10),
                                                height: 70,
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Airbags",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "- " +
                                                            queryData.data[
                                                                "airbags"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10),
                                                height: 70,
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Alarm",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "- " +
                                                            queryData
                                                                .data["alarm"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10),
                                                height: 70,
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Stability Control",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "- " +
                                                            queryData.data[
                                                                "stability"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          opacity: section1 == 1 ? 1 : 0,
                                          duration: Duration(milliseconds: 300),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10),
                                                height: 70,
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Front Lights",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "- " +
                                                            queryData.data[
                                                                "frontLights"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10),
                                                height: 70,
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Brake Lights",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "- " +
                                                            queryData.data[
                                                                "brakeLights"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10),
                                                height: 70,
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Rear Lights",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "- " +
                                                            queryData.data[
                                                                "rearLights"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          opacity: section1 == 2 ? 1 : 0,
                                          duration: Duration(milliseconds: 300),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10),
                                                height: 70,
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Aux",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "- " +
                                                            queryData
                                                                .data["aux"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10),
                                                height: 70,
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Bluetooth",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "- " +
                                                            queryData.data[
                                                                "bluetooth"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 55,
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Specifications",
                                      style: detailText,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                section2 = 0;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border(
                                                      right: BorderSide(
                                                          color: Color(
                                                              0xffe5e5e5)))),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "General",
                                                style: detailText,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                section2 = 1;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border(
                                                      right: BorderSide(
                                                          color: Color(
                                                              0xffe5e5e5)))),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Engine",
                                                style: detailText,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                section2 = 2;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Dimension",
                                                style: detailText,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: AnimatedAlign(
                                            curve: Curves.easeInOut,
                                            alignment: section2 == 0
                                                ? Alignment.centerLeft
                                                : section2 == 1
                                                    ? Alignment.center
                                                    : Alignment.centerRight,
                                            duration:
                                                Duration(milliseconds: 300),
                                            child: Container(
                                              width: _width / 3,
                                              height: 2,
                                              color: Color(0xffff4141),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    child: Stack(
                                      children: <Widget>[
                                        AnimatedOpacity(
                                          opacity: section2 == 0 ? 1 : 0,
                                          duration: Duration(milliseconds: 300),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 20),
                                                height: 70,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Doors",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        queryData.data["doors"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerRight,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 20),
                                                height: 70,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Gear Number",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        queryData.data["gear"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerRight,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 20),
                                                height: 70,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Seat Capacity",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        queryData.data["seat"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerRight,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          opacity: section2 == 1 ? 1 : 0,
                                          duration: Duration(milliseconds: 300),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 20),
                                                height: 70,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Cylinder",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        queryData
                                                            .data["cylinder"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerRight,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 20),
                                                height: 70,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Peak Power",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        queryData
                                                            .data["peakPower"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerRight,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 20),
                                                height: 70,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Engine Type",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        queryData
                                                            .data["engineType"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerRight,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 20),
                                                height: 70,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Fuel Type",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        queryData
                                                            .data["fuelType"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerRight,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          opacity: section2 == 2 ? 1 : 0,
                                          duration: Duration(milliseconds: 300),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 20),
                                                height: 70,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Length (mm)",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        queryData
                                                            .data["length"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerRight,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 20),
                                                height: 70,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Height (mm)",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        queryData
                                                            .data["height"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerRight,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 20),
                                                height: 70,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Width (mm)",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        queryData.data["width"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerRight,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xffe5e5e5)))),
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 20),
                                                height: 70,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        "Weight (KG)",
                                                        style: nameText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      child: Text(
                                                        queryData
                                                            .data["weight"],
                                                        style: subText,
                                                      ),
                                                      alignment:
                                                          Alignment.centerRight,
                                                    )),
                                                  ],
                                                ),
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
                                  Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Color(0xffe5e5e5)))),
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              "Post ID",
                                              style: detailText,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Color(0xffe5e5e5),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6))),
                                            child: Text(
                                              queryData.documentID,
                                              style: subText,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Color(0xffe5e5e5)))),
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              "Update on",
                                              style: detailText,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Color(0xffe5e5e5),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6))),
                                            child: Text(
                                              DateFormat("yyyy-MM-dd")
                                                  .format(queryData.data["date"]
                                                      .toDate())
                                                  .toString(),
                                              style: subText,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                    height: 55,
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Seller",
                                      style: detailText,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  dealer_detail(dealerData)));
                                    },
                                    child: Container(
                                        height: 80,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Color(0xffe5e5e5)))),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: dealer_images ==
                                                    null
                                                ? AssetImage(
                                                    "assets/icons/logo.png")
                                                : NetworkImage(dealer_images),
                                            maxRadius: 25,
                                            backgroundColor: Colors.white,
                                          ),
                                          title: Text(
                                            dealerData == null
                                                ? "Loading ..."
                                                : dealerData.data["passpord"],
                                            style: detailText,
                                          ),
                                          subtitle: Text(
                                            dealerData == null
                                                ? "Loading ..."
                                                : dealerData.data["phone"],
                                            style: subText,
                                          ),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18,
                                          ),
                                        )),
                                  ),
                                  Container(
                                    height: 55,
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Blog",
                                      style: detailText,
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: List.generate(
                                          headerComment == null
                                              ? 0
                                              : headerComment.length, (index) {
                                        return Container(
                                          alignment: Alignment.center,
                                          color: Colors.white,
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      width: 75,
                                                      child: CircleAvatar(
                                                        backgroundImage:
                                                            headerImages == null
                                                                ? AssetImage(
                                                                    "assets/icons/loading.gif")
                                                                : NetworkImage(
                                                                    headerImages[
                                                                        index]),
                                                        maxRadius: 25,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xffe5e5e5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            6))),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                headerDetail ==
                                                                        null
                                                                    ? "Loading ..."
                                                                    : headerDetail[index]
                                                                            [
                                                                            "firstname"] +
                                                                        " " +
                                                                        headerDetail[index]
                                                                            [
                                                                            "lastname"],
                                                                style:
                                                                    detailText,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                headerComment ==
                                                                        null
                                                                    ? "Loading"
                                                                    : headerComment[
                                                                            index]
                                                                        [
                                                                        "text"],
                                                                style: subText,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                                child: Row(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 75,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xffe5e5e5),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          6))),
                                                      child: Text(
                                                        headerComment == null
                                                            ? ""
                                                            : (DateFormat(
                                                                        "yyyy-MM-dd")
                                                                    .format(headerComment[index]
                                                                            [
                                                                            "date"]
                                                                        .toDate()))
                                                                .toString(),
                                                        style: subText,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Column(
                                                    children: List.generate(
                                                        subComment == null
                                                            ? 0
                                                            : (subComment[index]
                                                                    .length) +
                                                                1, (jdex) {
                                                  _inputs.add(
                                                      new TextEditingController());
                                                  _taps.add(new FocusNode());
                                                  return jdex !=
                                                          (subComment[index]
                                                              .length)
                                                      ? Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  bottom: 10,
                                                                  right: 10),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    SizedBox(
                                                                      width: 55,
                                                                    ),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .topCenter,
                                                                      width: 75,
                                                                      child:
                                                                          CircleAvatar(
                                                                        backgroundImage: subImages ==
                                                                                null
                                                                            ? AssetImage("assets/icons/loading.gif")
                                                                            : NetworkImage(subImages[subComment[index][jdex].data["uid"]]),
                                                                        maxRadius:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.all(15),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Color(0xffe5e5e5),
                                                                            borderRadius: BorderRadius.all(Radius.circular(6))),
                                                                        child:
                                                                            Column(
                                                                          children: <
                                                                              Widget>[
                                                                            Container(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text(
                                                                                subDetail == null ? "Loading ..." : subDetail[index][jdex].data["firstname"] + " " + subDetail[index][jdex].data["lastname"],
                                                                                style: detailText,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Container(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text(
                                                                                subComment == null ? "Loading" : subComment[index][jdex].data["text"],
                                                                                style: subText,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    SizedBox(
                                                                      width: 55,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 75,
                                                                    ),
                                                                    Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              3),
                                                                      decoration: BoxDecoration(
                                                                          color: Color(
                                                                              0xffe5e5e5),
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(6))),
                                                                      child:
                                                                          Text(
                                                                        subComment ==
                                                                                null
                                                                            ? ""
                                                                            : (DateFormat("yyyy-MM-dd").format(subComment[index][jdex].data["date"].toDate())).toString(),
                                                                        style:
                                                                            subText,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 10,
                                                                  bottom: 10),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    SizedBox(
                                                                      width: 55,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 75,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          GestureDetector(
                                                                        onTapDown:
                                                                            (details) {
                                                                          setState(
                                                                              () {
                                                                            keyBoardExpand =
                                                                                true;
                                                                          });
                                                                          _taps[index]
                                                                              .requestFocus();
                                                                          toPosition(
                                                                              details);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(8),
                                                                          decoration: BoxDecoration(
                                                                              color: Color(0xffe5e5e5),
                                                                              borderRadius: BorderRadius.all(Radius.circular(6))),
                                                                          child:
                                                                              IgnorePointer(
                                                                            child:
                                                                                TextField(
                                                                              focusNode: _taps[index],
                                                                              controller: _inputs[index],
                                                                              style: subText,
                                                                              maxLines: null,
                                                                              decoration: InputDecoration.collapsed(hintText: "Send your question"),
                                                                            ),
                                                                          ),
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
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: <
                                                                      Widget>[
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        if (_inputs[index].text ==
                                                                            "") {
                                                                          return;
                                                                        }
                                                                        loadingPopup();
                                                                        FocusScope.of(context)
                                                                            .unfocus();
                                                                        await toComment(headerComment[index].documentID, myuser["uid"], _inputs[index].text).then(
                                                                            (err) async {
                                                                          await getBlogDetail();
                                                                        }).then(
                                                                            (e) {
                                                                          _inputs[index]
                                                                              .clear();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            100,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        padding:
                                                                            EdgeInsets.all(8),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Color(0xffff4141),
                                                                            borderRadius: BorderRadius.all(Radius.circular(6))),
                                                                        child:
                                                                            Text(
                                                                          "Comment",
                                                                          style:
                                                                              whiteText,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                })),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 10, bottom: 10, right: 10),
                                    color: Colors.white,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.topCenter,
                                          width: 75,
                                          child: CircleAvatar(
                                            backgroundImage: myuser == null
                                                ? AssetImage(
                                                    "assets/icons/loading.gif")
                                                : NetworkImage(myuser["image"]),
                                            maxRadius: 25,
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                color: Color(0xffe5e5e5),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6))),
                                            child: Column(
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTapDown: (details) {
                                                    print("sus");
                                                  },
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      myuser == null
                                                          ? "Something"
                                                          : myuser[
                                                                  "firstname"] +
                                                              " " +
                                                              myuser[
                                                                  "lastname"],
                                                      style: detailText,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                GestureDetector(
                                                  onTapDown: (details) {
                                                    setState(() {
                                                      keyBoardExpand = true;
                                                    });
                                                    headerFocus.requestFocus();
                                                    toPosition(details);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffe5e5e5),
                                                    ),
                                                    child: IgnorePointer(
                                                      child: TextField(
                                                        focusNode: headerFocus,
                                                        controller: headerText,
                                                        style: subText,
                                                        maxLines: null,
                                                        decoration: InputDecoration
                                                            .collapsed(
                                                                hintText:
                                                                    "Send your question"),
                                                      ),
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
                                  Container(
                                    padding:
                                        EdgeInsets.only(right: 10, bottom: 10),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () async {
                                            if (headerText.text == "") {
                                              return;
                                            }
                                            loadingPopup();
                                            FocusScope.of(context).unfocus();
                                            await toHeader(headerText.text,
                                                    myuser["uid"])
                                                .then((err) async {
                                              await getBlogDetail();
                                            }).then((e) {
                                              headerText.clear();
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: Container(
                                            width: 100,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Color(0xffff4141),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6))),
                                            child: Text(
                                              "Comment",
                                              style: whiteText,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: keyBoardExpand == false
                                        ? 25
                                        : ((_height / 2) -
                                            MediaQuery.of(context).padding.top -
                                            kBottomNavigationBarHeight +
                                            10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                contactExpand = true;
                              });
                            },
                            child: Container(
                              height: kBottomNavigationBarHeight + 10,
                              color: Color(0xffFBFF95),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.phone),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Contact",
                                    style: nextText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      margin: EdgeInsets.only(
                          top: contactExpand == true ? 0 : _height),
                      height: _height,
                      color: Color(0xffe5e5e5),
                      child: Column(children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).padding.top,
                          color: Color(0xffff4141),
                        ),
                        Stack(
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
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child: Text("Contact Seller",
                                                style: topbarText),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 20,
                                ),
                                onTap: () {
                                  setState(() {
                                    contactExpand = false;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 70,
                          color: Colors.white,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      dealerData == null
                                          ? ""
                                          : dealerData.data["firstName"] +
                                              " " +
                                              dealerData.data["lastName"],
                                      style: detailText),
                                ),
                              ]),
                        ),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          height: 70,
                          color: Colors.white,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Icon(Icons.call,
                                                size: 22,
                                                color: Color(0xffff4141))),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                            child: Text(
                                                dealerData == null
                                                    ? ""
                                                    : dealerData.data["phone"],
                                                style: detailText)),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          child: Column(children: <Widget>[
                                            InkWell(
                                              onTap: () async {

                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      color: Colors.yellow,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  child: Text("Call now",
                                                      style: detailText)),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ]),
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
