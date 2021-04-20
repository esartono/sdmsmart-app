import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdmsmart/formabsen.dart';
import 'package:sdmsmart/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sdmsmart/config/image_icon.dart';
import 'package:sdmsmart/config/api.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer _timer;
  String googleId, name, pasfoto, nip, idpeg, email;

  List<dynamic> hari = ['1', '2', '3', '4', '5', '6', '7'];
  List<dynamic> tanggal = [];
  List<dynamic> masuk = [];
  List<dynamic> pulang = [];

  @override
  void initState() {
    _loadUserData();
    _loadAbsen();
    super.initState();
    _initializeTimer();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      if (mounted) {
        setState(() {
          googleId = user['google_id'];
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
  }

  _loadAbsen() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var googleId = localStorage.getString('uid');
    var data = {
      'kunci': 'e48076dd0c3cd2fb83dc17609a8c8f1f',
      'id': googleId,
    };

    var res = await Network().getAbsen(data, 'absensi');
    Map<String, dynamic> body = jsonDecode(res);
    var cek = body['success'];
    Map<String, dynamic> absen = body['absen'];
    print(body['message']);
    if (cek == 'EKO') {
      tanggal = absen['tanggal'];
      masuk = absen['masuk'];
      pulang = absen['pulang'];
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final ScrollController _scrollController = ScrollController();

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
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
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        primary: false,
                        crossAxisCount: 2,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              absenPegawai();
                            },
                            child: Card(
                              color: Colors.lightGreen,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              elevation: 8,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Gambarnya('assets/icons/clock.png'),
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
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                            columnSpacing: size.width * .08,
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'No.',
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Tanggal',
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Masuk',
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Datang',
                                ),
                              ),
                            ],
                            rows: List.generate(
                                tanggal.length,
                                (index) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(hari[index])),
                                        DataCell(Text(tanggal[index])),
                                        DataCell(Text(masuk[index])),
                                        DataCell(Text(pulang[index])),
                                      ],
                                    ))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '“Barangsiapa yang menunjuki kepada kebaikan maka dia akan mendapatkan pahala seperti pahala orang yang mengerjakannya” \n (HR. Muslim no. 1893).',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Montserrat Regular',
                            color: Colors.white,
                            fontSize: 15,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    SizedBox(height: 30),
                    Image(
                        image: AssetImage("assets/logo_nf.png"), height: 150.0),
                    SizedBox(height: 20),
                    _signInButton(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _signInButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Colors.green,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        shadowColor: Colors.blueGrey,
        elevation: 8,
      ),
      onPressed: () {
        logout();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign out',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void absenPegawai() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormAbsen()),
    );
  }

  void logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.clear();
    signOutGoogle();
    SystemNavigator.pop();
  }

  // start/restart timer
  void _initializeTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
    // setup action after 5 minutes
    _timer = Timer(const Duration(hours: 8), () => _handleInactivity());
  }

  void _handleInactivity() {
    _timer?.cancel();
    _timer = null;

    // logout();
  }
}
