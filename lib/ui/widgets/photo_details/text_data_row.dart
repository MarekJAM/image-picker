import 'package:flutter/material.dart';

class TextDataRow extends StatelessWidget {
  final String title;
  final dynamic value;

  TextDataRow({@required this.title, @required this.value});

  @override
  Widget build(BuildContext context) {
    return value != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Text(title),
              ),
              Expanded(
                child: Text(
                  '$value',
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          )
        : Container();
  }
}

