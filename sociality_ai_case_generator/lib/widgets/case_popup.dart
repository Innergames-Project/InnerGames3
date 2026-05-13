import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class CasePopup {
  static Future<void> showCase(BuildContext context) async {
    // Load JSON from assets
    String data = await rootBundle.loadString('initial_data/cards_template.json');
    Map<String, dynamic> jsonResult = jsonDecode(data);

    List<dynamic> cards = jsonResult['cards'];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            height: 500,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Case name (empty per your request)
                Text(
                  '', // Leave case part empty
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Step ${card['step']}: ${card['id']}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(card['text']),
                              SizedBox(height: 8),
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
                    child: Text('Close'),
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