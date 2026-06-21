class CaseStructureValidator {
  const CaseStructureValidator();

  /// Validates an already-converted flat card map.
  /// Returns a list of issue strings, empty means no issues.
  List<String> validateCardMap(
    Map<String, Map<String, dynamic>> cardMap,
  ) {
    final issues = <String>[];

    if (cardMap.isEmpty) {
      issues.add('Case has no cards');
      return issues;
    }

    final allIds = cardMap.keys.toSet();

    for (final entry in cardMap.entries) {
      final card = entry.value;
      final id = entry.key;

      // Each card must have a text field.
      if (card['text'] == null || (card['text'] as String).isEmpty) {
        issues.add('Card $id is missing text');
      }

      final choices = card['choices'] as List<dynamic>?;

      if (choices == null) continue;

      for (final choice in choices) {
        final nextId = choice['next_id'];

        if (nextId == null) {
          issues.add('Choice in card $id is missing next_id');
        } else if (!allIds.contains(nextId)) {
          issues.add('Card $id has invalid next_id "$nextId"');
        }
      }
    }

    return issues;
  }
}