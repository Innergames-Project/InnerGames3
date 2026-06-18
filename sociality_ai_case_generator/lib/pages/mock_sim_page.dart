import 'package:flutter/material.dart';
import '../services/json_service.dart';
import 'sim_summary_page.dart';

class MockSimPage extends StatefulWidget {
  const MockSimPage({super.key});

  @override
  State<MockSimPage> createState() => _MockSimPageState();
}

class _MockSimPageState extends State<MockSimPage> {
  List<dynamic> _cards = [];
  Map<String, dynamic>? _currentCard;
  final List<Map<String, dynamic>> _pickedChoices = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final cards = await JsonService.instance.loadCards(
      'assets/initial_data/cards_template.json',
    );
    setState(() {
      _cards = cards;
      _currentCard = cards.isNotEmpty ? cards[0] : null;
      _loading = false;
    });
    if (_currentCard != null) _checkForAutoEnd(_currentCard!);
  }

  void _checkForAutoEnd(Map<String, dynamic> card) {
    final id = card['id'] as String?;
    final choices = card['choices'] as List?;

    if (choices == null || choices.isEmpty) {
      final isWin = id == '6A';
      _endSim(lost: !isWin);
    }
  }

  void _pickChoice(Map<String, dynamic> choice) {
    final nextId = choice['next_id'] as String?;

    setState(() {
      _pickedChoices.add({
        'card': _currentCard,
        'choice': choice,
      });
    });

    if (nextId == null) {
      _endSim(lost: true);
      return;
    }

    if (nextId == '6A') {
      _endSim(lost: false);
      return;
    }

    try {
      final nextCard = _cards.firstWhere((c) => c['id'] == nextId);
      setState(() => _currentCard = nextCard);
      _checkForAutoEnd(nextCard);
    } catch (_) {
      _endSim(lost: true);
    }
  }

  void _endSim({required bool lost}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SimSummaryPage(
          pickedChoices: _pickedChoices,
          won: !lost,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Sim'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _currentCard == null
              ? const Center(child: Text('No cards found.'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Step ${_currentCard!['step']}: ${_currentCard!['id']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(_currentCard!['text']),
                      const SizedBox(height: 24),
                      ...?(_currentCard!['choices'] as List?)
                          ?.map<Widget>((choice) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _pickChoice(choice),
                              child: Text(choice['text']),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
    );
  }
}