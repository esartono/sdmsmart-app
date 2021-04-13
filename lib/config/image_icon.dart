import 'package:flutter/material.dart';

class Gambarnya extends StatelessWidget {
  final String _assetPath;

  Gambarnya(this._assetPath);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
        child: Image.asset(
      _assetPath,
      fit: BoxFit.cover,
      height: size.height * .15,
    ));
  }
}

class Textnya extends StatelessWidget {
  final String _katanya;

  Textnya(this._katanya);

  @override
  Widget build(BuildContext context) {
    var cardTextStyle = TextStyle(
      fontFamily: 'Montserrat Regular',
      fontSize: 14,
    );

    return Container(
      child: Text(
        _katanya,
        style: cardTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
