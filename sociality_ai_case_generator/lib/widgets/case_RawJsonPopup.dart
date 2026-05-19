import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/json_service.dart';

class RawJsonPopup {
  static Future<void> show(BuildContext context) async {
    final results = await Future.wait([
      JsonService.instance.loadJson('initial_data/cards_template.json'),
      JsonService.instance.loadJson('initial_data/Case_steps.json'),
    ]);

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => _RawJsonDialog(
        sources: {
          'Cards': results[0],
          'Phases': results[1],
        },
      ),
    );
  }
}

class _RawJsonDialog extends StatefulWidget {
  final Map<String, dynamic> sources;

  const _RawJsonDialog({required this.sources});

  @override
  State<_RawJsonDialog> createState() => _RawJsonDialogState();
}

class _RawJsonDialogState extends State<_RawJsonDialog> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.sources.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    final pretty = const JsonEncoder.withIndent('  ')
        .convert(widget.sources[_selected]);

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
                for (final key in widget.sources.keys)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(key),
                      selected: _selected == key,
                      onSelected: (_) => setState(() => _selected = key),
                    ),
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