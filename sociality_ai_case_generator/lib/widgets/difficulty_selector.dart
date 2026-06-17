import 'package:flutter/material.dart';

import '../models/difficulty_level.dart';

class DifficultySelector extends StatelessWidget {
  const DifficultySelector({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.labelEasy,
    required this.labelMedium,
    required this.labelHard,
  });

  final DifficultyLevel selected;
  final ValueChanged<DifficultyLevel> onChanged;
  final String labelEasy;
  final String labelMedium;
  final String labelHard;

  static const _selectedColors = {
    DifficultyLevel.easy: Color(0xFF4CAF50),
    DifficultyLevel.medium: Color(0xFFA66936),
    DifficultyLevel.hard: Color(0xFFE02D91),
  };

  @override
  Widget build(BuildContext context) {
    final options = [
      (DifficultyLevel.easy, labelEasy),
      (DifficultyLevel.medium, labelMedium),
      (DifficultyLevel.hard, labelHard),
    ];

    return Row(
      children: [
        for (int i = 0; i < options.length; i++) ...[
          if (i != 0) const SizedBox(width: 10),
          Expanded(
            child: _DifficultyButton(
              label: options[i].$2,
              level: options[i].$1,
              selectedColor: _selectedColors[options[i].$1]!,
              isSelected: selected == options[i].$1,
              onTap: () => onChanged(options[i].$1),
            ),
          ),
        ],
      ],
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  const _DifficultyButton({
    required this.label,
    required this.level,
    required this.selectedColor,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final DifficultyLevel level;
  final Color selectedColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: 52,
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : const Color(0xFFD2D3D5),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? selectedColor.withValues(alpha: 0.38)
                  : const Color(0x28000000),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF3A3A3A),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
