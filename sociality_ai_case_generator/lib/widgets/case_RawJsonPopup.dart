import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/json_service.dart';

class RawJsonPopup {
  static Future<void> show(BuildContext context) async {
    final data = await JsonService.instance.loadJson(
      'assets/initial_data/cards_template.json',
    );

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => _RawJsonDialog(data: data),
    );
  }
}

class _RawJsonDialog extends StatelessWidget {
  final Map<String, dynamic> data;

  const _RawJsonDialog({required this.data});

  @override
  Widget build(BuildContext context) {
    final pretty = const JsonEncoder.withIndent('  ').convert(data);

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Case JSON',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  pretty,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}