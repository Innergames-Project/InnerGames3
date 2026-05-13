import 'package:flutter/material.dart';
import '../widgets/case_popup.dart';

class BackendReviewingTestPage extends StatelessWidget {
  const BackendReviewingTestPage({super.key});

  void loadCase(BuildContext context) {
    CasePopup.showCase(context);
  }

  void testCase() {
    print("Test Case pressed");
  }

  void cardManagement() {
    print("Card Management pressed");
  }

  void caseManagement() {
    print("Case Management pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backend Testing/Reviewing Playground'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => loadCase(context),
              child: const Text('Load Case'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: testCase,
              child: const Text('Test Case'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: cardManagement,
              child: const Text('Card Management'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: caseManagement,
              child: const Text('Case Management'),
            ),
          ],
        ),
      ),
    );
  }
}