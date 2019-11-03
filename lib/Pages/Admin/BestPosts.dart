import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sa_project/LoadingProgress.dart';

class best_post extends StatefulWidget{
  @override
  _best_post createState() => _best_post();
}

class _best_post extends State<best_post> with TickerProviderStateMixin{
  final _db = Firestore.instance;
  final _ref = FirebaseStorage.instance;
  TextStyle topbarText = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle priceText = TextStyle(color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle detailText = TextStyle(color: Color(0xff434343), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle analText = TextStyle(color: Color(0xffff4141), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle cancelText = TextStyle(color: Color(0xff0000F2), fontSize: 14, fontWeight: FontWeight.bold);
  TextStyle nameText = TextStyle(color: Color(0xff434343), fontSize: 14, fontWeight: FontWeight.bold);
  AnimationController _loadingAnimate;
  List<DocumentSnapshot> bestPosts;
  List<DocumentSnapshot> detailPosts;
  List<DocumentSnapshot> detailDealer;
  LoadingProgress loadingProgress;
  List<String> bestPostsImage;
  bool isFinish = false;
  double _progress = 0;
  String _progressText = '';
  @override
  
  Future getBestPosts()async{
    List<DocumentSnapshot> posts = List<DocumentSnapshot>();
    List<DocumentSnapshot> details = List<DocumentSnapshot>();
    List<DocumentSnapshot> dealers = List<DocumentSnapshot>();
    List<String> images = List<String>();
    setState(() {
      loadingProgress.setProgress(0);
      loadingProgress.setProgressText('Loading Posts Click Data');
    });
    await _db.collection('clicks').orderBy('clicks',descending: true).getDocuments().then((docs){
      posts = docs.documents;
    });
    setState(() {
      loadingProgress.setProgress(50);
      loadingProgress.setProgressText('Starting Load Posts Detail');
    });
    for(int i=0;i<posts.length;i++){
      await _db.collection('post').document(posts[i].data['post']).get().then((data){
        details.add(data);
      });
      setState(() {
        loadingProgress.setProgress(50 + ((50 / posts.length)*i));
        loadingProgress.setProgressText('Loading Posts Detail ${i}/${posts.length-1}');
      });
    }
    setState(() {
      loadingProgress.setProgress(100);
      loadingProgress.setProgressText('Starting Load Dealer Data');
    });
    for(int i=0;i<details.length;i++){
      await _db.collection('buyer').document(details[i].data['uid']).get().then((data){
        dealers.add(data);
      });

      setState(() {
        loadingProgress.setProgress(100 + ((50 / details.length)*i));
        loadingProgress.setProgressText('Loading Dealer Data ${i}/${details.length-1}');
      });
    }
    setState(() {
      loadingProgress.setProgress(150);
      loadingProgress.setProgressText('Starting Load Images');
    });
    for(int i=0;i<posts.length;i++){
      String url = await _ref.ref().child('post_photo').child(posts[i].data['post']).child('0').getDownloadURL();
      images.add(url);
      setState(() {
        loadingProgress.setProgress(150 + ((50 / posts.length)*i));
        loadingProgress.setProgressText('Loading Images ${i}/${posts.length-1}');
      });
    }
    setState(() {
      detailPosts = details;
      detailDealer = dealers;
      bestPosts = posts;
      bestPostsImage = images;
      isFinish = true;
    });
  }

  @override
  void initState(){
    isFinish = false;
    _loadingAnimate =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    _loadingAnimate.repeat();
    _loadingAnimate.addListener(() {
      if (_loadingAnimate.status == AnimationStatus.completed) {

      }
    });
    loadingProgress = LoadingProgress(_loadingAnimate);
    super.initState();
    getBestPosts();
  }

  @override
  void dispose(){
    _loadingAnimate.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {

    // TODO: implement build
    return !isFinish ? loadingProgress.getWidget(context) : Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffff4141),
        title: Text('Best Posts',style: topbarText,),
      ),
      body: Container(
        child: ListView.builder(itemCount: detailPosts == null ? 0 : detailPosts.length,itemBuilder: (BuildContext context, int index){
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
                    backgroundImage: bestPostsImage == null ? AssetImage('assets/icons/loading.gif') : NetworkImage(bestPostsImage[index]),
                    backgroundColor: Colors.black,
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(detailDealer == null ? 'Loading ...' : detailDealer[index].data['passpord'],style: detailText),
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
                        child: Text(bestPosts == null ? 'Loading ...' :  bestPosts[index].data['clicks'].toString()),
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