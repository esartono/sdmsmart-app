import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sdmsmart/dash.dart';
import 'package:sdmsmart/config/api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormAbsen extends StatefulWidget {
  @override
  _FormAbsenState createState() => _FormAbsenState();
}

class _FormAbsenState extends State<FormAbsen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  //Data GPS
  // Position _currentPosition;

  String nip, lat, long, ket;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        nip = user['nip'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ket = ModalRoute.of(context).settings.arguments;
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.blue,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: FlatButton(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    child: Text(
                                      _isLoading
                                          ? 'Proccessing...'
                                          : 'Absen $ket',
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  color: Colors.teal,
                                  disabledColor: Colors.grey,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0)),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      // _login('$ket');
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void kirimData(ket) async {
    var data = {'ket': ket, 'nip': nip, 'long': long, 'lat': lat};

    var res = await Network().userData(data);
    var body = json.decode(res.body);
    var cek = body['success'];
    if (cek == 'OK') {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('absen', json.encode(body['absen']));
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      _showMsg(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }

  // void _login(ket) async {
  //   final Geolocator geolocator = Geolocator().forceAndroidLocationManager;

  //   geolocator
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) {
  //     setState(() {
  //       _isLoading = true;
  //       lat = position.latitude.toString();
  //       long = position.longitude.toString();
  //       kirimData(ket);
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }
}
