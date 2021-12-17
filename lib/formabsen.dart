import 'dart:convert';
// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sdmsmart/dash.dart';
import 'package:sdmsmart/config/api.dart';
import 'package:sdmsmart/config/image_icon.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormAbsen extends StatefulWidget {
  @override
  _FormAbsenState createState() => _FormAbsenState();
}

class _FormAbsenState extends State<FormAbsen> {
  // final _formKey = GlobalKey<FormState>();

  int jenisAbsensId;
  String name, pasfoto, nip, idpeg, email, absen, lang, lat, keterangan;

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
    _gpsOke();
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        name = user['name'];
        nip = user['nip'];
        idpeg = user['idpeg'];
        email = user['email'];
        pasfoto =
            'http://sdmsmart.nurulfikri.sch.id/fnc_file/func_setimage.php?action=employee&id=' +
                user['idpeg'];
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
                    height: size.height * .1,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 32,
                          backgroundImage: (pasfoto != null)
                              ? NetworkImage('$pasfoto')
                              : null,
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
                                  fontSize: 16),
                            ),
                            Text(
                              '$nip',
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
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: size.height * 0.28,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Gambarnya('assets/icons/masuk.png'),
                                        Textnya('ABSEN MASUK'),
                                      ]),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  absenPulang();
                                },
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  elevation: 8,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Gambarnya('assets/icons/pulang.png'),
                                        Textnya('ABSEN PULANG'),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                border: Border.all(color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15.0),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                      'Tekan tombol "ABSEN MASUK" untuk masuk dan Tekan tombol "ABSEN PULANG" untuk pulang',
                                      maxLines: 3,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal)),
                                )
                              ],
                            ))
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
      'nip': nip,
      'jenisabsens_id': jenisAbsensId,
      'absen': absen,
      'lang': lang,
      'lat': lat,
      'keterangan': keterangan,
    };

    var res = await Network().masuk(data, 'absen');
    Map<String, dynamic> body = jsonDecode(res);

    var cek = body['success'];
    var msg = body['message'];

    if (cek == 'EKO') {
      Map<String, dynamic> absen = body['absen'];
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('absen', jsonEncode(absen));
    }

    _showMsg(msg);
  }

  void absenMasuk() async {
    var cekgps = await _gpsOke();
    if (cekgps == 'EKO') {
      Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.medium,
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
    } else {
      _showMsg(cekgps);
    }
  }

  void absenPulang() async {
    var cekgps = await _gpsOke();
    if (cekgps == 'EKO') {
      Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.medium,
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
    } else {
      _showMsg(cekgps);
    }
  }
}
