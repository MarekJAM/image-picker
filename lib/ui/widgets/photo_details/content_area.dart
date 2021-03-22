import 'package:flutter/material.dart';

class ContentArea extends StatelessWidget {
  final Widget content;

  ContentArea(this.content);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        Padding(
          padding: EdgeInsets.all(8),
          child: content,
        ),
      ],
    );
  }
}