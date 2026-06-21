/// Converts the new case JSON format (stepCards + consequenceCards)
/// into a flat card map that the existing validators and simulator consume.
///
/// Flow: stepCard -> consequenceCard -> stepCard -> ...
/// Each consequenceCard carries isEnding, isWin, and nextStep.
///
/// Resulting card shape:
/// {
///   'id': String,
///   'step': int,
///   'text': String,
///   'is_terminal': bool,
///   'is_win': bool,
///   'choices': [ { 'text': String, 'next_id': String } ]
/// }

class CaseJsonAdapter {
  const CaseJsonAdapter();

  /// Returns a flat map of id -> card, ready for validators/simulator.
  Map<String, Map<String, dynamic>> convert(Map<String, dynamic> caseData) {
    final result = <String, Map<String, dynamic>>{};

    final stepCards =
        (caseData['stepCards'] as List<dynamic>? ?? []);

    final consequenceCards =
        (caseData['consequenceCards'] as List<dynamic>? ?? []);

    // Index consequence cards by key for quick lookup.
    final consequenceByKey = <String, Map<String, dynamic>>{
      for (final c in consequenceCards)
        c['key'] as String: c as Map<String, dynamic>
    };

    // Index step cards by step number for quick lookup.
    final stepCardByStep = <int, Map<String, dynamic>>{
      for (final s in stepCards)
        s['step'] as int: s as Map<String, dynamic>
    };

    // Convert each step card.
    // A step card's choices point to consequence card keys.
    for (final stepCard in stepCards) {
      final step = stepCard['step'] as int;
      final id = 'step_$step';

      final rawChoices = stepCard['choices'] as List<dynamic>? ?? [];

      final choices = rawChoices.map<Map<String, dynamic>>((c) {
        return {
          'text': c['text'] as String,
          'next_id': c['consequenceCardKey'] as String,
        };
      }).toList();

      result[id] = {
        'id': id,
        'step': step,
        'text': stepCard['scenarioText'] as String,
        'is_terminal': false,
        'is_win': false,
        'choices': choices,
      };
    }

    // Convert each consequence card.
    // A consequence card either ends the case or points to the next step card.
    for (final con in consequenceCards) {
      final key = con['key'] as String;
      final isEnding = con['isEnding'] == true;
      final isWin = con['isWin'] == true;
      final nextStep = con['nextStep'] as int?;

      List<Map<String, dynamic>> choices = [];

      if (!isEnding && nextStep != null && stepCardByStep.containsKey(nextStep)) {
        choices = [
          {
            'text': 'Continue',
            'next_id': 'step_$nextStep',
          }
        ];
      }

      result[key] = {
        'id': key,
        'step': con['step'] as int,
        'text': con['consequenceText'] as String,
        'is_terminal': isEnding,
        'is_win': isWin,
        'choices': choices,
        'interventions': con['interventions'] ?? [],
      };
    }

    return result;
  }

  /// Convenience: returns the entry point id (first step card).
  String? entryId(Map<String, dynamic> caseData) {
    final stepCards = caseData['stepCards'] as List<dynamic>?;
    if (stepCards == null || stepCards.isEmpty) return null;

    final steps = stepCards
        .map((s) => s['step'] as int)
        .toList()
      ..sort();

    return 'step_${steps.first}';
  }
}