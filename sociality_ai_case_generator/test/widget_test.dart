// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sociality_ai_case_generator/main.dart';
import 'package:sociality_ai_case_generator/features/case_generator/language_selector.dart';

void main() {
  testWidgets('home screen shows case generator UI', (WidgetTester tester) async {
    await tester.pumpWidget(const CaseGeneratorApp());

    expect(find.text('Welkom bij de casusgenerator'), findsOneWidget);
    expect(find.text('Selecteer taal'), findsOneWidget);
    expect(find.byType(LanguageSelector), findsOneWidget);
    expect(find.byType(NetherlandsFlag), findsOneWidget);
    expect(find.text('Genereer casus'), findsOneWidget);
    expect(find.byIcon(Icons.upload), findsOneWidget);
  });
}
