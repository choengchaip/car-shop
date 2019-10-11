import 'package:flutter/material.dart';
import './HomePage.dart';
import 'package:sa_project/Pages/Buyer/InboxPage.dart';
import './ProfilePage.dart';
import 'package:flutter/services.dart';

class main_page extends StatefulWidget {
  _main_page createState() => _main_page();
}

class _main_page extends State<main_page> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    bottomPresssed(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    List<Widget> pages = [home_page(), inbox_page(), profile_page()];
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: bottomPresssed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_car), title: Text("ประกาศของฉัน")),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), title: Text("แจ้งเตือน")),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text("บัญชี")),
        ],
      ),
    );
  }
}
