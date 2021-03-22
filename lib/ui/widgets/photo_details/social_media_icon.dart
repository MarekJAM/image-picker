import 'package:flutter/material.dart';

class SocialMediaIconArea extends StatelessWidget {
  final String path;

  SocialMediaIconArea(this.path);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: Container(
        height: 15,
        child: Image.asset(path),
      ),
    );
  }
}

