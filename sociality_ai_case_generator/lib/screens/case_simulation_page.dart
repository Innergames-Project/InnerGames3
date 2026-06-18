import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/generated_case.dart';
import '../models/home_copy.dart';
import '../models/language_scope.dart';
import '../widgets/how_it_works_overlay.dart';
import '../widgets/language_selector.dart';
import 'download_success_page.dart';

class CaseSimulationPage extends StatefulWidget {
  const CaseSimulationPage({super.key, required this.generatedCase});

  final GeneratedCase generatedCase;

  @override
  State<CaseSimulationPage> createState() => _CaseSimulationPageState();
}

class _CaseSimulationPageState extends State<CaseSimulationPage> {
  late List<GeneratedCaseStep> _steps;

  @override
  void initState() {
    super.initState();
    _steps = List.of(widget.generatedCase.steps);
  }

  void _saveStep(int index, String newScenario, List<String> newChoiceBodies) {
    setState(() {
      final old = _steps[index];
      _steps[index] = GeneratedCaseStep(
        index: old.index,
        title: old.title,
        subtitle: newScenario,
        details: List.generate(
          old.details.length,
          (i) => GeneratedStepDetail(
            title: old.details[i].title,
            body: i < newChoiceBodies.length
                ? newChoiceBodies[i]
                : old.details[i].body,
          ),
        ),
      );
    });
  }

