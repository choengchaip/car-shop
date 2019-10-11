import 'package:flutter/material.dart';
import './HomePage.dart';
import './InboxPage.dart';
import './ProfilePage.dart';
import 'package:flutter/services.dart';

class main_page extends StatefulWidget {
  int indexPage;

  main_page(this.indexPage);

  _main_page createState() => _main_page(this.indexPage);
}

class _main_page extends State<main_page> {
  int indexPage;

  _main_page(this.indexPage);

  List<Widget> pages = [home_page(), inbox_page(), profile_page()];
  int _currentIndex = 0;

  bottomTap(int index) {
    setState(() {
      _currentIndex = index;
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
                title: Text("แจ้งเตือน"), icon: Icon(Icons.notifications)),
            BottomNavigationBarItem(
                title: Text("บัญชี"), icon: Icon(Icons.account_circle)),
          ]),
    );
  }
}
