import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sa_project/Pages/Buyer/PostDetail.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class dealer_detail extends StatefulWidget {
  DocumentSnapshot queryData;
  dealer_detail(this.queryData);

  @override
  _dealer_detail createState() => _dealer_detail(this.queryData);
}

enum Selector { listing, about, location }

class _dealer_detail extends State<dealer_detail> {
  DocumentSnapshot queryData;
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double latPoint = 10;
  double lonPoint = 10;
  String shopName = '';
  _dealer_detail(this.queryData);

  List<DocumentSnapshot> postData;
  var _images;
  String bgImg;
  int clicks = 0;
  Completer<GoogleMapController> _controller = Completer();


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
  TextStyle redText = TextStyle(
      color: Color(0xffff4141), fontSize: 14, fontWeight: FontWeight.bold);

  TextStyle contactText = TextStyle(
      color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);

  Selector selector;

  Future getCarData() async {
    final String uid = queryData.documentID;

    _db
        .collection("post")
        .where("uid", isEqualTo: uid)
        .getDocuments()
        .then((data) {
      List<DocumentSnapshot> a = data.documents;
      setState(() {
        postData = a;
        getCarImages();
      });
    });
  }

  Future sendClick() async {
    int a;
    await _db
        .collection('buyer')
        .document(queryData.documentID)
        .get()
        .then((data) {
      a = data.data['clicks'];
    });
    setState(() {
      clicks = a + 1;
    });
    await _db
        .collection("buyer")
        .document(queryData.documentID)
        .updateData({'clicks': a + 1});
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

  Future getDealerData() async {
    await _db.collection('buyer').document(queryData.documentID).get().then((data){
      setState(() {
        latPoint = data.data['lat'];
        lonPoint = data.data['long'];
        if(data.data['lat'] == null){
          latPoint = 10;
        }
        if(data.data['long'] == null){
          lonPoint = 10;
        }
      });
    });
    String url;
    try {
      StorageReference ref = await FirebaseStorage.instance
          .ref()
          .child("face_photo")
          .child(queryData.documentID);
      url = await ref.getDownloadURL();
    } catch (e) {
      print('No Image');
    }
    setState(() {
      bgImg = url;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selector = Selector.listing;
    getCarData();
    getDealerData();
    sendClick();
  }

  @override
  Widget build(BuildContext context) {
    final CameraPosition _position = CameraPosition(
      target: LatLng(latPoint, lonPoint),
      zoom: 16,
    );
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    LocationData currentLocation;

    Future<LocationData> getLocate() async {
      Location location = Location();
      try {
        return await location.getLocation();
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          // Permission denied
        }
        return null;
      }
    }

    Future printLocate()async{
      currentLocation = await getLocate();
      print(currentLocation.latitude);
    }

    Widget listCar = ListView(
      children: List.generate(
        postData == null ? 0 : postData.length,
        (index) {
          return GestureDetector(
              child: Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            margin: EdgeInsets.only(bottom: 1.5),
            height: _width * 0.75 + 75,
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1)]),
              width: _width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return post_detail(postData[index]);
                        }));
                      },
                      child: Container(
                          child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          PageView(
                              children: List.generate(
                                  postData == null
                                      ? 0
                                      : postData[index].data["size"], (i) {
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
                                          textAlign: TextAlign.center,
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
                            child: Text(
                              postData == null
                                  ? "Loading ..."
                                  : toMoney(postData[index].data["price"]) +
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
                          MaterialPageRoute(builder: (context) {
                        return post_detail(postData[index]);
                      }));
                    },
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.only(top: 3, bottom: 3),
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 10,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      postData == null
                                          ? "Loading ..."
                                          : postData[index].data["year"] +
                                              " " +
                                              postData[index].data["band"] +
                                              " " +
                                              postData[index].data["gene"] +
                                              " " +
                                              postData[index]
                                                  .data["geneDetail"],
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
                              padding: EdgeInsets.only(right: 10),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              padding: EdgeInsets.all(2),
                                              child: Image.asset(
                                                "assets/icons/speed.png",
                                                color: Colors.grey,
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
                                                postData == null
                                                    ? "Loading ..."
                                                    : postData[index]
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
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(1.6),
                                              child: Image.asset(
                                                "assets/icons/gear.png",
                                                color: Colors.grey,
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
                                                postData == null
                                                    ? "Loading ..."
                                                    : postData[index]
                                                        .data["gearType"],
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border:
                            Border(top: BorderSide(color: Color(0xffE5E5E5)))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
          ));
        },
      ),
    );

