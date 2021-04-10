import 'package:flutter/material.dart';

import 'package:sdmsmart/config/image_icon.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var cardTextStyle = TextStyle(
      fontFamily: 'Montserrat Regular',
      fontSize: 14,
    );
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
                          backgroundImage: NetworkImage(
                              'https://pbs.twimg.com/profile_images/637878188949897218/tD6ZRU8R_400x400.jpg'),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Eko Sartono',
                              style: TextStyle(
                                  fontFamily: 'Montserrat Medium',
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                            Text(
                              '1000065',
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
                            print("Absen");
                          },
                          child: Card(
                            color: Colors.lightGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GambarLogo('assets/icons/clock.png'),
                                    SizedBox(height: 3),
                                    Text(
                                      'Absensi \n Kehadiran',
                                      style: cardTextStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ]),
                            ),
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GambarLogo('assets/icons/report.png'),
                                    SizedBox(height: 3),
                                    Text(
                                      'Rekapitulasi \n Kehadiran',
                                      style: cardTextStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: GridView.count(
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          primary: false,
                          crossAxisCount: 3,
                          children: <Widget>[
                        TextButton(
                          onPressed: () => {},
                          child: Column(
                            children: <Widget>[Icon(Icons.add), Text("Add")],
                          ),
                        ),
                      ]))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
