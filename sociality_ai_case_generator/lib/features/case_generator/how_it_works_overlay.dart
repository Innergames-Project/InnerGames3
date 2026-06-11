import 'package:flutter/material.dart';

import 'models.dart';

void showHowItWorksOverlay(BuildContext context, AppLanguage language) {
  final copy = HowItWorksCopy.fromLanguage(language);

  showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: copy.barrierLabel,
    barrierColor: const Color(0xA6000000),
    transitionDuration: const Duration(milliseconds: 170),
    pageBuilder: (context, animation, secondaryAnimation) {
      return _HowItWorksOverlay(copy: copy);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(
        opacity: fade,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.985, end: 1).animate(fade),
          child: child,
        ),
      );
    },
  );
}

class _HowItWorksOverlay extends StatelessWidget {
  const _HowItWorksOverlay({required this.copy});

  final HowItWorksCopy copy;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 560, maxHeight: maxHeight),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x8A000000),
                      blurRadius: 8,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    copy.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          color: Colors.black,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w700,
                                          height: 1.1,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    copy.subtitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: const Color(0xFF666666),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          height: 1.2,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Semantics(
                              button: true,
                              label: copy.closeButtonLabel,
                              child: Tooltip(
                                message: copy.closeButtonLabel,
                                child: IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Color(0xFFE02D91),
                                    size: 28,
                                  ),
                                  constraints: const BoxConstraints(
                                    minHeight: 44,
                                    minWidth: 44,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _HowItWorksCard(step: copy.steps[0]),
                        const SizedBox(height: 12),
                        _HowItWorksCard(step: copy.steps[1]),
                        const SizedBox(height: 12),
                        _HowItWorksCard(step: copy.steps[2]),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE02D91),
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: const Color(0x45000000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Text(
                              copy.gotItLabel,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
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
        ),
      ));
  }
}

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard({required this.step});

  final HowItWorksStepCopy step;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFD7DCB1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(child: Icon(step.icon, color: Colors.white, size: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${step.number}. ${step.title}',
                  style: const TextStyle(
                    color: Color(0xFF101010),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  step.description,
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
