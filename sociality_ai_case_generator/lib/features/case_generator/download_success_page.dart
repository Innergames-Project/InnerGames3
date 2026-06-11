import 'package:flutter/material.dart';

import 'how_it_works_overlay.dart';
import 'language_selector.dart';
import 'models.dart';

class DownloadSuccessPage extends StatelessWidget {
  const DownloadSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: caseGeneratorLanguage,
      builder: (context, selectedLanguage, child) {
        final copy = DownloadSuccessCopy.fromLanguage(selectedLanguage);

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
                    color: const Color(0xFFA66936).withValues(alpha: 0.48),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: Semantics(
                              button: true,
                              label: MaterialLocalizations.of(context)
                                  .backButtonTooltip,
                              child: InkResponse(
                                onTap: () => Navigator.of(context).pop(),
                                radius: 28,
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Semantics(
                                button: true,
                                label: copy.helpButtonLabel,
                                child: Tooltip(
                                  message: copy.helpButtonLabel,
                                  child: InkResponse(
                                    onTap: () => showHowItWorksOverlay(
                                      context,
                                      selectedLanguage,
                                    ),
                                    radius: 30,
                                    child: Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.question_mark,
                                        color: Colors.white,
                                        size: 33,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              LanguageSelector(
                                selectedLanguage: selectedLanguage,
                                onLanguageChanged: (language) {
                                  caseGeneratorLanguage.value = language;
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7E7E7),
                            borderRadius: BorderRadius.circular(48),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x60000000),
                                blurRadius: 8,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(18, 30, 18, 18),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    copy.downloadSuccessfulTitle,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          color: const Color(0xFFE02D91),
                                          fontSize: 62,
                                          fontWeight: FontWeight.w700,
                                          height: 1.06,
                                        ),
                                  ),
                                  const SizedBox(height: 26),
                                  Text(
                                    copy.downloadDescription,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: const Color(0xFF6E6E6E),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          height: 1.14,
                                        ),
                                  ),
                                  const SizedBox(height: 46),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.fromLTRB(
                                      18,
                                      18,
                                      18,
                                      20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD7DCB1),
                                      borderRadius: BorderRadius.circular(26),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x42000000),
                                          blurRadius: 6,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          copy.tryYourCaseTitle,
                                          style: const TextStyle(
                                            color: Color(0xFF101010),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          copy.tryYourCaseDescription,
                                          style: const TextStyle(
                                            color: Color(0xFF666666),
                                            fontSize: 21,
                                            height: 1.13,
                                          ),
                                        ),
                                        const SizedBox(height: 22),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 66,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushNamed('/start');
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFE02D91,
                                              ),
                                              foregroundColor: Colors.white,
                                              elevation: 5,
                                              shadowColor:
                                                  const Color(0x55000000),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                              ),
                                            ),
                                            child: Text(
                                              copy.startCaseSimulation,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 66,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed('/case-simulation');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFE02D91),
                                        foregroundColor: Colors.white,
                                        elevation: 5,
                                        shadowColor: const Color(0x55000000),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                        ),
                                      ),
                                      child: Text(
                                        copy.generateAnotherCase,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
