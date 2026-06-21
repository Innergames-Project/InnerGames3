import 'package:flutter/material.dart';
import '../widgets/case_RawJsonPopup.dart';
import '../validators/case_qa_runner.dart';
import 'mock_sim_page.dart';

/// Call this from anywhere to open the backend testing playground.
Future<void> showBackendPlayground(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) => const _BackendPlaygroundDialog(),
  );
}

class _BackendPlaygroundDialog extends StatelessWidget {
  const _BackendPlaygroundDialog();

  Future<void> _loadCase(BuildContext context) async {
    Navigator.of(context).pop();
    await RawJsonPopup.show(context);
  }

  void _testCase(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MockSimPage()),
    );
  }

  void _cardManagement() {
    print("Card Management pressed");
  }

  Future<void> _validateCaseStructure(BuildContext context) async {
    Navigator.of(context).pop();

    try {
      final runner = CaseQARunner();
      final result = await runner.run(
        'assets/initial_data/cards_template.json',
      );

      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Case QA Result"),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Text(_formatQA(result)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    } catch (e, stack) {
      print("QA ERROR: $e");
      print(stack);

      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("QA ERROR"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Backend Playground'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PlaygroundButton(
            label: 'Load Case',
            onPressed: () => _loadCase(context),
          ),
          const SizedBox(height: 12),
          _PlaygroundButton(
            label: 'Test Case',
            onPressed: () => _testCase(context),
          ),
          const SizedBox(height: 12),
          _PlaygroundButton(
            label: 'Card Management',
            onPressed: _cardManagement,
          ),
          const SizedBox(height: 12),
          _PlaygroundButton(
            label: 'Validate Case Structure',
            onPressed: () => _validateCaseStructure(context),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _PlaygroundButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PlaygroundButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

String _formatQA(CaseQAResult r) {
  final buffer = StringBuffer();

  buffer.writeln("STRUCTURE ISSUES:");
  if (r.structureIssues.isEmpty) {
    buffer.writeln(" - none");
  } else {
    for (final i in r.structureIssues) {
      buffer.writeln(" - $i");
    }
  }

  buffer.writeln("\nANALYSIS ISSUES:");
  if (r.analysisIssues.isEmpty) {
    buffer.writeln(" - none");
  } else {
    for (final i in r.analysisIssues) {
      buffer.writeln(" - $i");
    }
  }

  buffer.writeln("\nWARNINGS:");
  if (r.analysisWarnings.isEmpty) {
    buffer.writeln(" - none");
  } else {
    for (final w in r.analysisWarnings) {
      buffer.writeln(" - $w");
    }
  }

  buffer.writeln("\nSIMULATION:");
  buffer.writeln(" - error: ${r.simulationHasError}");
  buffer.writeln(" - finished: ${r.simulationFinished}");
  buffer.writeln(" - steps: ${r.simulationPath.length}");

  buffer.writeln("\nGRAPH:");
  buffer.writeln(" - reachable: ${r.reachableNodes}");
  buffer.writeln(" - total: ${r.totalNodes}");

  buffer.writeln("\nVALID: ${r.isValid}");

  return buffer.toString();
}