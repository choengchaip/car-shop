import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sa_project/LoadingProgress.dart';
import 'FavorPage.dart';
import 'MainPage.dart';
import 'PostDetail.dart';
import 'SearchPage.dart';
import 'DealerDetail.dart';

class home_page extends StatefulWidget {
  _home_page createState() => _home_page();
}

final _db = Firestore.instance;

var userData;
bool IsExpand = false;
TextStyle subText = TextStyle(color: Color(0xff434343), fontSize: 14);
TextStyle optionText = TextStyle(color: Color(0xff434343), fontSize: 12);
TextStyle smallmoneyText = TextStyle(
    color: Color(0xffFF9133), fontSize: 12, fontWeight: FontWeight.bold);

TextStyle detailText = TextStyle(
    color: Color(0xff434343), fontSize: 16, fontWeight: FontWeight.bold);

TextStyle priceText = TextStyle(
    color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);

TextStyle nameText = TextStyle(
    color: Color(0xff434343), fontSize: 14, fontWeight: FontWeight.bold);
TextStyle nextText =
    TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
TextStyle createText =
    TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

TextStyle whiteText =
    TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold);
TextStyle redText = TextStyle(color: Color(0xffff4141), fontSize: 14);

TextStyle contactText = TextStyle(
    color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);
AnimationController _loadingAnimate;
LoadingProgress loadingProgress;
bool isFinish = false;
class _home_page extends State<home_page> with TickerProviderStateMixin{
  Future getUserData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot dataSnapshot =
        await _db.collection("seller").document(user.uid).get();
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child("user_photo").child(user.uid);
    String image = await storageRef.getDownloadURL();

