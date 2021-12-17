import 'dart:convert';
// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sdmsmart/dash.dart';
import 'package:sdmsmart/config/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:android_intent/android_intent.dart';

class FormAbsen extends StatefulWidget {
  @override
  _FormAbsenState createState() => _FormAbsenState();
}

class _FormAbsenState extends State<FormAbsen> {
  // final _formKey = GlobalKey<FormState>();
  // Timer _timer;

  int jenisAbsensId, userId;
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
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        userId = user['id'];
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
                    child: Table(
                      border: TableBorder.all(width: 1.0, color: Colors.green),
                      children: [
                        TableRow(children: [
                          Column(
                            children: [Text('Hari')],
                          ),
                          Column(
                            children: [Text('Datang')],
                          ),
                          Column(
                            children: [Text('Pulang')],
                          ),
                        ])
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

  void getData() async {
    var data = {
      'kunci': 'e48076dd0c3cd2fb83dc17609a8c8f1f',
      'user_id': userId,
    };

    var res = await Network().getAbsen(data, 'absens');
    Map<String, dynamic> body = jsonDecode(res);

    var cek = body['success'];
    if (cek == 'OK') {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('absen', json.encode(body['absen']));
    }
    var msg = body['message'];
    _showMsg(msg);
  }
}
