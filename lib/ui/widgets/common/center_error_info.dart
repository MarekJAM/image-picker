import 'package:flutter/material.dart';

class CenterErrorInfo extends StatelessWidget {
  final Function onButtonPressed;
  const CenterErrorInfo({@required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 40,
          ),
          SizedBox(height: 10),
          Text(
            'Something went wrong!',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          ElevatedButton(onPressed: () {
            onButtonPressed();
          }, child: Text('Retry'))
        ],
      ),
    );
  }
}