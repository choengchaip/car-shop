import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PostPage.dart';

class search_page extends StatefulWidget {
  _search_page createState() => _search_page();
}

class _search_page extends State<search_page> {
  TextEditingController _searchText = TextEditingController();

  TextStyle searchText = TextStyle(color: Color(0xff707070), fontSize: 16);
  TextStyle cancelText = TextStyle(
      color: Color(0xff0000F2), fontSize: 14, fontWeight: FontWeight.bold);

  TextStyle resetText = TextStyle(
      color: Color(0xffff4141), fontSize: 15, fontWeight: FontWeight.bold);
  TextStyle confirmText =
      TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold);
  TextStyle headerText = TextStyle(
      color: Color(0xff434343), fontSize: 15, fontWeight: FontWeight.bold);
  TextStyle subText = TextStyle(color: Color(0xff434343), fontSize: 14);
  TextStyle superText = TextStyle(
      color: Color(0xff434343), fontSize: 14, fontWeight: FontWeight.bold);
  TextStyle blackText =
      TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);
  TextStyle redoText = TextStyle(color: Color(0xff4694FD), fontSize: 13);
  TextStyle doneText = TextStyle(color: Color(0xff4694FD), fontSize: 13);
  TextStyle topBrandText =
      TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold);

  double _minPrice = 100000;
  double _maxPrice = 100000;
  bool _minCheck = false;
  bool _maxCheck = false;
  final _db = Firestore.instance;

  Query _query;
  List<DocumentSnapshot> brandData = List<DocumentSnapshot>();
  List<DocumentSnapshot> modelData = List<DocumentSnapshot>();
  List<String> regionData;
  Future getModel() async {
    setState(() {
      modelData = List<DocumentSnapshot>();
      data["model"] = "Select car model";
    });
    _db
        .collection('post')
        .where('band', isEqualTo: queryData['band'])
        .getDocuments()
        .then((docs) {
      docs.documents.forEach((data) {
        bool isHas = false;
        for (int i = 0; i < modelData.length; i++) {
          if (data.data['model'] == modelData[i].data['model']) {
            isHas = true;
          }
        }
        if (!isHas) {
          modelData.add(data);
        }
      });
    });
  }

  Future getRegionModel() async {
    List<String> tmpData = [];
    _db.collection("post").snapshots().listen((docs) {
      docs.documents.forEach((data) {
        if (!tmpData.contains(data.data["location"])) {
          tmpData.add(data.data["location"]);
        }
      });
      setState(() {
        regionData = tmpData;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    brandData.clear();
    getData();
    getRegionModel();
  }

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

  Map<String, dynamic> queryData = Map<String, dynamic>();
  Map<String, String> data = {
    "brand": "Select car brand",
    "model": "Select car model",
    "location": "Select region",
    "drivenWheel": "Select driven wheel",
    "fuel": "Select fuel type",
    "color": "All"
  };

  bool IsExpand = false;
  bool carBandExpand = false;
  bool carModelExpand = false;
  bool carRegionExpand = false;
  bool carSomethingExpand = false;
  bool carFuelExpand = false;

  var selectColor = {"name": "All", "color": 0xff};

  Future getData() async {
    await _db.collection("brands").getDocuments().then((docs) {
      brandData = docs.documents;
    });
  }

  Future getCarData() async {
    CollectionReference documentReference = _db.collection("post");
    setState(() {
      _query = documentReference;
    });
    queryData.forEach((key, value) {
      setState(() {
        _query = _query.where(key, isEqualTo: value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    _showDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Select car brand first"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("ตกลง"))
              ],
            );
          });
    }

    return Scaffold(
      body: Container(
        color: Color(0xffff4141),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: _height,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).padding.top,
                        ),
                        Container(
                          height: 65,
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          height: 37,
                                          decoration: BoxDecoration(
                                            color: Color(0xffE5E5E5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7)),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      top: 8, bottom: 8),
                                                  child: Image.asset(
                                                      "assets/icons/search.png"),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Container(
                                                  child: TextField(
                                                    controller: _searchText,
                                                    style: searchText,
                                                    decoration: InputDecoration
                                                        .collapsed(
                                                            hintText:
                                                                "ค้นหากันเลย !"),
                                                  ),
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
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "ยกเลิก",
                                      style: cancelText,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Color(0xffe5e5e5),
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  height: 30,
                                  child: Text(
                                    "ยี่ห้อรถ และ โมเดลรถ",
                                    style: headerText,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      carBandExpand = true;
                                    });
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    height: 45,
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          data["brand"],
                                          style: data["brand"] ==
                                                  "Select car brand"
                                              ? subText
                                              : superText,
                                        ),
                                        Icon(
                                          Icons.arrow_drop_up,
                                          size: 25,
                                          color: Color(0xffff4141),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (modelData == null) {
                                        _showDialog();
                                      } else {
                                        carModelExpand = true;
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    height: 45,
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          data["model"],
                                          style: data["model"] ==
                                                  "Select car model"
                                              ? subText
                                              : superText,
                                        ),
                                        Icon(
                                          Icons.arrow_drop_up,
                                          size: 25,
                                          color: Color(0xffff4141),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  height: 30,
                                  child: Text(
                                    "Region",
                                    style: headerText,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      carRegionExpand = true;
                                    });
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    height: 45,
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          data["location"],
                                          style: data["location"] ==
                                                  "Select region"
                                              ? subText
                                              : superText,
                                        ),
                                        Icon(
                                          Icons.arrow_drop_up,
                                          size: 25,
                                          color: Color(0xffff4141),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  height: 30,
                                  child: Text(
                                    "Price",
                                    style: headerText,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  height: 30,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text("Search By Min :  "),
                                      ),
                                      Container(
                                        height: 30,
                                        width: 60,
                                        child: Switch(
                                          value: _minCheck,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _minCheck = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  height: 30,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text("Search By Max : "),
                                      ),
                                      Container(
                                        height: 30,
                                        width: 60,
                                        child: Switch(
                                          value: _maxCheck,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _maxCheck = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _minCheck
                                    ? Container(
                                        alignment: Alignment.bottomLeft,
                                        padding: EdgeInsets.only(left: 15),
                                        height: 30,
                                        child: Text(
                                          "Min : ${_minPrice.toStringAsFixed(0)}",
                                          style: subText,
                                        ),
                                      )
                                    : Container(),
                                _minCheck
                                    ? Slider(
                                        value: _minPrice,
                                        min: 100000,
                                        max: 10000000,
                                        onChanged: (double value) {
                                          setState(() {
                                            _minPrice = value;
                                          });
                                        },
                                        label: 1.toString(),
                                      )
                                    : Container(),
                                _maxCheck
                                    ? Container(
                                        alignment: Alignment.bottomLeft,
                                        padding: EdgeInsets.only(left: 15),
                                        height: 30,
                                        child: Text(
                                          "Max : ${_maxPrice.toStringAsFixed(0)}",
                                          style: subText,
                                        ),
                                      )
                                    : Container(),
                                _maxCheck
                                    ? Slider(
                                        min: 100000,
                                        max: 10000000,
                                        value: _maxPrice,
                                        onChanged: (double value) {
                                          setState(() {
                                            _maxPrice = value;
                                          });
                                        },
                                      )
                                    : Container(),
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  height: 45,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            IsExpand = !IsExpand;
                                          });
                                        },
                                        child: Text(
                                          "Advance Search",
                                          style: subText,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 25,
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  height: IsExpand ? null : 0,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        height: 30,
                                        child: Text(
                                          "Driven Wheel",
                                          style: headerText,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        height: 45,
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              data["drivenWheel"],
                                              style: subText,
                                            ),
                                            Icon(
                                              Icons.arrow_drop_up,
                                              size: 25,
                                              color: Color(0xffff4141),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        height: 30,
                                        child: Text(
                                          "Fuel Type",
                                          style: headerText,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        height: 45,
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              data["fuel"],
                                              style: subText,
                                            ),
                                            Icon(
                                              Icons.arrow_drop_up,
                                              size: 25,
                                              color: Color(0xffff4141),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        height: 30,
                                        child: Text(
                                          "Body Color",
                                          style: headerText,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7,
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
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          selectColor["name"] !=
                                                                      "All" &&
                                                                  selectColor[
                                                                          "name"] !=
                                                                      "Other"
                                                              ? Container(
                                                                  height: 30,
                                                                  width: 30,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        selectColor[
                                                                            "color"]),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          100),
                                                                    ),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                )
                                                              : selectColor[
                                                                          "name"] ==
                                                                      "All"
                                                                  ? Container(
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.all(
                                                                            Radius.circular(100),
                                                                          ),
                                                                          border: Border.all(color: Colors.grey),
                                                                          image: DecorationImage(image: AssetImage("assets/icons/color.png"))),
                                                                    )
                                                                  : Container(
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.all(
                                                                            Radius.circular(100),
                                                                          ),
                                                                          border: Border.all(color: Colors.grey),
                                                                          image: DecorationImage(image: AssetImage("assets/icons/no-color.png"))),
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
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: List.generate(
                                                    colors.length,
                                                    (index) {
                                                      return Column(
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              if (colors[index][
                                                                      "name"] ==
                                                                  "All") {
                                                                queryData.remove(
                                                                    "color");
                                                              } else {
                                                                queryData[
                                                                        "color"] =
                                                                    (colors[index]
                                                                        [
                                                                        "name"]);
                                                              }
                                                              setState(() {
                                                                selectColor[
                                                                        "name"] =
                                                                    colors[index]
                                                                        [
                                                                        "name"];
                                                                selectColor[
                                                                        "color"] =
                                                                    colors[index]
                                                                        [
                                                                        "color"];
                                                              });
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          40),
                                                              height: 40,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  colors[index]["name"] !=
                                                                              "Other" &&
                                                                          colors[index]["name"] !=
                                                                              "All"
                                                                      ? Container(
                                                                          height:
                                                                              30,
                                                                          width:
                                                                              30,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(colors[index]["color"]),
                                                                            borderRadius:
                                                                                BorderRadius.all(
                                                                              Radius.circular(100),
                                                                            ),
                                                                            border:
                                                                                Border.all(color: Colors.grey),
                                                                          ),
                                                                        )
                                                                      : colors[index]["name"] ==
                                                                              "All"
                                                                          ? Container(
                                                                              height: 30,
                                                                              width: 30,
                                                                              decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.all(
                                                                                    Radius.circular(100),
                                                                                  ),
                                                                                  border: Border.all(color: Colors.grey),
                                                                                  image: DecorationImage(image: AssetImage("assets/icons/color.png"))),
                                                                            )
                                                                          : Container(
                                                                              height: 30,
                                                                              width: 30,
                                                                              decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.all(
                                                                                    Radius.circular(100),
                                                                                  ),
                                                                                  border: Border.all(color: Colors.grey),
                                                                                  image: DecorationImage(image: AssetImage("assets/icons/no-color.png"), fit: BoxFit.cover)),
                                                                            )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          40),
                                                              child: Text(
                                                                colors[index]
                                                                    ["name"],
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
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: kBottomNavigationBarHeight + 10,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      queryData.clear();
                                      data = {
                                        "brand": "Select car brand",
                                        "model": "Select car model",
                                        "location": "Select region",
                                        "drivenWheel": "Select driven wheel",
                                        "fuel": "Select fuel type",
                                        "color": "All"
                                      };
                                      selectColor["name"] = "All";
                                      selectColor["color"] = "0xff";
                                      modelData = null;
                                    });
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Clear",
                                      style: resetText,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    getCarData();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return post_page(_query);
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    color: Color(0xffff4141),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "SHOW CARS",
                                      style: confirmText,
                                    ),
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
                    margin: EdgeInsets.only(top: carBandExpand ? 0 : _height),
                    height: _height,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            color: Colors.black87,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Top Brand",
                                      style: topBrandText,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 40, right: 40),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                              height: 45,
                                              alignment: Alignment.topCenter,
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          carBandExpand = false;
                                                          data["brand"] =
                                                              "Toyota";
                                                          queryData["band"] =
                                                              "Toyota";
                                                          getModel();
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Image.asset(
                                                          "assets/icons/toyota.png",
                                                          height: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 0,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        Expanded(
                                          child: Container(
                                              height: 40,
                                              alignment: Alignment.topCenter,
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          carBandExpand = false;
                                                          data["brand"] =
                                                              "Honda";
                                                          queryData["band"] =
                                                              "Honda";
                                                          getModel();
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Image.asset(
                                                          "assets/icons/honda.png",
                                                          height: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        Expanded(
                                          child: Container(
                                              height: 40,
                                              alignment: Alignment.topCenter,
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 0,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          carBandExpand = false;
                                                          data["brand"] =
                                                              "Nissan";
                                                          queryData["band"] =
                                                              "Nissan";
                                                          getModel();
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Image.asset(
                                                          "assets/icons/nissan.png",
                                                          height: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        Expanded(
                                          child: Container(
                                              height: 40,
                                              alignment: Alignment.topCenter,
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          carBandExpand = false;
                                                          data["brand"] =
                                                              "Mazda";
                                                          queryData["band"] =
                                                              "Mazda";
                                                          getModel();
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Image.asset(
                                                          "assets/icons/mazda.png",
                                                          height: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 40, right: 40),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                              height: 45,
                                              alignment: Alignment.topCenter,
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          carBandExpand = false;
                                                          data["brand"] =
                                                              "Mercedez-Benz";
                                                          queryData["band"] =
                                                              "Mercedez-Benz";
                                                          getModel();
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Image.asset(
                                                          "assets/icons/benz.png",
                                                          height: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        Expanded(
                                          child: Container(
                                              height: 40,
                                              alignment: Alignment.topCenter,
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          carBandExpand = false;
                                                          data["brand"] = "BMW";
                                                          queryData["band"] =
                                                              "BMW";
                                                          getModel();
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Image.asset(
                                                          "assets/icons/bmw.png",
                                                          height: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        Expanded(
                                          child: Container(
                                              height: 40,
                                              alignment: Alignment.topCenter,
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          carBandExpand = false;
                                                          data["brand"] =
                                                              "Ford";
                                                          queryData["band"] =
                                                              "Ford";
                                                          getModel();
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Image.asset(
                                                          "assets/icons/ford.png",
                                                          height: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 14,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        Expanded(
                                          child: Container(
                                              height: 40,
                                              alignment: Alignment.topCenter,
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          carBandExpand = false;
                                                          data["brand"] =
                                                              "Chevrolet";
                                                          queryData["band"] =
                                                              "Chevrolet";
                                                          getModel();
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Image.asset(
                                                          "assets/icons/chev.png",
                                                          height: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 13,
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 45,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              carBandExpand = false;
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Cancel",
                                              style: redoText,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          alignment: Alignment.center,
                                          color: Colors.white,
                                          child: Text(
                                            "Select car brand",
                                            style: headerText,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Text(
                                            "Done",
                                            style: doneText,
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: ListView(
                                        children: List.generate(
                                            brandData == null
                                                ? 0
                                                : brandData.length, (index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            carBandExpand = false;
                                            data["brand"] =
                                                brandData[index].data["brand"];
                                            queryData["band"] =
                                                brandData[index].data["brand"];
                                            getModel();
                                          });
                                        },
                                        child: Card(
                                          color: Color(selectColors[(index %
                                              selectColors.length)]["color"]),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              brandData == null
                                                  ? "Loading ..."
                                                  : brandData[index]
                                                      .data["brand"],
                                              style: blackText,
                                            ),
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                          ),
                                        ),
                                      );
                                    })),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.only(top: carModelExpand ? 0 : _height),
                    height: _height,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            color: Colors.black87,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 45,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              carModelExpand = false;
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Cancel",
                                              style: redoText,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          alignment: Alignment.center,
                                          color: Colors.white,
                                          child: Text(
                                            "Select car brand",
                                            style: headerText,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              carModelExpand = false;
                                            });
                                          },
                                          child: Container(
                                            child: Text(
                                              "Done",
                                              style: doneText,
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: ListView(
                                      children: List.generate(
                                        modelData == null
                                            ? 0
                                            : modelData.length,
                                        (index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                carModelExpand = false;
                                                data["model"] = modelData[index]
                                                    .data["model"];
                                                queryData["model"] =
                                                    modelData[index]
                                                        .data["model"];
                                              });
                                            },
                                            child: Card(
                                              color: Color(selectColors[(index %
                                                      selectColors.length)]
                                                  ["color"]),
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  modelData == null
                                                      ? "Loading ..."
                                                      : modelData[index]
                                                          .data["model"],
                                                  style: blackText,
                                                ),
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                              ),
                                            ),
                                          );
                                        },
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
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.only(top: carRegionExpand ? 0 : _height),
                    height: _height,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            color: Colors.black87,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 45,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              carRegionExpand = false;
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Cancel",
                                              style: redoText,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          alignment: Alignment.center,
                                          color: Colors.white,
                                          child: Text(
                                            "Region",
                                            style: headerText,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              carRegionExpand = false;
                                            });
                                          },
                                          child: Container(
                                            child: Text(
                                              "Done",
                                              style: doneText,
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: ListView(
                                      children: List.generate(
                                        regionData == null
                                            ? 0
                                            : regionData.length,
                                        (index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                carRegionExpand = false;
                                                data["location"] =
                                                    regionData[index];
                                                queryData["location"] =
                                                    regionData[index];
                                              });
                                            },
                                            child: Card(
                                              color: Color(selectColors[(index %
                                                      selectColors.length)]
                                                  ["color"]),
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  regionData == null
                                                      ? "Loading ..."
                                                      : regionData[index],
                                                  style: blackText,
                                                ),
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                              ),
                                            ),
                                          );
                                        },
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
