import 'package:flutter/material.dart';

import '../models/app_language.dart';
import '../models/language_scope.dart';
import '../screens/home_page.dart';

class CaseGeneratorApp extends StatefulWidget {
  const CaseGeneratorApp({super.key});

  @override
  State<CaseGeneratorApp> createState() => _CaseGeneratorAppState();
}

class _CaseGeneratorAppState extends State<CaseGeneratorApp> {
  final _languageNotifier = ValueNotifier<AppLanguage>(AppLanguage.dutch);

  @override
  void dispose() {
    _languageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LanguageScope(
      notifier: _languageNotifier,
      child: MaterialApp(
        title: 'Case Generator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          scaffoldBackgroundColor: const Color(0xFF181A1F),
        ),
        home: const CaseGeneratorHomePage(),
      ),
    );
  }
}
