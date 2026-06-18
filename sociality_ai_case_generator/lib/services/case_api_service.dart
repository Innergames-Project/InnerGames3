import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/difficulty_level.dart';
import '../models/generated_case.dart';

class CaseApiService {
  static const _endpoint = 'https://case-gen-api-4isa.onrender.com/cases/generate';
  static const _timeout = Duration(seconds: 120);

  static Future<GeneratedCase> generateCase({
    required DifficultyLevel difficulty,
    required String prompt,
  }) async {
    final response = await http
        .post(
          Uri.parse(_endpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'difficulty': difficulty.apiValue,
            'prompt': prompt,
          }),
        )
        .timeout(_timeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = 'Status ${response.statusCode}';
      try {
        final err = jsonDecode(response.body) as Map<String, dynamic>;
        message = (err['message'] as String?) ?? message;
      } catch (_) {}
      throw Exception(message);
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response format');
    }

    // API wraps the case data under a top-level "case" key.
    final caseData = (decoded['case'] as Map<String, dynamic>?) ?? decoded;
    final result = GeneratedCase.fromJson(caseData);

    if (result.steps.isEmpty) {
      // Diagnostic: expose actual response keys so we can fix the parser if needed.
      throw FormatException(
        'No steps found in API response. '
        'Top-level keys: ${decoded.keys.toList()}. '
        'Case-level keys: ${caseData.keys.toList()}.',
      );
    }

    return result;
  }
}
