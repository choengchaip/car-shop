import 'package:flutter/material.dart';
import './HomePage.dart';
import './InboxPage.dart';
import './ProfilePage.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class main_page extends StatefulWidget {
  int indexPage;

  main_page(this.indexPage);

  _main_page createState() => _main_page(this.indexPage);
}

class _main_page extends State<main_page> {
  int indexPage;
  bool isNoti = true;
  _main_page(this.indexPage);

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  List<Widget> pages = [home_page(), inbox_page(), profile_page()];
  int _currentIndex = 0;

  bottomTap(int index) {
    setState(() {
      _currentIndex = index;
      print(_currentIndex);
      if(_currentIndex == 1){
        isNoti = false;
      }
    });
  }

  goToPage() {
    setState(() {
      _currentIndex = this.indexPage;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goToPage();
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message){
        print('onlaus');
        print(message);
      },
      onMessage: (Map<String, dynamic> message){
        setState(() {
          if(_currentIndex != 1){
            isNoti = true;
          }
          print('onMess');
          print(message);
        });
      },
      onResume: (Map<String, dynamic> message){
        print('onRes');
        print(message);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0xffdd1c1c),
          onTap: bottomTap,
          currentIndex: _currentIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                title: Text("หน้าแรก"), icon: Icon(Icons.home)),
            BottomNavigationBarItem(
              title: Text('แจ้งเตือน'),
              icon: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Container(
                    child: Icon(Icons.notifications),
                  ),
                  Container(
                    width: isNoti == true ? 8 : 0,
                    height: isNoti == true ? 8 : 0,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BottomNavigationBarItem(
                title: Text("บัญชี"), icon: Icon(Icons.account_circle)),
          ]),
    );
  }
}
