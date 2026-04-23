import 'dart:math' as math;

import 'package:flutter/material.dart';

class CaseLoadingScreen extends StatefulWidget {
  const CaseLoadingScreen({super.key});

  @override
  State<CaseLoadingScreen> createState() => _CaseLoadingScreenState();
}

class _CaseLoadingScreenState extends State<CaseLoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 2300), () {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    });
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
                  'Loading your case',
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