    Widget about = Container(
      padding: EdgeInsets.all(15),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 175,
            child: bgImg == null ? Text("No Image") : Image.network(bgImg),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 40,
                  child: Icon(
                    Icons.error,
                    color: Colors.black54,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(queryData.data['about']),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 40,
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.black54,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                        '${queryData.data['firstName']} ${queryData.data['lastName']}'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 40,
                  child: Icon(
                    Icons.email,
                    color: Colors.black54,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(queryData.data['email']),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 40,
                  child: Icon(
                    Icons.phone,
                    color: Colors.black54,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(queryData.data['phone']),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget location = Column(
      children: <Widget>[
        Container(
          height: (_height - 125 - 60) / 2,
          color: Colors.grey,
          child: GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: {
              Marker(
                  markerId: MarkerId("1"),
                  position: LatLng(latPoint, lonPoint),
                  infoWindow: InfoWindow(
                      title: queryData.data['passpord'])),
            },
            mapType: MapType.normal,
            initialCameraPosition: _position,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffff4141),
        title: Text(
          queryData['passpord'],
          style: topbarText,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.share,
              size: 25,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Color(0xffe5e5e5), width: 2))),
              alignment: Alignment.center,
              height: 125,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      queryData['passpord'],
                      style: nameText,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Text(
                      'Clicks : ' + clicks.toString(),
                      style: nameText,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selector = Selector.listing;
                      });
                    },
                    child: Container(
                      height: 60,
                      alignment: Alignment.center,
                      color: Colors.white,
                      width: _width / 3,
                      child: Text(
                        "Listing",
                        style:
                            selector == Selector.listing ? redText : nameText,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selector = Selector.about;
                      });
                    },
                    child: Container(
                      height: 60,
                      alignment: Alignment.center,
                      color: Colors.white,
                      width: _width / 3,
                      child: Text(
                        "About",
                        style: selector == Selector.about ? redText : nameText,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selector = Selector.location;
                      });
                    },
                    child: Container(
                      height: 60,
                      color: Colors.white,
                      alignment: Alignment.center,
                      width: _width / 3,
                      child: Text(
                        "Location",
                        style:
                            selector == Selector.location ? redText : nameText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Color(0xffe5e5e5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AnimatedAlign(
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 500),
                      alignment: selector == Selector.listing
                          ? Alignment.centerLeft
                          : selector == Selector.about
                              ? Alignment.center
                              : Alignment.centerRight,
                      child: Container(
                          width: _width / 3, height: 2, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  IgnorePointer(
                    ignoring: selector == Selector.listing ? false : true,
                    child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: selector == Selector.listing ? 1 : 0,
                        child: postData == null
                            ? Text(
                                "Loading",
                                style: detailText,
                              )
                            : listCar),
                  ),
                  IgnorePointer(
                    ignoring: selector == Selector.about ? false : true,
                    child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: selector == Selector.about ? 1 : 0,
                        child: postData == null
                            ? Text(
                                "Loading",
                                style: detailText,
                              )
                            : about),
                  ),
                  IgnorePointer(
                    ignoring: selector == Selector.location ? false : true,
                    child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: selector == Selector.location ? 1 : 0,
                        child: postData == null
                            ? Text(
                                "Loading",
                                style: detailText,
                              )
                            : location),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
