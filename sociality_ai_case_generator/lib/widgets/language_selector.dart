import 'package:flutter/material.dart';

import '../models/app_language.dart';
import 'flags.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  final AppLanguage selectedLanguage;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  bool _isExpanded = false;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  static const _options = [
    _LanguageOption(language: AppLanguage.dutch, flagType: _FlagType.nl),
    _LanguageOption(language: AppLanguage.english, flagType: _FlagType.uk),
  ];

  String _labelFor(AppLanguage optionLanguage, bool dutchUi) {
    switch (optionLanguage) {
      case AppLanguage.dutch:
        return dutchUi ? 'Nederlands' : 'Dutch';
      case AppLanguage.english:
        return dutchUi ? 'Engels' : 'English';
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleExpanded() {
    if (_isExpanded) {
      _removeOverlay();
      setState(() => _isExpanded = false);
      return;
    }

    _showOverlay();
    setState(() => _isExpanded = true);
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);

    final fieldContext = _fieldKey.currentContext;
    if (fieldContext == null) return;
    final renderBox = fieldContext.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final fieldSize = renderBox.size;

    final unselected = _options
        .asMap()
        .entries
        .where((entry) => entry.value.language != widget.selectedLanguage)
        .toList();
    final dutchUi = widget.selectedLanguage == AppLanguage.dutch;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _removeOverlay();
                  if (mounted) {
                    setState(() => _isExpanded = false);
                  }
                },
                child: const SizedBox.shrink(),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, fieldSize.height + 6),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: fieldSize.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD2D3D5),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x28000000),
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final option in unselected)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              if (!mounted) return;
                              setState(() {
                                _isExpanded = false;
                              });
                              widget.onLanguageChanged(option.value.language);
                              _removeOverlay();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _labelFor(option.value.language, dutchUi),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            color: const Color(0xFF1A1A1A),
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                  _Flag(flagType: option.value.flagType),
                                  const SizedBox(width: 36),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final selected = _options.firstWhere(
      (option) => option.language == widget.selectedLanguage,
      orElse: () => _options.first,
    );
    final dutchUi = widget.selectedLanguage == AppLanguage.dutch;
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        key: _fieldKey,
        decoration: BoxDecoration(
          color: const Color(0xFFD2D3D5),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x28000000),
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: _toggleExpanded,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _labelFor(selected.language, dutchUi),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: const Color(0xFF1A1A1A),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  _Flag(flagType: selected.flagType),
                  const SizedBox(width: 8),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 28,
                    color: const Color(0xFF707070),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _FlagType { nl, uk }

class _LanguageOption {
  const _LanguageOption({required this.language, required this.flagType});

  final AppLanguage language;
  final _FlagType flagType;
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
