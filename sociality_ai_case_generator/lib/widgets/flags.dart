import 'package:flutter/material.dart';

class NetherlandsFlag extends StatelessWidget {
  const NetherlandsFlag({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: CustomPaint(
        size: const Size(36, 24),
        painter: _NetherlandsFlagPainter(),
      ),
    );
  }
}

class _NetherlandsFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stripeHeight = size.height / 3;

    final topPaint = Paint()..color = const Color(0xFFAE1C28);
    final middlePaint = Paint()..color = const Color(0xFFFFFFFF);
    final bottomPaint = Paint()..color = const Color(0xFF21468B);
    final borderPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, stripeHeight), topPaint);
    canvas.drawRect(
      Rect.fromLTWH(0, stripeHeight, size.width, stripeHeight),
      middlePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, stripeHeight * 2, size.width, stripeHeight),
      bottomPaint,
    );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class UkFlag extends StatelessWidget {
  const UkFlag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Color(0xFF012169)),
          Align(
            child: Transform.rotate(
              angle: 0.56,
              child: Container(width: 44, height: 5, color: Colors.white),
            ),
          ),
          Align(
            child: Transform.rotate(
              angle: -0.56,
              child: Container(width: 44, height: 5, color: Colors.white),
            ),
          ),
          Align(
            child: Transform.rotate(
              angle: 0.56,
              child: Container(
                width: 44,
                height: 2.5,
                color: const Color(0xFFC8102E),
              ),
            ),
          ),
          Align(
            child: Transform.rotate(
              angle: -0.56,
              child: Container(
                width: 44,
                height: 2.5,
                color: const Color(0xFFC8102E),
              ),
            ),
          ),
          Align(child: Container(width: 36, height: 7, color: Colors.white)),
          Align(child: Container(width: 7, height: 24, color: Colors.white)),
          Align(
            child: Container(
              width: 36,
              height: 3.5,
              color: const Color(0xFFC8102E),
            ),
          ),
          Align(
            child: Container(
              width: 3.5,
              height: 24,
              color: const Color(0xFFC8102E),
            ),
          ),
        ],
      ),
    );
  }
}
