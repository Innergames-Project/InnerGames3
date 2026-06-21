import 'package:flutter/material.dart';
import '../models/intervention_tracker.dart';

class SimSummaryPage extends StatelessWidget {
  final List<Map<String, dynamic>> pickedChoices;
  final Set<InterventionCard> collectedCards;
  final bool won;

  const SimSummaryPage({
    super.key,
    required this.pickedChoices,
    required this.collectedCards,
    required this.won,
  });

  @override
  Widget build(BuildContext context) {
    final allCards = InterventionCard.values;
    final allCollected = collectedCards.length == allCards.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulation Summary'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              won ? 'Success' : 'Case Lost',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: won ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Intervention Cards: ${collectedCards.length}/8',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: allCards.map((c) {
                final unlocked = collectedCards.contains(c);
                return Chip(
                  label: Text(c.label),
                  backgroundColor: unlocked
                      ? Colors.purple.shade200
                      : Colors.grey.shade300,
                  labelStyle: TextStyle(
                    color: unlocked ? Colors.white : Colors.grey.shade600,
                    fontWeight: unlocked ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            if (allCollected) ...[
              const SizedBox(height: 8),
              const Text(
                'All 8 cards collected!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              'Your choices:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: pickedChoices.length,
                itemBuilder: (context, index) {
                  final entry = pickedChoices[index];
                  final stepCard =
                      entry['stepCard'] as Map<String, dynamic>;
                  final choice =
                      entry['choice'] as Map<String, dynamic>;
                  final consequenceCard =
                      entry['consequenceCard'] as Map<String, dynamic>?;
                  final unlocked =
                      entry['unlockedCards'] as List<InterventionCard>? ?? [];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Step ${stepCard['step']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('Chose: ${choice['text']}'),
                          if (consequenceCard != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              consequenceCard['text'] as String,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          if (unlocked.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: unlocked.map((c) => Chip(
                                label: Text(
                                  c.label,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                backgroundColor: Colors.purple.shade100,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.zero,
                              )).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil(
                  (route) => route.isFirst,
                ),
                child: const Text('Back to Menu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}