import 'package:flutter/material.dart';
import 'package:sa_project/LoginPage.dart';
import 'package:flutter/services.dart';

void main() => runApp(
      MaterialApp(
        title: 'Car Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Color(0xffdd1c1c),
            fontFamily: 'singhFont',
            brightness: Brightness.light),
        home: login_page(),
      ),
    );
