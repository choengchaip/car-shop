import 'package:flutter/material.dart';

class LoadingProgress {
  AnimationController _loadingAnimate;
  double _progress = 0;
  String _progressText = '';

  LoadingProgress(this._loadingAnimate);

  void setProgress(double progress) {
    this._progress = progress;
  }

  void setProgressText(String progress) {
    this._progressText = progress;
  }

  Widget getWidget(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
//                  Navigator.of(context).pop();
                },
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_loadingAnimate),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(50),
                    child: Image.asset("assets/icons/logo.png"),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              alignment: Alignment.centerLeft,
              duration: Duration(milliseconds: 200),
              height: 3,
              width: _progress,
              color: Color(0xffff4141),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                _progressText,
                style: TextStyle(
                    color: Color(0xffff4141), fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getSubWidget(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
//                Navigator.of(context).pop();
              },
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(_loadingAnimate),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(50),
                  child: Image.asset("assets/icons/logo.png"),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            alignment: Alignment.centerLeft,
            duration: Duration(milliseconds: 200),
            height: 3,
            width: _progress,
            color: Color(0xffff4141),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              _progressText,
              style: TextStyle(
                  color: Color(0xffff4141), fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
