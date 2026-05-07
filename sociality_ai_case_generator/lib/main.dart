import 'package:flutter/material.dart';

void main() => runApp(BackendApp());

class BackendApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backend Testing',
      home: Scaffold(
        appBar: AppBar(title: Text('Backend Testing/Reviewing')),
        body: Center(
          child: Text(
            'Backend Testing/Reviewing',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
