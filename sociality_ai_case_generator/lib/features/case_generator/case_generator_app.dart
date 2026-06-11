import 'package:flutter/material.dart';

import '../../simulation.dart';
import 'case_generator_home_page.dart';
import 'case_simulation_page.dart';
import 'download_success_page.dart';

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
      routes: {
        '/start': (_) => const StartScreen(),
        '/case-simulation': (_) => const CaseSimulationPage(),
        '/download-success': (_) => const DownloadSuccessPage(),
      },
    );
  }
}
