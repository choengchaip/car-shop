import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sa_project/LoadingProgress.dart';
import 'PostDetail.dart';

class post_page extends StatefulWidget {
  Query topText;

  post_page(this.topText);

  _post_page createState() => _post_page(this.topText);
}

class _post_page extends State<post_page> with TickerProviderStateMixin{
  Query _query;
  _post_page(this._query);
  final Firestore _db = Firestore.instance;
  List<DocumentSnapshot> postData;
  var _images;
  bool isAdmin = false;
  bool isFinish = false;
  AnimationController _loadingAnimate;
  LoadingProgress loadingProgress;
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

  Future getPostData()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if(user.uid == "zfSe7CpfZccnv1WOfvdeXuWq6Sh2"){
      setState(() {
        isAdmin = true;
      });
    }
    _query.getDocuments().then((docs){
      setState(() {
        postData = null;
        postData = docs.documents;
        getCarImages();
      });
    });
  }
  
  String toMoney(String money) {
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

  getCarImages() async {
    List<List<String>> img = [];
    final StorageReference storageRef =
    FirebaseStorage.instance.ref().child("post_photo");
    setState(() {
      loadingProgress.setProgress(0);
      loadingProgress.setProgressText('Starting Load Post Images');
    });
    int a = 0;
    for (int i = 0; i < postData.length; i++) {
      List<String> tmp = [];
      for (int j = 0; j < postData[i].data["size"]; j++) {
        a++;
      }
    }
    int b = 1;
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
        b++;
        setState(() {
          loadingProgress.setProgress((b * 200) / 58);
          loadingProgress.setProgressText('Load Post Images ${b}/${a}');
        });
      }
      img.add(tmp);
    }
    setState(() {
      _images = img;
      isFinish = true;
    });
  }

  @override
  void initState() {
    _loadingAnimate = AnimationController(vsync: this,duration: Duration(seconds: 10));
    _loadingAnimate.repeat();
    _loadingAnimate.addListener((){});
    loadingProgress = LoadingProgress(_loadingAnimate);
    // TODO: implement initState
    isFinish = false;
    super.initState();
    getPostData();
  }

  @override
  void dispose(){
    _loadingAnimate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

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

    deleteAlert(DocumentSnapshot postData) {
      showDialog(
          context: context,
          builder: (context) {
            return isAdmin ? AlertDialog(
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
                      setState(() {
                        getPostData();
                      });
                    });
                  },
                  child: Text("Confirm"),
                ),
              ],
            ):AlertDialog(
              title: Text("You are not admin"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    return !isFinish ? loadingProgress.getWidget(context) : Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffff4141),
        title: Text("Searched"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: postData != null ? postData.length == 0 ? Text("No Result.",style: detailText,) : ListView(
                  children: List.generate(
                    postData == null ? 0 : postData.length + 1,
                        (index) {
                      return GestureDetector(
                        onLongPress: (){
                          deleteAlert(postData[index]);
                        },
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return post_detail(postData[index]);
                          }));
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
                                      color: Colors.black, blurRadius: 1)
                                ]),
                            width: _width,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: <Widget>[
                                          PageView(
                                              children: List.generate(
                                                  postData == null
                                                      ? 0
                                                      : postData[index]
                                                      .data["size"], (i) {
                                                return Container(
                                                  child: _images == null
                                                      ? Image.asset(
                                                    "assets/icons/loading.gif",
                                                    fit: BoxFit.cover,
                                                  )
                                                      : _images[index][i] == null
                                                      ? Text(
                                                    "No images found.",
                                                    style: detailText,
                                                    textAlign: TextAlign
                                                        .center,
                                                  )
                                                      : Image.network(
                                                    _images[index][i],
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              })),
                                          Container(
                                            height: 35,
                                            padding: EdgeInsets.only(left: 10),
                                            alignment: Alignment.centerLeft,
                                            color: Colors.black26,
                                            child: Text(postData == null ? "Loading ..." : toMoney(postData[index].data["price"]) +" บาท",style: whiteText,),
                                          )
                                        ],
                                      )),
                                ),
                                Container(
                                  height: 50,
                                  padding:
                                  EdgeInsets.only(top: 3, bottom: 3),
                                  color: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 10,
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 10),
                                                alignment:
                                                Alignment.centerLeft,
                                                child: Text(
                                                  postData == null
                                                      ? "Loading ..."
                                                      : postData[index]
                                                      .data[
                                                  "year"] +
                                                      " " +
                                                      postData[index]
                                                          .data[
                                                      "band"] +
                                                      " " +
                                                      postData[index]
                                                          .data[
                                                      "gene"] +
                                                      " " +
                                                      postData[index]
                                                          .data[
                                                      "geneDetail"],
                                                  style: nameText,
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
                                          EdgeInsets.only(right: 10),
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          padding:
                                                          EdgeInsets
                                                              .all(2),
                                                          child:
                                                          Image.asset(
                                                            "assets/icons/speed.png",
                                                            color: Colors
                                                                .grey,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Container(
                                                          child: Text(
                                                            postData ==
                                                                null
                                                                ? "Loading ..."
                                                                : postData[index]
                                                                .data["mileage"] +
                                                                " " +
                                                                "KM",
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
                                                child: Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Container(
                                                          padding:
                                                          EdgeInsets
                                                              .all(
                                                              1.6),
                                                          child:
                                                          Image.asset(
                                                            "assets/icons/gear.png",
                                                            color: Colors
                                                                .grey,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Container(
                                                          child: Text(
                                                            postData ==
                                                                null
                                                                ? "Loading ..."
                                                                : postData[index]
                                                                .data[
                                                            "gearType"],
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
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Color(0xffE5E5E5)))),
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
                          height: 30,
                        ),
                      );
                    },
                  ),
                ):Text("Loading ...",style: detailText,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
