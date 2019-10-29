import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:sa_project/LoadingProgress.dart';

class google_page extends StatefulWidget {
  LatLng coor;

  google_page({@required this.coor});

  _google_page createState() => _google_page(coor: this.coor);
}

class _google_page extends State<google_page> with TickerProviderStateMixin{
  LatLng coor;

  _google_page({@required this.coor});
  Location location = Location();
  LocationData currentLocation;
  double myLatPoint;
  double myLonPoint;
  bool isFinish = false;

  Future<LocationData> getLocate() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null;
    }
  }
  defineLocation() async{
    currentLocation = await getLocate();
    setState(() {
      myLatPoint = currentLocation.latitude;
      myLonPoint = currentLocation.longitude;
      isFinish = true;
    });
  }

  @override
  void initState() {
    isFinish = false;
    // TODO: implement initState
    super.initState();
    defineLocation();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map'),
        backgroundColor: Color(0xffff4141),
      ),
      body: !isFinish ? Container():WebView(
        initialUrl: 'https://www.google.com/maps/dir/?api=1&origin=${myLatPoint},${myLonPoint}&destination=${coor.latitude},${coor.longitude}',
//        initialUrl: 'https://www.google.com/maps/search/?api=1&query=${myLatPoint.toString()},${myLonPoint.toString()}',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
