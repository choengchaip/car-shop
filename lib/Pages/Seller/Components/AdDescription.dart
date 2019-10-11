import 'package:flutter/material.dart';

class ad_page extends StatefulWidget {
  String data;
  ad_page(this.data);
  _ad_page createState() => _ad_page(this.data);
}

class _ad_page extends State<ad_page> {
  String data;
  _ad_page(this.data);

  TextStyle createText =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

  TextStyle nextText =
      TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);

  TextStyle detailText = TextStyle(
      color: Color(0xff434343), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle subText = TextStyle(color: Color(0xff434343), fontSize: 14);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    TextEditingController _text = TextEditingController(text: this.data);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffff4141),
        title: Text(
          "Ad Description",
          style: createText,
        ),
        leading: InkWell(
          onTap: (){
            setState(() {
              this.data = _text.text;
            });
            Navigator.of(context).pop(this.data);
          },
          child: Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Container(
          margin: EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                    child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.message,
                        color: Color(0xffff4141),
                        size: 22,
                      ),
                    ),
                  ],
                )),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: _width,
                          child: TextField(
                            controller: _text,
                            decoration:
                                InputDecoration.collapsed(hintText: "Let's go"),
                            style: subText,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            maxLength: 7000,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
