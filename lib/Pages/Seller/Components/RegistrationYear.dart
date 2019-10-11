import 'package:flutter/material.dart';

class regis_page extends StatefulWidget {
  _regis_page createState() => _regis_page();
}

class _regis_page extends State<regis_page> {
  TextStyle createText =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

  TextStyle nextText =
      TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);

  TextStyle detailText = TextStyle(
      color: Color(0xff434343), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle subText = TextStyle(color: Color(0xff434343), fontSize: 14);

  List<int> colors = [
    0xffB2D3FF,
    0xffCDC9FF,
    0xffFFC9EC,
    0xff9AFF9E0,
    0xffFFE7E6,
    0xffD9FFDB
  ];

  int year = 2562;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffff4141),
        title: Text(
          "Registration Year",
          style: createText,
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: ListView(
                  children: List.generate(50, (index){
                    return InkWell(
                      onTap: (){
                        Navigator.of(context).pop((year-index).toString());
                      },
                      child: Card(
                        color: Color(colors[index % colors.length]),
                        child: Container(
                          height: 55,
                          child: Text(
                            (year-index).toString(),
                            style: subText,
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
