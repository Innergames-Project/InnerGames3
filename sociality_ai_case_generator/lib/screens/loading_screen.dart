import 'dart:async';

import 'package:flutter/material.dart';

import '../models/difficulty_level.dart';
import '../models/home_copy.dart';
import '../models/language_scope.dart';
import '../services/case_api_service.dart';
import '../services/fallback_case_service.dart';
import 'case_simulation_page.dart';

enum _LoadState { generating, failed, fallback }

class CaseLoadingScreen extends StatefulWidget {
  const CaseLoadingScreen({
    super.key,
    required this.difficulty,
    required this.prompt,
  });

  final DifficultyLevel difficulty;
  final String prompt;

  @override
  State<CaseLoadingScreen> createState() => _CaseLoadingScreenState();
}

class _CaseLoadingScreenState extends State<CaseLoadingScreen> {
  _LoadState _state = _LoadState.generating;
  String _apiError = '';
  int _stageIndex = 0;
  Timer? _stageTimer;

  @override
  void initState() {
    super.initState();
    _startStageTimer();
    _callApi();
  }

  @override
  void dispose() {
    _stageTimer?.cancel();
    super.dispose();
  }

  void _startStageTimer() {
    _stageTimer?.cancel();
    _stageIndex = 0;
    _stageTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted && _stageIndex < 3) {
        setState(() => _stageIndex++);
      }
    });
  }

  void _stopStageTimer() {
    _stageTimer?.cancel();
    _stageTimer = null;
  }

  Future<void> _callApi() async {
    setState(() {
      _state = _LoadState.generating;
      _apiError = '';
    });
    _startStageTimer();

    try {
      final generatedCase = await CaseApiService.generateCase(
        difficulty: widget.difficulty,
        prompt: widget.prompt,
      );
      if (!mounted) return;
      _stopStageTimer();

      if (generatedCase.steps.isEmpty) {
        final copy = HomeCopy.fromLanguage(LanguageScope.read(context));
        setState(() {
          _state = _LoadState.failed;
          _apiError = copy.loadingNoStepsError;
        });
        return;
      }

      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => CaseSimulationPage(generatedCase: generatedCase),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _stopStageTimer();
      setState(() {
        _state = _LoadState.failed;
        _apiError = e.toString();
      });
    }
  }

  Future<void> _loadFallback() async {
    setState(() => _state = _LoadState.fallback);
    try {
      final fallback = await FallbackCaseService.load();
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) =>
              CaseSimulationPage(generatedCase: fallback.toGeneratedCase()),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 6),
          backgroundColor: const Color(0xFFB00020),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final copy = HomeCopy.fromLanguage(LanguageScope.of(context));
    final stages = [
      copy.generatingStage1,
      copy.generatingStage2,
      copy.generatingStage3,
      copy.generatingStage4,
    ];
    final progress = 0.10 + _stageIndex * 0.22;

    return PopScope(
      canPop: false,
      child: Scaffold(
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
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/icon/icon.png', width: 88),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
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
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                        child: switch (_state) {
                          _LoadState.generating => _GeneratingBody(
                            stages: stages,
                            stageIndex: _stageIndex,
                            progress: progress,
                          ),
                          _LoadState.failed => _FailedBody(
                            copy: copy,
                            message: _apiError,
                            onRetry: _callApi,
                            onBack: () => Navigator.of(context).pop(),
                            onUseSample: _loadFallback,
                          ),
                          _LoadState.fallback => _FallbackBody(copy: copy),
                        },
                      ),
                    ],
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

// ── Generating state ──────────────────────────────────────────────────────────

class _GeneratingBody extends StatelessWidget {
  const _GeneratingBody({
    required this.stages,
    required this.stageIndex,
    required this.progress,
  });

  final List<String> stages;
  final int stageIndex;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: const Color(0xFFE02D91),
            fontWeight: FontWeight.w800,
            fontSize: 44,
            height: 1,
          ),
        ),
        Text(
          'Generating…',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: const Color(0xFF333333),
            fontWeight: FontWeight.w700,
            fontSize: 28,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 28),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.08, end: progress),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOut,
            builder: (_, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 7,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFE02D91)),
            ),
          ),
        ),
        const SizedBox(height: 14),
        // Stage label
        Row(
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFE02D91),
              ),
            ),
            const SizedBox(width: 10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: Text(
                stages[stageIndex],
                key: ValueKey(stageIndex),
                style: const TextStyle(
                  color: Color(0xFF555555),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Step dots
        Row(
          children: List.generate(4, (i) {
            final active = i <= stageIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 6),
              width: active ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFFE02D91)
                    : const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── Failed state ──────────────────────────────────────────────────────────────

class _FailedBody extends StatelessWidget {
  const _FailedBody({
    required this.copy,
    required this.message,
    required this.onRetry,
    required this.onBack,
    required this.onUseSample,
  });

  final HomeCopy copy;
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onBack;
  final VoidCallback onUseSample;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEF3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: Color(0xFFE02D91),
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              copy.generationFailed,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F3),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFFCCD6)),
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: Color(0xFF7A1A2E),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(copy.retryGeneration),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE02D91),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Back'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF555555),
                    side: const BorderSide(color: Color(0xFFCCCCCC)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton(
            onPressed: onUseSample,
            child: Text(
              copy.useSampleCase,
              style: const TextStyle(
                color: Color(0xFF888888),
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Fallback state ────────────────────────────────────────────────────────────

class _FallbackBody extends StatelessWidget {
  const _FallbackBody({required this.copy});
  final HomeCopy copy;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          copy.loadingFallbackTitle,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: const LinearProgressIndicator(
            minHeight: 7,
            backgroundColor: Color(0xFFE0E0E0),
            valueColor: AlwaysStoppedAnimation(Color(0xFFE02D91)),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          copy.loadingFallbackSubtitle,
          style: const TextStyle(color: Color(0xFF888888), fontSize: 13),
        ),
      ],
    );
  }
}
