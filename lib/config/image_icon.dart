import 'package:flutter/material.dart';

class GambarLogo extends StatelessWidget {
  final String _assetPath;

  GambarLogo(this._assetPath);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Image.asset(
      _assetPath,
      fit: BoxFit.cover,
      height: 75,
    ));
  }
}
