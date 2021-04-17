import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sdmsmart/formabsen.dart';
import 'package:sdmsmart/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sdmsmart/config/image_icon.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name, pasfoto, nip, idpeg, email;

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    print(user);

    if (user != null) {
      setState(() {
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
    final ScrollController _scrollController = ScrollController();
    final List<String> entries = <String>['A', 'B', 'C', 'D', 'E'];
    final List<int> colorCodes = <int>[600, 500, 100, 300, 200];

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
                    child: Scrollbar(
                      isAlwaysShown: true,
                      controller: _scrollController,
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: entries.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 50,
                              color: Colors.amber[colorCodes[index]],
                              child: Center(
                                  child: Text('Entry ${entries[index]}')),
                            );
                          }),
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

  void absenPegawai() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormAbsen()),
    );
  }

  void logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
