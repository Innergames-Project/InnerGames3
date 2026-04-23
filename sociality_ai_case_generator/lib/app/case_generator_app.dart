import 'package:flutter/material.dart';

import '../screens/home_page.dart';

class CaseGeneratorApp extends StatelessWidget {
  const CaseGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Case Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0xFF181A1F),
      ),
      home: const CaseGeneratorHomePage(),
    );
  }
}
