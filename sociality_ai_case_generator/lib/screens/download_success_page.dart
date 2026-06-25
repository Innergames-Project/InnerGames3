import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../models/generated_case.dart';
import '../models/home_copy.dart';
import '../models/language_scope.dart';
import '../simulation.dart';
import '../widgets/how_it_works_overlay.dart';
import '../widgets/language_selector.dart';

class DownloadSuccessPage extends StatefulWidget {
  final List<GeneratedCaseStep>? steps;
  const DownloadSuccessPage({super.key, this.steps});

  @override
  State<DownloadSuccessPage> createState() => _DownloadSuccessPageState();
}

class _DownloadSuccessPageState extends State<DownloadSuccessPage> {
  late ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 4));
    _confetti.play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
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
              alignment: Alignment.topCenter,
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
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => showHowItWorksOverlay(context),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.question_mark,
                            color: Colors.white,
                            size: 28,
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
                ),
                const SizedBox(height: 18),
                // Main card
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                    child: Container(
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
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(22, 30, 22, 26),
                        child: Column(
                          children: [
                            // Success checkmark icon
                            Container(
                              width: 78,
                              height: 78,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE02D91),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 46,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              copy.downloadSuccessTitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFE02D91),
                                fontSize: 38,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              copy.downloadSuccessBody,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF737373),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                height: 1.45,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 22),
                              child: Divider(
                                color: Color(0xFFDDDDDD),
                                thickness: 1,
                                height: 1,
                              ),
                            ),
                            // "Try your case" promo section
                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.fromLTRB(18, 18, 18, 18),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFEEF4),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: const Color(0xFFFFCCDC),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE02D91),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.sports_esports_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          copy.tryCaseTitle,
                                          style: const TextStyle(
                                            color: Color(0xFF1A1A1A),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    copy.tryCaseBody,
                                    style: const TextStyle(
                                      color: Color(0xFF555555),
                                      fontSize: 14,
                                      height: 1.45,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 58,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => QuizScreen(
                                              steps: widget.steps,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFE02D91),
                                        foregroundColor: Colors.white,
                                        elevation: 5,
                                        shadowColor:
                                            const Color(0x55000000),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      child: Text(copy.startCaseSimulation),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              height: 58,
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context)
                                    .popUntil((route) => route.isFirst),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFE02D91),
                                  side: const BorderSide(
                                    color: Color(0xFFE02D91),
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                child: Text(copy.generateAnotherCase),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Confetti fired from the top centre of the screen
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              blastDirection: pi / 2, // straight down as base direction
              emissionFrequency: 0.07,
              numberOfParticles: 18,
              gravity: 0.18,
              shouldLoop: false,
              colors: const [
                Color(0xFFE02D91),
                Color(0xFF7A0E48),
                Color(0xFFA0BD00),
                Color(0xFFFFCCDC),
                Colors.white,
                Color(0xFFFF6EC7),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
