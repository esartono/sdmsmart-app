import 'dart:convert';
// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sdmsmart/dash.dart';
import 'package:sdmsmart/config/api.dart';
import 'package:sdmsmart/config/image_icon.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:android_intent/android_intent.dart';

class FormAbsen extends StatefulWidget {
  @override
  _FormAbsenState createState() => _FormAbsenState();
}

class _FormAbsenState extends State<FormAbsen> {
  final _formKey = GlobalKey<FormState>();

  int jenisAbsensId;
  String id, name, pasfoto, nip, idpeg, email, absen, lang, lat, keterangan;

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
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
        id = user['google_id'];
        name = user['name'];
        nip = user['nip'];
        idpeg = user['idpeg'];
        email = user['email'];
        pasfoto =
            'https://pbs.twimg.com/profile_images/637878188949897218/tD6ZRU8R_400x400.jpg';
        // 'http://sdmsmart.nurulfikri.sch.id/fnc_file/func_setimage.php?action=employee&id=1000065';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .356,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/top_header.png'))),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 64,
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 32,
                          backgroundImage: NetworkImage('$pasfoto'),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '$name',
                              style: TextStyle(
                                  fontFamily: 'Montserrat Medium',
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                            Text(
                              '$idpeg',
                              style: TextStyle(
                                  fontFamily: 'Montserrat Regular',
                                  color: Colors.white,
                                  fontSize: 14),
                            ),
                            Text(
                              '$email',
                              style: TextStyle(
                                  fontFamily: 'Montserrat Regular',
                                  color: Colors.white,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 10,
                      primary: false,
                      crossAxisCount: 2,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            absenMasuk();
                          },
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 8,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Gambarnya('assets/icons/masuk.png'),
                                  Textnya('Absensi \n Kehadiran'),
                                ]),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print("Rekap");
                          },
                          child: Card(
                            color: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 8,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Gambarnya('assets/icons/report.png'),
                                  Textnya('Rekapitulasi \n Kehadiran'),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Check GPS enable or Disable
  _gpsOke() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Location permissions are permanently denied, we cannot request permissions.';
    }
    return 'EKO';
  }

  void kirimData(jenisAbsensId, absen, keterangan) async {
    var data = {
      'kunci': 'e48076dd0c3cd2fb83dc17609a8c8f1f',
      'jenisabsens_id': jenisAbsensId,
      'google_id': id,
      'absen': absen,
      'lang': lang,
      'lat': lat,
      'keterangan': keterangan,
    };

    var res = await Network().userAbsen(data, 'absen');
    Map<String, dynamic> body = jsonDecode(res);

    var msg = body['message'];
    _showMsg(msg);
  }

  void absenMasuk() async {
    var cekgps = await _gpsOke();
    if (cekgps == 'EKO') {
      Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best,
              forceAndroidLocationManager: true)
          .then((Position position) {
        setState(() {
          lat = position.latitude.toString();
          lang = position.longitude.toString();
          kirimData(1, 'masuk', 'hadir');
        });
      }).catchError((e) {
        print(e);
      });
    }
  }

  void absenPulang() async {
    var cekgps = await _gpsOke();
    if (cekgps == 'EKO') {
      Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best,
              forceAndroidLocationManager: true)
          .then((Position position) {
        setState(() {
          lat = position.latitude.toString();
          lang = position.longitude.toString();
          kirimData(1, 'pulang', 'hadir');
        });
      }).catchError((e) {
        print(e);
      });
    }
  }
}
