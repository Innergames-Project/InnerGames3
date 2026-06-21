import '../services/json_service.dart';
import 'case_adapter.dart';
import 'case_structure_validator.dart';
import 'case_analyzer.dart';
import 'case_flow_simulator.dart';

class CaseQAResult {
  final List<String> structureIssues;
  final List<String> analysisIssues;
  final List<String> analysisWarnings;

  final List<Map<String, dynamic>> simulationPath;

  final int reachableNodes;
  final int totalNodes;

  final bool simulationHasError;
  final bool simulationFinished;

  CaseQAResult({
    required this.structureIssues,
    required this.analysisIssues,
    required this.analysisWarnings,
    required this.simulationPath,
    required this.reachableNodes,
    required this.totalNodes,
    required this.simulationHasError,
    required this.simulationFinished,
  });

  bool get isValid =>
      structureIssues.isEmpty &&
      analysisIssues.isEmpty &&
      !simulationHasError;
}

class CaseQARunner {
  const CaseQARunner();

  final CaseStructureValidator _validator =
      const CaseStructureValidator();

  final CaseAnalyzer _analyzer = const CaseAnalyzer();

  final CaseJsonAdapter _adapter = const CaseJsonAdapter();

  Future<CaseQAResult> run(String path) async {
    final caseData =
        await JsonService.instance.loadJson(path);

    // 1. CONVERT to flat card map using the adapter.
    final cardMap = _adapter.convert(caseData);

    // 2. STRUCTURE VALIDATION against the converted card map.
    final structureIssues = _validator.validateCardMap(cardMap);

    // 3. SIMULATION starting from the entry point.
    final entryId = _adapter.entryId(caseData);
    final sim = simulateCase(cardMap, entryId: entryId);

    // 4. ANALYSIS.
    final analysis = _analyzer.analyze(cardMap, entryId: entryId);

    // 5. RESULT.
    return CaseQAResult(
      structureIssues: structureIssues,
      analysisIssues: analysis.issues,
      analysisWarnings: analysis.warnings,
      simulationPath: sim.path,
      reachableNodes: analysis.reachableNodes,
      totalNodes: analysis.totalNodes,
      simulationHasError: sim.hasError,
      simulationFinished: sim.finished,
    );
  }
}