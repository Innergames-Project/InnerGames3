class CaseAnalysisReport {
  final List<String> issues;
  final List<String> warnings;
  final int reachableNodes;
  final int totalNodes;

  CaseAnalysisReport({
    required this.issues,
    required this.warnings,
    required this.reachableNodes,
    required this.totalNodes,
  });

  bool get isValid => issues.isEmpty;
}