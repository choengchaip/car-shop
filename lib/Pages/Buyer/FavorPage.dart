import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sa_project/LoadingProgress.dart';
import 'PostDetail.dart';

class favor_page extends StatefulWidget {
  @override
  _favor_page createState() => _favor_page();
}

class _favor_page extends State<favor_page> with TickerProviderStateMixin{
  TextStyle topbarText =
      TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle detailText = TextStyle(
      color: Color(0xff434343), fontSize: 16, fontWeight: FontWeight.bold);

  TextStyle priceText = TextStyle(
      color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);

  TextStyle nameText = TextStyle(
      color: Color(0xff434343), fontSize: 14, fontWeight: FontWeight.bold);
  TextStyle subText = TextStyle(color: Color(0xff434343), fontSize: 14);
  TextStyle mileText = TextStyle(color: Color(0xff434343), fontSize: 12);
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
  final _db = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  final _ref = FirebaseStorage.instance;
  AnimationController _loadingAnimate;
  LoadingProgress loadingProgress;
  List<DocumentSnapshot> posts;
  List<String> images;
  bool isFinish = false;

  Future getAllData()async{
    List<DocumentSnapshot> datas;
    List<DocumentSnapshot> tmps = List<DocumentSnapshot>();
    List<String> imgs = List<String>();
    FirebaseUser user = await _auth.currentUser();
    setState((){
      loadingProgress.setProgress(0);
      loadingProgress.setProgressText('Starting Load Favor Data');
    });

    await _db.collection('favor').where('uid',isEqualTo: user.uid).getDocuments().then((docs){
      datas = docs.documents;
    });

    setState((){
      loadingProgress.setProgress(100);
      loadingProgress.setProgressText('Starting Load Post Data');
    });
    for(int i=0;i<datas.length;i++){
      String url = await _ref.ref().child('post_photo').child(datas[i].data['post']).child('0').getDownloadURL();
      imgs.add(url);
      await _db.collection('post').document(datas[i].data['post']).get().then((docs){
        tmps.add(docs);
      });
      setState((){
        loadingProgress.setProgress(100 + ((100)/datas.length)*(i+1));
        loadingProgress.setProgressText('Loading Post Data ${i+1}/${datas.length}');
      });
    }
    setState(() {
      posts = tmps;
      images = imgs;
    });
    setState((){
      isFinish = true;
    });
  }

  Future deleteFav(DocumentSnapshot target)async{
    String a;
    await _db.collection('favor').where('post',isEqualTo: target.documentID).limit(1).getDocuments().then((docs){
      docs.documents.forEach((data){
        a = data.documentID;
      });
    });
    await _db.collection('favor').document(a).delete();
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

  @override
  void initState() {
    _loadingAnimate = AnimationController(vsync: this,duration: Duration(seconds: 10));
    _loadingAnimate.repeat();
    _loadingAnimate.addListener((){});
    loadingProgress = LoadingProgress(_loadingAnimate);
    isFinish = false;
    // TODO: implement initState
    super.initState();
    getAllData();
  }

  @override
  void dispose(){
    _loadingAnimate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !isFinish ? loadingProgress.getWidget(context) : Scaffold(
        appBar: AppBar(
          title: Text(
            'Saved Cars',
            style: topbarText,
          ),
          backgroundColor: Color(0xffff4141),
        ),
        body: Container(
          color: Color(0xffe5e5e5),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(itemCount: posts == null ? 0: posts.length,itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return post_detail(posts[index]);
                        }));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        color: Colors.white,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 100 / 0.75,
                              height: 100,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Container(
                                    child: images == null ? Image.asset('assets/icons/logo.png') : Image.network(images[index]),
                                  ),
                                  Container(
                                    color: Colors.black54,
                                    alignment: Alignment.center,
                                    height: 30,
                                    child: Text(posts == null ? '' : toMoney(posts[index].data['price']),style: whiteText,),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                height: 100,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: 100,
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: 50,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xffe5e5e5),
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              6))),
                                                  child: Text('Used'),
                                                ),

                                                SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              setState((){
                                                isFinish = false;
                                                loadingProgress.setProgressText('Deleting');
                                              });
                                              deleteFav(posts[index]).then((data){
                                                setState((){
                                                  getAllData();
                                                });
                                              });
                                            },
                                            child: Container(
                                              child: Icon(
                                                Icons.close,
                                                color: Color(0xffff4141),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(posts == null ? "" : '${posts[index].data['year']} ${posts[index].data['band']} ${posts[index].data['gene']} ${posts[index].data['geneDetail']}',style: subText,),
                                    ),
                                    SizedBox(height: 5,),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 100,
                                            height: 20,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  child: Image.asset('assets/icons/speed.png',color: Colors.black54,),
                                                  height: 15,
                                                  width: 13,
                                                ),
                                                SizedBox(width: 2,),
                                                Container(
                                                  height: 15,
                                                  alignment: Alignment.center,
                                                  child: Text(posts == null ? '' : '${posts[index].data['mileage']} KM',style: mileText,),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: 100,
                                            height: 20,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Image.asset('assets/icons/gear.png',color: Colors.black54,),
                                                  height: 15,
                                                  width: 12,
                                                ),
                                                SizedBox(width: 3,),
                                                Container(
                                                  height: 15,
                                                  alignment: Alignment.center,
                                                  child: Text('Automatic',style: mileText,),
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
        ));
  }
}
