import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sa_project/LoadingProgress.dart';

class dealer_page extends StatefulWidget{
  @override
  _dealer_page createState() => _dealer_page();
}

class _dealer_page extends State<dealer_page> with TickerProviderStateMixin{
  final _db = Firestore.instance;
  final _ref = FirebaseStorage.instance;
  TextStyle topbarText = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle priceText = TextStyle(color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle detailText = TextStyle(color: Color(0xff434343), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle analText = TextStyle(color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle cancelText = TextStyle(color: Color(0xff0000F2), fontSize: 14, fontWeight: FontWeight.bold);
  TextStyle nameText = TextStyle(color: Color(0xff434343), fontSize: 14, fontWeight: FontWeight.bold);
  AnimationController _loadingAnimate;
  List<DocumentSnapshot> bestDealers;
  List<String> bestDealersImage;
  LoadingProgress loadingProgress;
  double _progress = 0;
  Future getDealers()async{
    List<DocumentSnapshot> dealers;
    List<String> images = List<String>();
    setState(() {
      loadingProgress.setProgress(100);
      loadingProgress.setProgressText('Loading Dealer Data');
    });
    await _db.collection('buyer').orderBy('clicks',descending: true).getDocuments().then((docs){
      dealers = docs.documents;
    });
    setState(() {
      loadingProgress.setProgress(150);
      loadingProgress.setProgressText('Starting Load Dealer Images');
    });
    for(int i=0;i<dealers.length;i++){
      String url = await _ref.ref().child('passport_photo').child(dealers[i].documentID).getDownloadURL();
      images.add(url);
      setState(() {
        loadingProgress.setProgress(150 + ((50 / dealers.length)*i));
        loadingProgress.setProgressText('Loading Dealer Images ${i}/${dealers.length-1}');
      });
    }
    setState(() {
      bestDealers = dealers;
      bestDealersImage = images;
    });
  }

  @override
  void initState() {
    _loadingAnimate =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    _loadingAnimate.repeat();
    _loadingAnimate.addListener(() {
      if (_loadingAnimate.status == AnimationStatus.completed) {

      }
    });
    // TODO: implement initState
    super.initState();
    loadingProgress = LoadingProgress(_loadingAnimate);
    getDealers();
  }

  @override
  void dispose(){
    _loadingAnimate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return bestDealers == null ? loadingProgress.getWidget(context) : Scaffold(
      appBar: AppBar(
        title: Text('Best Dealers'),
        backgroundColor: Color(0xffff4141),
      ),
      body: Container(
        child: ListView.builder(itemCount: bestDealersImage == null ? 0 : bestDealers.length,itemBuilder: (BuildContext context, int index){
          return Container(
            padding: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xffe5e5e5)),bottom: BorderSide(color: Color(0xffe5e5e5)))
            ),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  width: 100,
                  height: 100,
                  child: CircleAvatar(
                    backgroundImage: bestDealersImage == null ? AssetImage('assets/icons/loading.gif') : NetworkImage(bestDealersImage[index]),
                    backgroundColor: Colors.black,
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(bestDealers == null ? 'Loading ...' : bestDealers[index].data['passpord'],style: detailText),
                  ),
                ),
                Container(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Text('จำนวนการเข้าชม',style: nameText,),
                      ),
                      Container(
                        child: Text(bestDealers == null ? 'Loading ...' : bestDealers[index].data['clicks'].toString()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },)
      ),
    );
  }
}