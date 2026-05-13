import 'package:flutter/material.dart';
import 'pages/backend_revieuwing_test_page.dart'; // adjust path if needed

void main() => runApp(BackendApp());

class BackendApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backend Testing',
      home: BackendReviewingTestPage(), // show your page here
    );
  }
}