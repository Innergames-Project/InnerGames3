import 'package:flutter/material.dart';
import '../services/json_service.dart';

class CasePopup {
  static Future<void> showCase(BuildContext context) async {
    List<dynamic> cards = await JsonService.instance.loadCards('assets/initial_data/cards_template.json');

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            height: 500,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  '', // Leave case title empty
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Step ${card['step']}: ${card['id']}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(card['text']),
                              const SizedBox(height: 8),
                              ...?card['choices']?.map<Widget>((choice) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Text('• ${choice['text']} → Next: ${choice['next_id']}'),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}