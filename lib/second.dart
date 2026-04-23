import 'package:flutter/material.dart';
import 'main.dart';

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => StartScreen()),
              (route) => false,
            );
          },
          child: Text("Terug naar start"),
        ),
      ),
    );
  }
}