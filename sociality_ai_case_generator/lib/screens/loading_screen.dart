import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/difficulty_level.dart';
import '../models/home_copy.dart';
import '../models/language_scope.dart';
import '../services/case_api_service.dart';
import 'case_simulation_page.dart';

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
  @override
  void initState() {
    super.initState();
    _callApi();
  }

  Future<void> _callApi() async {
    try {
      final generatedCase = await CaseApiService.generateCase(
        difficulty: widget.difficulty,
        prompt: widget.prompt,
      );

      if (!mounted) return;

      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => CaseSimulationPage(generatedCase: generatedCase),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      Navigator.of(context).pop();

      final copy = HomeCopy.fromLanguage(LanguageScope.read(context));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${copy.loadingErrorPrefix}: ${e.toString()}'),
          duration: const Duration(seconds: 6),
          backgroundColor: const Color(0xFFB00020),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFE5E5E5),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/icon/icon.png', width: 240),
                const SizedBox(height: 34),
                Text(
                  HomeCopy.fromLanguage(LanguageScope.of(context)).loadingTitle,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: const Color(0xFFE02D91),
                    fontSize: 52,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 54),
                const _SocialityRingLoader(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialityRingLoader extends StatefulWidget {
  const _SocialityRingLoader();

  @override
  State<_SocialityRingLoader> createState() => _SocialityRingLoaderState();
}

class _SocialityRingLoaderState extends State<_SocialityRingLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const int _dotCount = 8;
  static const double _radius = 34;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      height: 104,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: List.generate(_dotCount, (index) {
              final progress = (_controller.value + (index / _dotCount)) % 1;
              final angle = 2 * math.pi * (index / _dotCount);
              final dx = math.cos(angle) * _radius;
              final dy = math.sin(angle) * _radius;
              final scale = 0.58 + (0.42 * progress);
              final opacity = 0.24 + (0.76 * progress);

              return Transform.translate(
                offset: Offset(dx, dy),
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 16 * scale,
                    height: 16 * scale,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE02D91),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x45000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