    setState(() {
      userData = dataSnapshot.data;
      userData["avatar"] = image;
    });
  }
  List<DocumentSnapshot> featurePost;
  List<Map<String, dynamic>> featureData;
  List<String> images;
  List<String> dealer_images;
  List<DocumentSnapshot> queryFeatureData;
  List<DocumentSnapshot> queryDealerData;

  Future getFeature() async {
    images = List<String>();
    featureData = List<Map<String, dynamic>>();
    queryFeatureData = List<DocumentSnapshot>();
    setState(() {
      loadingProgress.setProgress(50);
      loadingProgress.setProgressText('Loading Feature Post');
    });
    await _db.collection("clicks").orderBy("clicks",descending: true).limit(5).getDocuments().then((docs) {
      featurePost = docs.documents;
    });
    setState(() {
      loadingProgress.setProgress(100);
      loadingProgress.setProgressText('Starting Load Images');
    });
    for (int i = 0; i < featurePost.length; i++) {
      final StorageReference storageReference = FirebaseStorage.instance.ref().child("post_photo");
      String tmp = await storageReference.child(featurePost[i].data["post"]).child("0").getDownloadURL();
      setState(() {
        images.add(tmp);
        loadingProgress.setProgress(100 + ((50 / featurePost.length)*i));
        loadingProgress.setProgressText('Loading Images ${i}/${featurePost.length - 1}');
      });
    }
    setState(() {
      loadingProgress.setProgress(150);
      loadingProgress.setProgressText('Starting Load Post Data');
    });
    for (int i = 0; i < featurePost.length; i++) {
      final DocumentSnapshot data = await _db
          .collection("post")
          .document(featurePost[i].data["post"])
          .get();
      setState(() {
        loadingProgress.setProgress(150 + ((50 / featurePost.length)*i));
        loadingProgress.setProgressText('Loading Post Data ${i}/${featurePost.length - 1}');
        featureData.add(data.data);
        queryFeatureData.add(data);
      });
    }
    setState(() {
      isFinish = true;
    });
  }

  List<int> colors = [
    0xffB2D3FF,
    0xffCDC9FF,
    0xffFFC9EC,
    0xffFFE7E6,
    0xff6DA06D,
    0xffFF7979
  ];

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

  Future getDealer() async {
    dealer_images = List<String>();
    await _db.collection("buyer").orderBy("clicks",descending: true).getDocuments().then((docs) {
      setState(() {
        queryDealerData = docs.documents;
      });
    });
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("passport_photo");
    for (int i = 0; i < queryDealerData.length; i++) {
      String url;
      url = await storageReference.child(queryDealerData[i].documentID).getDownloadURL().catchError((r){
        return null;
      });
      setState(() {
        dealer_images.add(url);
      });
    }
  }

  @override
  void initState() {
    _loadingAnimate = AnimationController(vsync: this,duration: Duration(seconds: 10));
    _loadingAnimate.repeat();
    _loadingAnimate.addListener((){});
    loadingProgress = LoadingProgress(_loadingAnimate);
    // TODO: implement initState
    super.initState();
    if (mounted) {
      isFinish = false;
      getUserData();
      getFeature();
      getDealer();
      IsExpand = false;
    }
  }

  @override
  void dispose(){
    _loadingAnimate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle topbarText = TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

    TextStyle topbarSubText = TextStyle(
      color: Colors.white,
      fontSize: 15,
    );

    TextStyle searchText = TextStyle(
      color: Color(0xff707070),
      fontSize: 17,
    );

    ScrollController _scroller = ScrollController();

    return !isFinish ? loadingProgress.getSubWidget(context) : Container(
      color: Color(0xffff4141),
      child: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                color: Color(0xffff4141),
                height: IsExpand ? 90 : 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return search_page();
                                }));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Let's go, Search your dream car.",
                                  style: searchText,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.only(top: 12, bottom: 12),
                                child: Image.asset("assets/icons/search.png"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Color(0xffe5e5e5),
                  child: NotificationListener(
                    onNotification: (key) {
                      if (_scroller.position.pixels > 90) {
                        setState(() {
                          IsExpand = true;
                        });
                      }
                      if (_scroller.position.pixels <= 90) {
                        setState(() {
                          IsExpand = false;
                        });
                      }
                    },
                    child: ListView(
                      controller: _scroller,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: IsExpand ? 90 : 0,
                            ),
                            Expanded(
                              child: Container(
                                color: Color(0xffff4141),
                                height: IsExpand ? 0 : 90,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100)),
                                                image: DecorationImage(
                                                    image: userData == null
                                                        ? AssetImage(
                                                            "assets/icons/logo.png")
                                                        : NetworkImage(
                                                            userData["avatar"]),
                                                    fit: BoxFit.cover)),
                                          )
                                        ],
                                      )),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: userData == null
                                                  ? Text("Loading")
                                                  : Text(
                                                      "Hello " +
                                                          userData[
                                                              "firstname"] +
                                                          " " +
                                                          userData["lastname"],
                                                      style: topbarText,
                                                    ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "We have more than 23486 cars.",
                                                style: topbarSubText,
                                              ),
                                            ),
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
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                color: Color(0xffff4141),
                                height: IsExpand ? 0 : 90,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return search_page();
                                        }));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 35, right: 35),
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 5,
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Text(
                                                  "Let's go, Search your dream car",
                                                  style: searchText,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    top: 12, bottom: 12),
                                                child: Image.asset(
                                                    "assets/icons/search.png"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
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
                                height: 130,
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 90,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 2)
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return main_page(2);
                                              }));
                                            },
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    child: Icon(
                                                      Icons.directions_car,
                                                      size: 25,
                                                      color: Color(0xffff4141),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                      child: Text(
                                                    "Sell Your\nCar",
                                                    style: optionText,
                                                    textAlign: TextAlign.center,
                                                  )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap:(){
                                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                                return favor_page();
                                              }));
                                            },
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 1,
                                                  ),
                                                  Container(
                                                    child: Icon(
                                                      Icons.favorite,
                                                      size: 25,
                                                      color: Color(0xffff4141),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                      child: Text(
                                                    "Your Saved\nCars",
                                                    style: optionText,
                                                    textAlign: TextAlign.center,
                                                  )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Container(
                                                  child: Image.asset(
                                                    "assets/icons/calculator.png",
                                                    height: 23,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                    child: Text(
                                                  "Sell Your\nCar",
                                                  style: optionText,
                                                  textAlign: TextAlign.center,
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
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              height: 30,
                              alignment: Alignment.center,
                              child: Text(
                                "Hot Deals",
                                style: detailText,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 200,
                                padding: EdgeInsets.all(15),
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: List.generate(
                                        images == null ? 0 : images.length,
                                        (index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return post_detail(
                                                queryFeatureData[index]);
                                          }));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 10),
                                          alignment: Alignment.center,
                                          width: 130,
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 5,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: images == null
                                                              ? AssetImage(
                                                                  "assets/icons/loading.gif")
                                                              : images.length ==
                                                                      featurePost
                                                                          .length
                                                                  ? NetworkImage(
                                                                      images[
                                                                          index])
                                                                  : AssetImage(
                                                                      "assets/icons/loading.gif"),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Container(
                                                  color: Colors.grey,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 6,
                                                                  right: 6,
                                                                  top: 2),
                                                          color: Colors.white,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            featureData == null
                                                                ? "Loading ..."
                                                                : featureData
                                                                            .length ==
                                                                        featurePost
                                                                            .length
                                                                    ? featureData[index]["year"] +
                                                                        " " +
                                                                        featureData[index]
                                                                            [
                                                                            "band"] +
                                                                        " " +
                                                                        featureData[index]
                                                                            [
                                                                            "gene"] +
                                                                        " " +
                                                                        featureData[index]
                                                                            [
                                                                            "geneDetail"]
                                                                    : "Loading ...",
                                                            style: optionText,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 6),
                                                          color: Colors.white,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            featureData == null
                                                                ? "Loading ..."
                                                                : featureData
                                                                            .length ==
                                                                        featurePost
                                                                            .length
                                                                    ? toMoney(featureData[index]
                                                                            [
                                                                            "price"]) +
                                                                        " Baht"
                                                                    : "Loading ...",
                                                            style:
                                                                smallmoneyText,
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
                                      );
                                    })),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              height: 30,
                              alignment: Alignment.center,
                              child: Text(
                                "Featured Dealers",
                                style: detailText,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 200,
                          padding: EdgeInsets.all(15),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                                queryDealerData == null ? 0: queryDealerData.length, (index) {
                              return GestureDetector(
                                onTap:(){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return dealer_detail(queryDealerData[index]);
                                  }));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                    boxShadow: [BoxShadow(color: Colors.grey ,blurRadius: 2)]
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          decoration: BoxDecoration(),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Container(
                                                height: 65,
                                                width: 65,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(100)),
                                                  image: DecorationImage(
                                                      image: queryDealerData ==
                                                              null ? AssetImage("assets/icons/loading.gif") : dealer_images.length == queryDealerData.length ? dealer_images[index] == null ? AssetImage("assets/icons/logo.png") : NetworkImage(dealer_images[index])
                                                              : AssetImage(
                                                                  "assets/icons/loading.gif"),
                                                      fit: BoxFit.cover),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(queryDealerData == null ? "Loading ..." : dealer_images.length != queryDealerData.length ? "Loading ..." : queryDealerData[index]["passpord"],
                                                  style: nameText,
                                                  softWrap: false,
                                                ),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
