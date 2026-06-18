class GeneratedStepDetail {
  const GeneratedStepDetail({required this.title, required this.body});

  final String title;
  final String body;

  factory GeneratedStepDetail.fromJson(Map<String, dynamic> json) {
    // API format: {title, body} — fallback JSON format: {key, text}
    final key = json['key'] as String?;
    return GeneratedStepDetail(
      title: (json['title'] as String?) ?? (key != null ? 'Choice $key' : ''),
      body: (json['body'] as String?) ??
          (json['content'] as String?) ??
          (json['text'] as String?) ??
          '',
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
    // Accept both "details" (API) and "choices" (fallback JSON / some API variants)
    final rawDetails = (json['details'] as List<dynamic>?) ??
        (json['choices'] as List<dynamic>?) ??
        [];
    return GeneratedCaseStep(
      // Accept "index" (API) or "step" (fallback JSON)
      index: (json['index'] as int?) ?? (json['step'] as int?) ?? fallbackIndex,
      title: (json['title'] as String?) ?? 'Step $fallbackIndex',
      // Accept "subtitle" (API), "scenarioText" (fallback JSON), or "description"
      subtitle: (json['subtitle'] as String?) ??
          (json['scenarioText'] as String?) ??
          (json['description'] as String?) ??
          '',
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
    // Try every plausible key name the backend might use
    final rawSteps = (json['steps'] as List<dynamic>?) ??
        (json['case_steps'] as List<dynamic>?) ??
        (json['stepCards'] as List<dynamic>?) ??
        (json['caseSteps'] as List<dynamic>?) ??
        [];
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
