import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[500],
        child: Center(
          child: Text('Loading'),
        ),
      ),
    );
  }
}
