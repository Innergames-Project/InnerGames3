class SimulationResult {
  final List<Map<String, dynamic>> path;
  final bool hasError;
  final bool finished;

  SimulationResult({
    required this.path,
    required this.hasError,
    required this.finished,
  });
}

SimulationResult simulateCase(
  Map<String, Map<String, dynamic>> cardMap, {
  String? entryId,
}) {
  final path = <Map<String, dynamic>>[];
  final visited = <String>{};

  // Use the provided entryId, fall back to first key only as last resort.
  String? currentId =
      entryId ?? (cardMap.isNotEmpty ? cardMap.keys.first : null);

  bool hasError = false;
  bool finished = false;

  while (currentId != null) {
    if (visited.contains(currentId)) {
      hasError = true;
      break;
    }

    visited.add(currentId);

    final card = cardMap[currentId];
    if (card == null) {
      hasError = true;
      break;
    }

    path.add({'card': card});

    final choices = card['choices'] as List?;
    final isTerminal = card['is_terminal'] == true;

    if (isTerminal || choices == null || choices.isEmpty) {
      // Mark as a win if the terminal card says so.
      finished = true;
      break;
    }

    // Always follow the first choice for simulation (happy path).
    final firstChoice = choices.first;
    final nextId = firstChoice['next_id'] as String?;

    if (nextId == null || !cardMap.containsKey(nextId)) {
      hasError = true;
      break;
    }

    currentId = nextId;
  }

  return SimulationResult(
    path: path,
    hasError: hasError,
    finished: finished,
  );
}