import 'generated_case.dart';

class FallbackChoice {
  const FallbackChoice({
    required this.key,
    required this.text,
    required this.consequenceCardKey,
  });

  final String key;
  final String text;
  final String consequenceCardKey;

  factory FallbackChoice.fromJson(Map<String, dynamic> json) {
    return FallbackChoice(
      key: json['key'] as String,
      text: json['text'] as String,
      consequenceCardKey: json['consequenceCardKey'] as String,
    );
  }
}

class FallbackStepCard {
  const FallbackStepCard({
    required this.step,
    required this.scenarioText,
    required this.choices,
  });

  final int step;
  final String scenarioText;
  final List<FallbackChoice> choices;

  factory FallbackStepCard.fromJson(Map<String, dynamic> json) {
    final rawChoices = json['choices'] as List<dynamic>? ?? [];
    return FallbackStepCard(
      step: json['step'] as int,
      scenarioText: json['scenarioText'] as String,
      choices: rawChoices
          .map((c) => FallbackChoice.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FallbackConsequenceCard {
  const FallbackConsequenceCard({
    required this.key,
    required this.step,
    required this.consequenceText,
    required this.nextStep,
    required this.isEnding,
    required this.isWin,
  });

  final String key;
  final int step;
  final String consequenceText;
  final int? nextStep;
  final bool isEnding;
  final bool isWin;

  factory FallbackConsequenceCard.fromJson(Map<String, dynamic> json) {
    return FallbackConsequenceCard(
      key: json['key'] as String,
      step: json['step'] as int,
      consequenceText: json['consequenceText'] as String,
      nextStep: json['nextStep'] as int?,
      isEnding: (json['isEnding'] as bool?) ?? false,
      isWin: (json['isWin'] as bool?) ?? false,
    );
  }
}

class FallbackCase {
  const FallbackCase({
    required this.difficulty,
    required this.stepCards,
    required this.consequenceCards,
  });

  final String difficulty;
  final List<FallbackStepCard> stepCards;
  final List<FallbackConsequenceCard> consequenceCards;

  factory FallbackCase.fromJson(Map<String, dynamic> json) {
    final rawSteps = json['stepCards'] as List<dynamic>? ?? [];
    final rawConsequences = json['consequenceCards'] as List<dynamic>? ?? [];
    return FallbackCase(
      difficulty: (json['difficulty'] as String?) ?? 'medium',
      stepCards: rawSteps
          .map((s) => FallbackStepCard.fromJson(s as Map<String, dynamic>))
          .toList(),
      consequenceCards: rawConsequences
          .map((c) => FallbackConsequenceCard.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Temporary bridge to the current display page until the new layout is built.
  GeneratedCase toGeneratedCase() {
    return GeneratedCase(
      steps: stepCards
          .map(
            (card) => GeneratedCaseStep(
              index: card.step,
              title: 'Step ${card.step}',
              subtitle: card.scenarioText,
              details: card.choices
                  .map(
                    (c) => GeneratedStepDetail(
                      title: 'Choice ${c.key}',
                      body: c.text,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}
