import 'package:flutter/material.dart';

class UsernameLabel extends StatelessWidget {
  final String name;

  UsernameLabel({@required this.name});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 3,
      left: 3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[700].withOpacity(0.5),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 2,
          ),
          child: Text(
            name,
            style: TextStyle(
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
