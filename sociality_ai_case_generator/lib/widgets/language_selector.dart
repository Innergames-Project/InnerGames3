import 'package:flutter/material.dart';

import '../models/app_language.dart';
import 'flags.dart';

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
      height: 60,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFD2D3D5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          _FlagOption(
            flag: const NetherlandsFlag(),
            label: 'NL',
            isSelected: selectedLanguage == AppLanguage.dutch,
            onTap: () => onLanguageChanged(AppLanguage.dutch),
          ),
          _FlagOption(
            flag: const UkFlag(),
            label: 'EN',
            isSelected: selectedLanguage == AppLanguage.english,
            onTap: () => onLanguageChanged(AppLanguage.english),
          ),
        ],
      ),
    );
  }
}

class _FlagOption extends StatelessWidget {
  const _FlagOption({
    required this.flag,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final Widget flag;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: isSelected ? 1.0 : 0.45,
                duration: const Duration(milliseconds: 180),
                child: flag,
              ),
              const SizedBox(width: 10),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  color:
                      isSelected ? const Color(0xFF111111) : const Color(0xFF888888),
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 15,
                  letterSpacing: 0.4,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
