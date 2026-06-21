import 'case_analysis_report.dart';

class CaseAnalyzer {
  const CaseAnalyzer();

  CaseAnalysisReport analyze(
    Map<String, Map<String, dynamic>> cardMap, {
    String? entryId,
  }) {
    final issues = <String>[];
    final warnings = <String>[];

    final allIds = cardMap.keys.toSet();
    final reachable = <String>{};

    // Use the provided entryId, fall back to first key only as last resort.
    final root = entryId ?? (cardMap.isNotEmpty ? cardMap.keys.first : null);

    void dfs(String id) {
      if (reachable.contains(id)) return;
      reachable.add(id);

      final card = cardMap[id];
      if (card == null) return;

      final choices = card['choices'] as List?;
      if (choices == null) return;

      for (final c in choices) {
        final nextId = c['next_id'];
        if (nextId != null && allIds.contains(nextId)) {
          dfs(nextId);
        }
      }
    }

    if (root != null) {
      dfs(root);
    }

    // Flag any cards that are not reachable from the entry point.
    for (final id in allIds) {
      if (!reachable.contains(id)) {
        issues.add('Unreachable card: $id');
      }
    }

    // Flag non-terminal cards with no choices (dead ends).
    for (final entry in cardMap.entries) {
      final card = entry.value;
      final choices = card['choices'] as List?;
      final isTerminal = card['is_terminal'] == true;
      final isDeadEnd = choices == null || choices.isEmpty;

      if (!isTerminal && isDeadEnd) {
        warnings.add('Non-terminal dead end: ${entry.key}');
      }
    }

    // Flag steps where total branching is low.
    // Only counts step cards (id starts with 'step_') to avoid
    // consequence cards skewing the count.
    final branchCount = <int, int>{};

    for (final entry in cardMap.entries) {
      final id = entry.key;
      if (!id.startsWith('step_')) continue;

      final card = entry.value;
      final choices = card['choices'] as List?;
      final step = card['step'] as int? ?? 0;
      branchCount[step] = (branchCount[step] ?? 0) + (choices?.length ?? 0);
    }

    for (final entry in branchCount.entries) {
      if (entry.value <= 1) {
        warnings.add('Low branching at step ${entry.key}');
      }
    }

    return CaseAnalysisReport(
      issues: issues,
      warnings: warnings,
      reachableNodes: reachable.length,
      totalNodes: allIds.length,
    );
  }
}