import 'package:flutter/material.dart';

import 'models.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  final AppLanguage selectedLanguage;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.55), width: 1.4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FlagSwitchButton(
            flagType: _FlagType.nl,
            selected: selectedLanguage == AppLanguage.dutch,
            onTap: () => onLanguageChanged(AppLanguage.dutch),
            semanticLabel: 'Switch to Dutch',
          ),
          const SizedBox(width: 4),
          _FlagSwitchButton(
            flagType: _FlagType.uk,
            selected: selectedLanguage == AppLanguage.english,
            onTap: () => onLanguageChanged(AppLanguage.english),
            semanticLabel: 'Switch to English',
          ),
        ],
      ),
    );
  }
}

enum _FlagType { nl, uk }

class _FlagSwitchButton extends StatelessWidget {
  const _FlagSwitchButton({
    required this.flagType,
    required this.selected,
    required this.onTap,
    required this.semanticLabel,
  });

  final _FlagType flagType;
  final bool selected;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected ? Colors.white : Colors.transparent;
    final borderColor = selected ? Colors.white : Colors.transparent;

    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      child: Tooltip(
        message: semanticLabel,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: selected
                    ? const [
                        BoxShadow(
                          color: Color(0x23000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : const [],
              ),
              child: _Flag(flagType: flagType),
            ),
          ),
        ),
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  const _Flag({required this.flagType});

  final _FlagType flagType;

  @override
  Widget build(BuildContext context) {
    if (flagType == _FlagType.uk) {
      return const UkFlag();
    }

    return const NetherlandsFlag();
  }
}

class NetherlandsFlag extends StatelessWidget {
  const NetherlandsFlag({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: CustomPaint(
        size: const Size(32, 22),
        painter: _NetherlandsFlagPainter(),
      ),
    );
  }
}

class UkFlag extends StatelessWidget {
  const UkFlag({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: CustomPaint(
        size: const Size(32, 22),
        painter: _UkFlagPainter(),
      ),
    );
  }
}

class _NetherlandsFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stripeHeight = size.height / 3;
    final paint = Paint();

    paint.color = const Color(0xFFA61C2F);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, stripeHeight), paint);

    paint.color = Colors.white;
    canvas.drawRect(
      Rect.fromLTWH(0, stripeHeight, size.width, stripeHeight),
      paint,
    );

    paint.color = const Color(0xFF21468B);
    canvas.drawRect(
      Rect.fromLTWH(0, stripeHeight * 2, size.width, stripeHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _UkFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()..color = const Color(0xFF012169);
    canvas.drawRect(Offset.zero & size, basePaint);

    final whitePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.height * 0.22
      ..strokeCap = StrokeCap.square;

    final whiteCenter = Offset(size.width / 2, size.height / 2);
    canvas.drawLine(Offset.zero, whiteCenter, whitePaint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), whitePaint);
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), whitePaint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), whitePaint);

    final redCenter = Paint()
      ..color = const Color(0xFFC8102E)
      ..strokeWidth = size.height * 0.08
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(Offset.zero, whiteCenter, redCenter);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), redCenter);
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), redCenter);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), redCenter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
