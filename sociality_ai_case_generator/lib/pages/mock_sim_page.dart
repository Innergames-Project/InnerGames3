import 'package:flutter/material.dart';
import '../services/json_service.dart';
import '../validators/case_adapter.dart';
import '../models/intervention_tracker.dart';
import 'sim_summary_page.dart';

enum _CardKind { step, consequence }

class MockSimPage extends StatefulWidget {
  const MockSimPage({super.key});

  @override
  State<MockSimPage> createState() => _MockSimPageState();
}

class _MockSimPageState extends State<MockSimPage> {
  Map<String, Map<String, dynamic>> _cardMap = {};
  Map<String, dynamic>? _currentCard;
  _CardKind _currentKind = _CardKind.step;

  final List<Map<String, dynamic>> _history = [];
  final Set<InterventionCard> _collected = {};

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final caseData = await JsonService.instance.loadJson(
      'assets/initial_data/cards_template.json',
    );

    const adapter = CaseJsonAdapter();
    final cardMap = adapter.convert(caseData);
    final entryId = adapter.entryId(caseData);

    setState(() {
      _cardMap = cardMap;
      _currentCard = entryId != null ? cardMap[entryId] : null;
      _currentKind = _CardKind.step;
      _loading = false;
    });
  }

  void _onStepChoice(Map<String, dynamic> choice) {
    if (_currentCard == null) return;

    final nextId = choice['next_id'] as String?;
    if (nextId == null) { _end(); return; }

    final consequenceCard = _cardMap[nextId];
    if (consequenceCard == null) { _end(); return; }

    final newCards = unlockedByConsequence(consequenceCard);

    _history.add({
      'stepCard': _currentCard,
      'choice': choice,
      'consequenceCard': consequenceCard,
      'unlockedCards': newCards.toList(),
    });

    setState(() {
      _collected.addAll(newCards);
      _currentCard = consequenceCard;
      _currentKind = _CardKind.consequence;
    });
  }

  void _onConsequenceContinue() {
    if (_currentCard == null) return;

    final isTerminal = _currentCard!['is_terminal'] == true;
    if (isTerminal) { _end(); return; }

    final choices = _currentCard!['choices'] as List?;
    if (choices == null || choices.isEmpty) { _end(); return; }

    final nextId = choices.first['next_id'] as String?;
    if (nextId == null) { _end(); return; }

    final nextCard = _cardMap[nextId];
    if (nextCard == null) { _end(); return; }

    setState(() {
      _currentCard = nextCard;
      _currentKind = _CardKind.step;
    });
  }

  void _end() {
    bool won = false;
    if (_history.isNotEmpty) {
      final lastConsequence =
          _history.last['consequenceCard'] as Map<String, dynamic>?;
      won = lastConsequence?['is_win'] == true;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SimSummaryPage(
          pickedChoices: _history,
          collectedCards: _collected,
          won: won,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Sim'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                '${_collected.length}/8',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _currentCard == null
              ? const Center(child: Text('No cards found'))
              : _currentKind == _CardKind.step
                  ? _buildStepCard()
                  : _buildConsequenceCard(),
    );
  }

  Widget _buildStepCard() {
    final card = _currentCard!;
    final choices = card['choices'] as List? ?? [];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step ${card['step']}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(card['text'] as String),
          const SizedBox(height: 24),
          ...choices.map<Widget>((choice) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      _onStepChoice(choice as Map<String, dynamic>),
                  child: Text(choice['text'] as String),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildConsequenceCard() {
    final card = _currentCard!;
    final isTerminal = card['is_terminal'] == true;
    final isWin = card['is_win'] == true;

    final newCards = _history.isNotEmpty
        ? (_history.last['unlockedCards'] as List<InterventionCard>? ?? [])
        : <InterventionCard>[];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step ${card['step']} result',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(card['text'] as String),
          if (newCards.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Unlocked:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: newCards.map((c) => Chip(
                label: Text(c.label),
                backgroundColor: Colors.purple.shade100,
              )).toList(),
            ),
          ],
          const Spacer(),
          if (isTerminal)
            Text(
              isWin ? 'Case resolved successfully.' : 'Case ended here.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isWin ? Colors.green : Colors.red,
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isTerminal ? _end : _onConsequenceContinue,
              child: Text(isTerminal ? 'See Summary' : 'Continue'),
            ),
          ),
        ],
      ),
    );
  }
}