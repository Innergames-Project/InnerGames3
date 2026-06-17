class GeneratedStepDetail {
  const GeneratedStepDetail({required this.title, required this.body});

  final String title;
  final String body;

  factory GeneratedStepDetail.fromJson(Map<String, dynamic> json) {
    return GeneratedStepDetail(
      title: (json['title'] as String?) ?? '',
      body: (json['body'] as String?) ?? (json['content'] as String?) ?? '',
    );
  }
}

class GeneratedCaseStep {
  const GeneratedCaseStep({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.details,
  });

  final int index;
  final String title;
  final String subtitle;
  final List<GeneratedStepDetail> details;

  factory GeneratedCaseStep.fromJson(Map<String, dynamic> json, int fallbackIndex) {
    final rawDetails = json['details'] as List<dynamic>? ?? [];
    return GeneratedCaseStep(
      index: (json['index'] as int?) ?? fallbackIndex,
      title: (json['title'] as String?) ?? 'Step $fallbackIndex',
      subtitle: (json['subtitle'] as String?) ?? (json['description'] as String?) ?? '',
      details: rawDetails
          .map((d) => GeneratedStepDetail.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}

class GeneratedCase {
  const GeneratedCase({required this.steps});

  final List<GeneratedCaseStep> steps;

  factory GeneratedCase.fromJson(Map<String, dynamic> json) {
    final rawSteps =
        (json['steps'] as List<dynamic>?) ?? (json['case_steps'] as List<dynamic>?) ?? [];
    return GeneratedCase(
      steps: List<GeneratedCaseStep>.generate(
        rawSteps.length,
        (i) => GeneratedCaseStep.fromJson(
          rawSteps[i] as Map<String, dynamic>,
          i + 1,
        ),
      ),
    );
  }
}