  void _showEditSheet(BuildContext context, int index) {
    final copy = HomeCopy.fromLanguage(LanguageScope.read(context));
    final step = _steps[index];
    final scenarioCtrl = TextEditingController(text: step.subtitle);
    final choiceCtrls =
        step.details.map((d) => TextEditingController(text: d.body)).toList();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: _EditStepSheet(
            step: step,
            copy: copy,
            scenarioCtrl: scenarioCtrl,
            choiceCtrls: choiceCtrls,
            onSave: (newScenario, newBodies) {
              _saveStep(index, newScenario, newBodies);
              Navigator.of(ctx).pop();
            },
            onCancel: () => Navigator.of(ctx).pop(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = LanguageScope.of(context);
    final copy = HomeCopy.fromLanguage(language);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/app-background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.10),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.18),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 4),
                  // Top bar — back arrow + help + language toggle
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => showHowItWorksOverlay(context),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.question_mark,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 156,
                        child: LanguageSelector(
                          selectedLanguage: language,
                          onLanguageChanged: (lang) =>
                              LanguageScope.notifierOf(context).value = lang,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Main card
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F7),
                        borderRadius: BorderRadius.circular(38),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x73000000),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Title
                            Text(
                              copy.caseReviewTitle,
                              style: const TextStyle(
                                color: Color(0xFFE02D91),
                                fontWeight: FontWeight.w700,
                                fontSize: 26,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              copy.tapToSeeChoices,
                              style: const TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Step cards
                            Expanded(
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemCount: _steps.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  return _FlipStepCard(
                                    step: _steps[index],
                                    copy: copy,
                                    onEdit: () =>
                                        _showEditSheet(context, index),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Start simulation button
                            SizedBox(
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE02D91),
                                  foregroundColor: Colors.white,
                                  elevation: 5,
                                  shadowColor: const Color(0x55000000),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                child: Text(copy.startCaseSimulation),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Download button
                            SizedBox(
                              height: 60,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const DownloadSuccessPage(),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFE02D91),
                                  side: const BorderSide(
                                    color: Color(0xFFE02D91),
                                    width: 2.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                child: Text(copy.downloadCase),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Flip card (fixed height via Stack + maintainSize) ─────────────────────────

class _FlipStepCard extends StatefulWidget {
  const _FlipStepCard({
    required this.step,
    required this.copy,
    required this.onEdit,
  });

  final GeneratedCaseStep step;
  final HomeCopy copy;
  final VoidCallback onEdit;

  @override
  State<_FlipStepCard> createState() => _FlipStepCardState();
}

class _FlipStepCardState extends State<_FlipStepCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 440),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _flip() {
    if (_ctrl.isDismissed) {
      _ctrl.forward();
    } else if (_ctrl.isCompleted) {
      _ctrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final value = _ctrl.value;
          final showFront = value <= 0.5;
          // Front rotates 0 → π; back enters from -π → 0
          final frontAngle = value * math.pi;
          final backAngle = (value - 1.0) * math.pi;

          return Stack(
            children: [
              // Back face — always in tree to fix the card height
              Visibility(
                visible: !showFront,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(backAngle),
                  child: _CardBack(step: widget.step, copy: widget.copy),
                ),
              ),
              // Front face — always in tree to fix the card height
              Visibility(
                visible: showFront,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(frontAngle),
                  child: _CardFront(
                    step: widget.step,
                    copy: widget.copy,
                    onEdit: widget.onEdit,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Card front ────────────────────────────────────────────────────────────────

class _CardFront extends StatelessWidget {
  const _CardFront({
    required this.step,
    required this.copy,
    required this.onEdit,
  });

  final GeneratedCaseStep step;
  final HomeCopy copy;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
            decoration: const BoxDecoration(
              color: Color(0xFFE02D91),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${step.index}',
                      style: const TextStyle(
                        color: Color(0xFFE02D91),
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  copy.stepLabel.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                  ),
                ),
                const Spacer(),
                // Edit button
                GestureDetector(
                  onTap: onEdit,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            copy.editManually,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Scenario body
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 13, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.subtitle,
                  style: const TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 13.5,
                    height: 1.58,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      copy.tapToSeeChoices,
                      style: const TextStyle(
                        color: Color(0xFFBBBBBB),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.flip_camera_android_rounded,
                      color: Color(0xFFCCCCCC),
                      size: 15,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card back ─────────────────────────────────────────────────────────────────

class _CardBack extends StatelessWidget {
  const _CardBack({required this.step, required this.copy});

  final GeneratedCaseStep step;
  final HomeCopy copy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2C1A3E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: const BoxDecoration(
              color: Color(0xFF1A0D2B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Text(
                  copy.choicesLabel.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                  ),
                ),
                const Spacer(),
                Text(
                  copy.tapToFlipBack,
                  style: const TextStyle(
                    color: Color(0xFF9999AA),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.flip_camera_android_rounded,
                  color: Color(0xFF9999AA),
                  size: 14,
                ),
              ],
            ),
          ),
          // Choices
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 13, 16, 15),
            child: Column(
              children: [
                for (int i = 0; i < step.details.length; i++) ...[
                  _ChoiceRow(detail: step.details[i]),
                  if (i != step.details.length - 1)
                    const SizedBox(height: 11),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Choice row ────────────────────────────────────────────────────────────────

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({required this.detail});
  final GeneratedStepDetail detail;

  @override
  Widget build(BuildContext context) {
    final parts = detail.title.split(' ');
    final letter = parts.isNotEmpty ? parts.last : '?';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFA0BD00),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Center(
            child: Text(
              letter,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
                height: 1,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              detail.body,
              style: const TextStyle(
                color: Color(0xFFE8E8E8),
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Edit sheet ────────────────────────────────────────────────────────────────

class _EditStepSheet extends StatelessWidget {
  const _EditStepSheet({
    required this.step,
    required this.copy,
    required this.scenarioCtrl,
    required this.choiceCtrls,
    required this.onSave,
    required this.onCancel,
  });

  final GeneratedCaseStep step;
  final HomeCopy copy;
  final TextEditingController scenarioCtrl;
  final List<TextEditingController> choiceCtrls;
  final void Function(String scenario, List<String> bodies) onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sheet handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD7D7D7),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFE02D91),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${step.index}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${copy.stepLabel} ${step.index}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Scenario field
          Text(
            copy.editScenarioLabel,
            style: const TextStyle(
              color: Color(0xFF444444),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          _editField(scenarioCtrl, minLines: 3, maxLines: 6),
          const SizedBox(height: 18),
          // Choice fields
          for (int i = 0; i < choiceCtrls.length; i++) ...[
            Text(
              '${copy.choicesLabel} ${step.details[i].title.split(' ').last}',
              style: const TextStyle(
                color: Color(0xFF444444),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            _editField(choiceCtrls[i], minLines: 2, maxLines: 4),
            const SizedBox(height: 14),
          ],
          const SizedBox(height: 6),
          // Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => onSave(
                      scenarioCtrl.text,
                      choiceCtrls.map((c) => c.text).toList(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE02D91),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    child: Text(copy.saveChanges),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF555555),
                      side: const BorderSide(color: Color(0xFFCCCCCC)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(copy.cancelButton),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _editField(
    TextEditingController ctrl, {
    required int minLines,
    required int maxLines,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: ctrl,
        minLines: minLines,
        maxLines: maxLines,
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(
          color: Color(0xFF1A1A1A),
          fontSize: 14,
          height: 1.5,
        ),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(14),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
