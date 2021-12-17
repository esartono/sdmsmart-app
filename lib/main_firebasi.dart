import 'dash.dart';

// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sdmsmart/sign_in.dart';
import 'package:sdmsmart/config/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SDMSmart - SIT Nurul Fikri',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      builder: EasyLoading.init(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var uid = localStorage.getString('uid');

    var data = {
      'kunci': 'e48076dd0c3cd2fb83dc17609a8c8f1f',
      'uid': uid,
    };

    var res = await Network().masuk(data, 'user');
    if (res != null) {
      // Map<String, dynamic> body = jsonDecode(res);
      // var cek = body['success'];
      // if (cek == 'EKO') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false,
      );
      // } else {
      //   signOutGoogle();
      //   EasyLoading.showError(body['message']);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    signInWithGoogle().then((result) {
      if (result == 'eko') {
        _loadUserData();
      }
    });

    return new Scaffold(
      body: Container(
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
              Image(image: AssetImage("assets/logo_nf.png"), height: 150.0),
              SizedBox(height: 20),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Colors.redAccent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        shadowColor: Colors.blueGrey,
        elevation: 8,
      ),
      onPressed: () {
        signInWithGoogle().then((result) {
          if (result == 'eko') {
            _loadUserData();
          } else {
            signOutGoogle();
            EasyLoading.showError(result);
            // _showMsg(result);
          }
        });
      },
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      // highlightElevation: 0,
      // borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in',
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
}
