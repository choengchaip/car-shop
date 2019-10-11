import 'package:flutter/material.dart';

class location_page extends StatefulWidget {
  _location_page createState() => _location_page();
}

var location = [
  {"name": "กรุงเทพ"},
  {"name": "ชลบุรี"},
  {"name": "เชียงใหม่"},
  {"name": "เชียงราย"},
  {"name": "ระยอง"},
  {"name": "ตราด"},
  {"name": "เลย"},
  {"name": "สัตหีบ"},
  {"name": "น่าน"}
];

List<int> colors = [
  0xffB2D3FF,
  0xffCDC9FF,
  0xffFFC9EC,
  0xff9AFF9E0,
  0xffFFE7E6,
  0xffD9FFDB
];

class _location_page extends State<location_page> {
  TextStyle createText =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

  TextStyle nextText =
      TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);

  TextStyle detailText = TextStyle(
      color: Color(0xff434343), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle subText = TextStyle(color: Color(0xff434343), fontSize: 14);

  saveData(String data) {
    Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffff4141),
        title: Text(
          "Location Details",
          style: createText,
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: ListView(
                  children: List.generate(
                    location.length,
                    (index) {
                      return InkWell(
                        onTap: (){
                          saveData(location[index]["name"]);
                        },
                        child: Card(
                          color: Color(colors[index % colors.length]),
                          child: Container(
                            height: 55,
                            child: Text(
                              location[index]["name"],
                              style: subText,
                            ),
                            alignment: Alignment.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              child: Text(
                "SAVE",
                style: nextText,
              ),
              height: 65,
              color: Color(0xffFBFF95),
              alignment: Alignment.center,
            )
          ],
        ),
      ),
    );
  }
}
