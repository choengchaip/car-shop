import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sa_project/LoadingProgress.dart';

class car_anal extends StatefulWidget {
  int min, max;

  car_anal({@required this.min, @required this.max});

  @override
  _car_anal createState() => _car_anal(min: this.min, max: this.max);
}

class _car_anal extends State<car_anal> with TickerProviderStateMixin {
  int min, max;
  bool notNull = false;
  _car_anal({@required this.min, @required this.max});

  TextStyle topbarText =
      TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle priceText = TextStyle(
      color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle detailText = TextStyle(
      color: Color(0xff434343), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle analText = TextStyle(
      color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle clickText = TextStyle(
      color: Color(0xff0000f2), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle cancelText = TextStyle(
      color: Color(0xff0000F2), fontSize: 14, fontWeight: FontWeight.bold);
  TextStyle nameText = TextStyle(
      color: Color(0xff434343), fontSize: 14, fontWeight: FontWeight.bold);
  final _db = Firestore.instance;
  final _ref = FirebaseStorage.instance;
  AnimationController _loadingAnimate;
  LoadingProgress loadingProgress;
  bool isFinish = false;
  Map<String,dynamic> brandData;
  Map<String,dynamic> colorsData;
  Map<String,dynamic> yearData;
  Map<String,dynamic> doorData;
  Map<String,dynamic> gearData;
  Map<String,dynamic> fuelData;

  Future getCarData() async {
    List<DocumentSnapshot> info;
    Map<String,dynamic> brand = {};
    Map<String,dynamic> colors = {};
    Map<String,dynamic> year = {};
    Map<String,dynamic> door = {};
    Map<String,dynamic> gear = {};
    Map<String,dynamic> fuel = {};
    List<DocumentSnapshot> ageList;
    int max = 0;
    setState((){
      loadingProgress.setProgress(0);
      loadingProgress.setProgressText('Getting Car Data');
    });
    if(this.min != null && this.max != null){
      setState(() {
        notNull = true;
      });
      await _db.collection('age_clicks').where('age',isGreaterThanOrEqualTo: this.min).where('age',isLessThanOrEqualTo: this.max).getDocuments().then((docs) {
        ageList = docs.documents;
      });
    }else{
      setState(() {
        notNull = false;
      });
      await _db.collection('age_clicks').getDocuments().then((docs) {
        ageList = docs.documents;
      });
    }
    setState((){
      loadingProgress.setProgress(50);
      loadingProgress.setProgressText('Analyzing Post Data');
    });
    for(int i=0;i<ageList.length;i++){
      setState((){
        loadingProgress.setProgress(50 + ((150 / ageList.length)*i));
        loadingProgress.setProgressText('Analyzing Post Data ${i+1}/${ageList.length}\nPost ID : ${ageList[i].data['post']}');
      });
      await _db.collection('post').document(ageList[i].data['post']).get().then((data){
        if(brand.containsKey(data.data['band'])){
          int tmp = brand[data.data['band']];
          tmp++;
          brand[data.data['band']] = tmp;
        }else{
          brand[data.data['band']] = 1;
        }

        if(colors.containsKey(data.data['color'])){
          int tmp = colors[data.data['color']];
          tmp++;
          colors[data.data['color']] = tmp;
        }else{
          colors[data.data['color']] = 1;
        }

        if(year.containsKey(data.data['year'])){
          int tmp = year[data.data['year']];
          tmp++;
          year[data.data['year']] = tmp;
        }else{
          year[data.data['year']] = 1;
        }

        if(door.containsKey(data.data['doors'])){
          int tmp = door[data.data['doors']];
          tmp++;
          door[data.data['doors']] = tmp;
        }else{
          door[data.data['doors']] = 1;
        }

        if(gear.containsKey(data.data['gearType'])){
          int tmp =gear[data.data['gearType']];
          tmp++;
          gear[data.data['gearType']] = tmp;
        }else{
          gear[data.data['gearType']] = 1;
        }

        if(fuel.containsKey(data.data['fuelType'])){
          int tmp = fuel[data.data['fuelType']];
          tmp++;
          fuel[data.data['fuelType']] = tmp;
        }else{
          fuel[data.data['fuelType']] = 1;
        }

      });
    }
    int tmp = 0;
    String str;
    brand.forEach((key,value){
      if(tmp < value){
        tmp = value;
        str = key;
        setState(() {
          brandData = {'brand':str,'clicks':tmp};
        });
      }
    });
    tmp = 0;
    colors.forEach((key,value){
      if(tmp < value){
        tmp = value;
        str = key;
        setState(() {
          colorsData = {'brand':str,'clicks':tmp};
        });
      }
    });
    tmp = 0;
    year.forEach((key,value){
      if(tmp < value){
        tmp = value;
        str = key;
        setState(() {
          yearData = {'brand':str,'clicks':tmp};
        });
      }
    });
    tmp = 0;
    door.forEach((key,value){
      if(tmp < value){
        tmp = value;
        str = key;
        setState(() {
          doorData = {'brand':str,'clicks':tmp};
        });
      }
    });
    tmp = 0;
    gear.forEach((key,value){
      if(tmp < value){
        tmp = value;
        str = key;
        setState(() {
          gearData = {'brand':str,'clicks':tmp};
        });
      }
    });
    tmp = 0;
    fuel.forEach((key,value){
      if(tmp < value){
        tmp = value;
        str = key;
        setState(() {
          fuelData = {'brand':str,'clicks':tmp};
        });
      }
    });
    setState(() {
      isFinish = true;
    });
  }

  @override
  void initState() {
    _loadingAnimate =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    _loadingAnimate.repeat();
    _loadingAnimate.addListener(() {});
    loadingProgress = LoadingProgress(_loadingAnimate);
    isFinish = false;
    // TODO: implement initState
    super.initState();
    getCarData();
  }

  @override
  void dispose() {
    _loadingAnimate.dispose();
    super.dispose();
    isFinish = false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return !isFinish ? loadingProgress.getWidget(context) : Scaffold(
      appBar: AppBar(
        title: Text(
          'Car Analysis',
          style: topbarText,
        ),
        backgroundColor: Color(0xffff4141),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            notNull ? Container(
              height: 50,
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(
                'Age min : ${this.min} / Age max : ${this.max}',
                style: detailText,
                textAlign: TextAlign.center,
              ),
            ):Container(),
            Container(
              height: 70,
              alignment: Alignment.center,
              child: Text(
                'The Most Click',
                style: detailText,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(color: Color(0xffe5e5e5)),
                      bottom: BorderSide(color: Color(0xffe5e5e5)))),
              height: 100,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 100,
                      child: Text(
                        "Brand",
                        style: detailText,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: Text(
                                brandData == null ? '' : brandData['brand'],
                                style: analText,
                              ),
                            ),
                            Container(
                              child: Text(
                                'Clicks : ${brandData == null ? '' : brandData['clicks'].toString()}',
                                style: clickText,
                              ),
                            ),
                          ]),
                    ),
                  ]),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xffe5e5e5)))),
              height: 100,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 100,
                      child: Text(
                        "Color",
                        style: detailText,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: Text(
                                colorsData == null ? '' : colorsData['brand'],
                                style: analText,
                              ),
                            ),
                            Container(
                              child: Text(
                                'Clicks : ${colorsData == null ? '' : colorsData['clicks'].toString()}',
                                style: clickText,
                              ),
                            ),
                          ]),
                    ),
                  ]),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xffe5e5e5)))),
              height: 100,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 100,
                      child: Text(
                        "Year",
                        style: detailText,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: Text(
                                yearData == null ? '' : colorsData['brand'],
                                style: analText,
                              ),
                            ),
                            Container(
                              child: Text(
                                'Clicks : ${yearData == null ? '' : colorsData['clicks'].toString()}',
                                style: clickText,
                              ),
                            ),
                          ]),
                    ),
                  ]),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xffe5e5e5)))),
              height: 100,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 100,
                      child: Text(
                        "Average Price",
                        style: detailText,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Benz",
                                style: analText,
                              ),
                            ),
                            Container(
                              child: Text(
                                "Clicks : 0",
                                style: clickText,
                              ),
                            ),
                          ]),
                    ),
                  ]),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xffe5e5e5)))),
              height: 100,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 100,
                      child: Text(
                        "Door",
                        style: detailText,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: Text(
                                doorData == null ? '' : doorData['brand'] + " Doors",
                                style: analText,
                              ),
                            ),
                            Container(
                              child: Text(
                                'Clicks : ${doorData == null ? '' : doorData['clicks'].toString()}',
                                style: clickText,
                              ),
                            ),
                          ]),
                    ),
                  ]),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xffe5e5e5)))),
              height: 100,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 100,
                      child: Text(
                        "Gear Type",
                        style: detailText,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: Text(
                                gearData == null ? '' : gearData['brand'],
                                style: analText,
                              ),
                            ),
                            Container(
                              child: Text(
                                "Clicks : ${gearData == null ? '' : gearData['clicks'].toString()}",
                                style: clickText,
                              ),
                            ),
                          ]),
                    ),
                  ]),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xffe5e5e5)))),
              height: 100,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 100,
                      child: Text(
                        "Fuel Type",
                        style: detailText,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: Text(
                                fuelData == null ? '' : fuelData['brand'].toString(),
                                style: analText,
                              ),
                            ),
                            Container(
                              child: Text(
                                "Clicks : ${fuelData == null ? '' : fuelData['clicks'].toString()}",
                                style: clickText,
                              ),
                            ),
                          ]),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
