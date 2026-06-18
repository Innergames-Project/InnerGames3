import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/fallback_case.dart';

class FallbackCaseService {
  static Future<FallbackCase> load() async {
    final jsonString = await rootBundle.loadString(
      'assets/initial data/Case_steps.json',
    );
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    return FallbackCase.fromJson(decoded);
  }
}
