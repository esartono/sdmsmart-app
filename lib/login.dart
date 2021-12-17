import 'dart:convert';
// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sdmsmart/config/api.dart';
import 'package:sdmsmart/dash.dart';
//import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var username;
  var password;

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
    // _scaffoldKey.currentState.showSnackBar(snackBar);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.blue,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 50.0,
                      child: Image.asset('assets/logo_nf.png'),
                    ),
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(top: 25, left: 40, right: 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                  ),
                                  hintText: "No. Induk Pegawai",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (usernameValue) {
                                  if (usernameValue.isEmpty) {
                                    return 'Masukan Nomor Induk Pegawai';
                                  }
                                  username = usernameValue;
                                  return null;
                                },
                              ),
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (passwordValue) {
                                  if (passwordValue.isEmpty) {
                                    return 'Masukan Password Anda';
                                  }
                                  password = passwordValue;
                                  return null;
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextButton.icon(
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _login();
                                      }
                                    },
                                    icon: Icon(Icons.person_pin_circle_rounded),
                                    label: Text('Login'),
                                    style: ButtonStyle(
                                        side: MaterialStateProperty.all(
                                            BorderSide(
                                                width: 1,
                                                color: Colors.blueAccent)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blueAccent),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20)),
                                        textStyle: MaterialStateProperty.all(
                                            TextStyle(fontSize: 20)))),
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

  void _login() async {
    // setState(() {
    //   _isLoading = true;
    // });

    var data = {
      'kunci': 'e48076dd0c3cd2fb83dc17609a8c8f1f',
      'username': username,
      'password': password,
    };

    var res = await Network().masuk(data, 'masuk');

    Map<String, dynamic> body = jsonDecode(res);
    var cek = body['success'];

    Map<String, dynamic> user = body['user'];

    if (cek == 'EKO') {
      Map<String, dynamic> absen = body['absen'];
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('user', jsonEncode(user));
      localStorage.setString('absen', jsonEncode(absen));
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      _showMsg(body['message']);
    }

    // setState(() {
    //   _isLoading = false;
    // });
  }
}
