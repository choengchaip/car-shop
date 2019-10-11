import 'package:flutter/material.dart';

class vehicle_detail extends StatefulWidget {
  _vehicle_detail createState() => _vehicle_detail();
}

class _vehicle_detail extends State<vehicle_detail> {
  TextStyle createText =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

  TextStyle nextText =
      TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);

  TextStyle detailText = TextStyle(
      color: Color(0xff434343), fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle subText = TextStyle(color: Color(0xff434343), fontSize: 14);

  var data = {
    "year": "",
    "band": "",
    "model": "",
    "gene": "",
    "geneDetail": "",
    "gear": "",
    "gearType": "",
    "doors": "",
    "seat": "",
    "horse": "",
    "cylinder": "",
    "peakPower": "",
    "engineType": "",
    "fuelType": "",
    "length": "",
    "height": "",
    "width": "",
    "weight": "",
    "usb": "",
    "aux": "",
    "bluetooth": "",
    "alarm": "",
    "stability": "",
    "airbags": "",
    "frontLights": "",
    "brakeLights": "",
    "rearLights": "",
  };

  TextEditingController _year = TextEditingController();
  TextEditingController _band = TextEditingController();
  TextEditingController _model = TextEditingController();
  TextEditingController _gene = TextEditingController();
  TextEditingController _geneDetail = TextEditingController();
  TextEditingController _gear = TextEditingController();
  TextEditingController _gearType = TextEditingController();
  TextEditingController _doors = TextEditingController();
  TextEditingController _seat = TextEditingController();
  TextEditingController _horse = TextEditingController();//
  TextEditingController _cylinder = TextEditingController();//
  TextEditingController _peakPower = TextEditingController();//
  TextEditingController _engineType = TextEditingController();//
  TextEditingController _fuelType = TextEditingController();//
  TextEditingController _length = TextEditingController();//
  TextEditingController _height = TextEditingController();//
  TextEditingController _width = TextEditingController();//
  TextEditingController _weight = TextEditingController();//
  TextEditingController _usb = TextEditingController();//
  TextEditingController _aux = TextEditingController();//
  TextEditingController _bluetooth = TextEditingController();//
  TextEditingController _alarm = TextEditingController();//
  TextEditingController _stability = TextEditingController();//
  TextEditingController _airbags = TextEditingController();//
  TextEditingController _frontLights = TextEditingController();//
  TextEditingController _brakeLights = TextEditingController();//
  TextEditingController _rearLights = TextEditingController();//

  bool requireYear = true;
  bool requireBand = true;
  bool requireModel = true;
  bool requireGene = true;
  bool requireGeneDetail = true;
  bool requireGear = true;
  bool requireGearType = true;
  bool requireDoors = true;
  bool requireSeat = true;
  bool requireHorse = true;
  bool requireCylinder = true;
  bool requirePeakPower = true;
  bool requireEngineType = true;
  bool requireFuelType = true;
  bool requireLength = true;
  bool requireHeight = true;
  bool requireWidth = true;
  bool requireWeight = true;
  bool requireUsb = true;
  bool requireAux = true;
  bool requireBluetooth = true;
  bool requireAlarm = true;
  bool requireStability = true;
  bool requireAirbags = true;
  bool requireFrontLights = true;
  bool requireBrakeLights = true;
  bool requireRearLights = true;

  checkData(){
    bool complete = true;
    if(_year.text == ""){
      setState(() {
        requireYear = false;
      });
      complete = false;
    }else{
      setState(() {
        requireYear = true;
      });
    }

    if(_band.text == ""){
      setState(() {
        requireBand = false;
      });
      complete = false;
    }else{
      setState(() {
        requireBand = true;
      });
    }

    if(_model.text == ""){
      setState(() {
        requireModel = false;
      });
      complete = false;
    }else{
      setState(() {
        requireModel = true;
      });
    }

    if(_gene.text == ""){
      setState(() {
        requireGene = false;
      });
      complete = false;
    }else{
      setState(() {
        requireGene = true;
      });
    }

    if(_geneDetail.text == ""){
      setState(() {
        requireGeneDetail = false;
      });
      complete = false;
    }else{
      setState(() {
        requireGeneDetail = false;
      });
    }

    if(_gear.text == ""){
      setState(() {
        requireGear = false;
      });
      complete = false;
    }else{
      setState(() {
        requireGear = true;
      });
    }

    if(_gearType.text == ""){
      setState(() {
        requireGearType = false;
      });
      complete = false;
    }else{
      setState(() {
        requireGearType = true;
      });
    }

    if(_doors.text == ""){
      requireDoors = false;
      complete = false;
    }else{
      setState(() {
        requireDoors = true;
      });
    }

    if(_seat.text == ""){
      requireSeat = false;
      complete = false;
    }else{
      setState(() {
        requireSeat = true;
      });
    }

    if(_horse.text == ""){
      requireHorse = false;
      complete = false;
    }else{
      setState(() {
        requireHorse = true;
      });
    }

    if(_cylinder.text == ""){
      requireCylinder = false;
      complete = false;
    }else{
      setState(() {
        requireCylinder = true;
      });
    }

    if(_peakPower.text == ""){
      requirePeakPower = false;
      complete = false;
    }else{
      setState(() {
        requirePeakPower = true;
      });
    }

    if(_engineType.text == ""){
      requireEngineType = false;
      complete = false;
    }else{
      setState(() {
        requireEngineType = true;
      });
    }

    if(_fuelType.text == ""){
      requireFuelType = false;
      complete = false;
    }else{
      setState(() {
        requireFuelType = true;
      });
    }

    if(_length.text == ""){
      requireLength = false;
      complete = false;
    }else{
      setState(() {
        requireLength = true;
      });
    }

    if(_height.text == ""){
      requireHeight = false;
      complete = false;
    }else{
      setState(() {
        requireHeight = true;
      });
    }

    if(_width.text == ""){
      requireWidth = false;
      complete = false;
    }else{
      setState(() {
        requireWidth = true;
      });
    }

    if(_weight.text == ""){
      requireWeight = false;
      complete = false;
    }else{
      setState(() {
        requireWeight = true;
      });
    }

    if(_usb.text == ""){
      requireUsb = false;
      complete = false;
    }else{
      setState(() {
        requireUsb = true;
      });
    }

    if(_aux.text == ""){
      requireAux = false;
      complete = false;
    }else{
      setState(() {
        requireAux = true;
      });
    }

    if(_bluetooth.text == ""){
      requireBluetooth = false;
      complete = false;
    }else{
      setState(() {
        requireBluetooth = true;
      });
    }

    if(_alarm.text == ""){
      requireAlarm = false;
      complete = false;
    }else{
      setState(() {
        requireAlarm = true;
      });
    }

    if(_stability.text == ""){
      requireStability = false;
      complete = false;
    }else{
      setState(() {
        requireStability = true;
      });
    }

    if(_airbags.text == ""){
      requireAirbags = false;
      complete = false;
    }else{
      setState(() {
        requireAirbags = true;
      });
    }

    if(_frontLights.text == ""){
      requireFrontLights = false;
      complete = false;
    }else{
      setState(() {
        requireFrontLights = true;
      });
    }

    if(_brakeLights.text == ""){
      requireBrakeLights = false;
      complete = false;
    }else{
      setState(() {
        requireBrakeLights = true;
      });
    }

    if(_rearLights.text == ""){
      requireRearLights = false;
      complete = false;
    }else{
      setState(() {
        requireRearLights = true;
      });
    }

    return complete;
  }

  saveToData(){
    data["year"] = _year.text;
    data["band"] = _band.text;
    data["model"] = _model.text;
    data["gene"] = _gene.text;
    data["geneDetail"] = _geneDetail.text;
    data["gear"] = _gear.text;
    data["gearType"] = _gearType.text;
    data["doors"] = _doors.text;
    data["seat"] = _seat.text;
    data["horse"] = _horse.text;
    data["cylinder"] = _cylinder.text;
    data["peakPower"] = _peakPower.text;
    data["engineType"] = _engineType.text;
    data["fuelType"] = _fuelType.text;
    data["length"] = _length.text;
    data["height"] = _height.text;
    data["width"] = _width.text;
    data["weight"] = _weight.text;
    data["usb"] = _usb.text;
    data["aux"] = _aux.text;
    data["bluetooth"] = _bluetooth.text;
    data["alarm"] = _alarm.text;
    data["stability"] = _stability.text;
    data["airbags"] = _airbags.text;
    data["frontLights"] = _frontLights.text;
    data["brakeLights"] = _brakeLights.text;
    data["rearLights"] = _rearLights.text;
  }

  saveButton(){
    if(checkData()){
      saveToData();
      print("Ok");
      Navigator.of(context).pop(data);
    }else{
      print("No");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffff4141),
        title: Text(
          "Vehicle Details",
          style: createText,
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: ListView(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Car Details",
                                                style: detailText,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireYear == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Icon(
                                        Icons.timeline,
                                        color: Color(0xffff41414),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Year",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _year,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter the year"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireBand == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Icon(
                                        Icons.local_offer,
                                        color: Color(0xffff41414),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Band",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _band,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter the car band"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireModel == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Icon(
                                        Icons.directions_car,
                                        color: Color(0xffff41414),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Model",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _model,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter the car model"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireGene == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Icon(
                                        Icons.view_agenda,
                                        color: Color(0xffff41414),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Gene",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _gene,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter the car gene"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireGeneDetail == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Icon(
                                        Icons.dehaze,
                                        color: Color(0xffff41414),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Gene Details",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _geneDetail,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter the car gene details"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "General Details",
                                                style: detailText,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireGear == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Icon(
                                        Icons.settings,
                                        color: Color(0xffff41414),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Gear Number",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _gear,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter number of gears"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireGearType == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Image.asset("assets/icons/gear.png",height: 23,),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Gear Type",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _gearType,
                                                  style: subText,
                                                  decoration:
                                                  InputDecoration.collapsed(
                                                      hintText:
                                                      "Enter gear detail eg. Automatic , Manual"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireDoors == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Color(0xffff41414),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Doors",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _doors,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter number of doors"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireSeat == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Icon(
                                        Icons.people,
                                        color: Color(0xffff41414),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Seat Capacity",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _seat,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter seat capacity"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireHorse == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Container(
                                        child: Image.asset(
                                          "assets/icons/horse.png",
                                          height: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Horse Power",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _horse,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter hourse power"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Engine Details",
                                                style: detailText,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireCylinder == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Image.asset(
                                        "assets/icons/cylinder.png",
                                        height: 22,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Cylinder",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _cylinder,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter number of cylinders"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requirePeakPower == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Container(
                                        child: Image.asset(
                                          "assets/icons/speed.png",
                                          height: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Peak Power",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _peakPower,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter peak power"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireEngineType == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Container(
                                        child: Image.asset(
                                          "assets/icons/engine.png",
                                          height: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Engine Type",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _engineType,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter type of engine"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireFuelType == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Container(
                                        child: Image.asset(
                                          "assets/icons/fuel.png",
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Fuel Type",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _fuelType,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter fuel type"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Dimension Details",
                                                style: detailText,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireLength == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Image.asset(
                                        "assets/icons/length.png",
                                        height: 24.5,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Length",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _length,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter car length"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireHeight == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Container(
                                        child: Image.asset(
                                          "assets/icons/height.png",
                                          height: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Height",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _height,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter car height"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireWidth == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Container(
                                        child: Image.asset(
                                          "assets/icons/width.png",
                                          height: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Width",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _width,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter car width"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireWeight == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Container(
                                        child: Image.asset(
                                          "assets/icons/weight.png",
                                          height: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Weight",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _weight,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter car weight"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Equipment Details",
                                                style: detailText,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireUsb == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Icon(
                                        Icons.usb,
                                        color: Color(0xffff4141),
                                        size: 23,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Usb",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _usb,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter detail eg. Yes , No"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireAux == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Container(
                                        child: Icon(
                                          Icons.audiotrack,
                                          color: Color(0xffff4141),
                                          size: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Aux",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _aux,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter detail eg. Yes , No"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireBluetooth == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Container(
                                        child: Icon(
                                          Icons.bluetooth,
                                          color: Color(0xffff4141),
                                          size: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Bluetooth",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _bluetooth,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter detail eg. Yes , No"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireAlarm == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Container(
                                        child: Icon(
                                          Icons.surround_sound,
                                          color: Color(0xffff4141),
                                          size: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Alarm",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _alarm,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter detail eg. Yes , No"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireStability == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Container(
                                        child: Icon(
                                          Icons.settings,
                                          color: Color(0xffff4141),
                                          size: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Stability Control",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _stability,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter Stability detail"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireAirbags == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Container(
                                        child: Icon(
                                          Icons.airline_seat_recline_normal,
                                          color: Color(0xffff4141),
                                          size: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Airbags",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _airbags,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter airbags detail"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireFrontLights == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Container(
                                        child: Icon(
                                          Icons.highlight,
                                          color: Color(0xffff4141),
                                          size: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Front Lights",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _frontLights,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter front lights detail"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireBrakeLights == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Container(
                                        child: Icon(
                                          Icons.highlight_off,
                                          color: Color(0xffff4141),
                                          size: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Brake Lights",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _brakeLights,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter brake lights detail"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(requireRearLights == true ? 0xffffffff : 0xffffd1d1),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff2f2f2), width: 1.5),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Container(
                                        child: Icon(
                                          Icons.lightbulb_outline,
                                          color: Color(0xffff4141),
                                          size: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(
                                                  "Rear Lights",
                                                  style: subText,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: TextField(
                                                  controller : _rearLights,
                                                  style: subText,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              "Enter rear lights detail"),
                                                ),
                                              )),
                                          Expanded(flex: 1, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 70,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                saveButton();
//                Navigator.of(context).pop("Singh");
              },
              child: Container(
                height: 65,
                alignment: Alignment.center,
                color: Color(0xffFBFF95),
                child: Text(
                  "SAVE",
                  style: nextText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
