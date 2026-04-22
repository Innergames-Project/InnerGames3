import 'package:flutter/material.dart';

void main() {
  runApp(const CaseGeneratorApp());
}

enum AppLanguage { dutch, english }

class HomeCopy {
  const HomeCopy({
    required this.welcomeTitle,
    required this.subtitle,
    required this.selectLanguageTitle,
    required this.selectLanguageHint,
    required this.generateCase,
    required this.uploadHint,
    required this.supportedFormats,
  });

  final String welcomeTitle;
  final String subtitle;
  final String selectLanguageTitle;
  final String selectLanguageHint;
  final String generateCase;
  final String uploadHint;
  final String supportedFormats;

  static HomeCopy fromLanguage(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return const HomeCopy(
          welcomeTitle: 'Welcome to the case generator',
          subtitle:
              'Upload your case document and\nselect your preferred language',
          selectLanguageTitle: 'Select language',
          selectLanguageHint:
              'Choose the language for your generated\ncase content',
          generateCase: 'Generate case',
          uploadHint: 'Click to browse, or drag and drop your file here',
          supportedFormats: 'Supported formats: Images, PDF, DOCX, TXT',
        );
      case AppLanguage.dutch:
        return const HomeCopy(
          welcomeTitle: 'Welkom bij de casusgenerator',
          subtitle: 'Upload je casusdocument en\nselecteer je voorkeurstaal',
          selectLanguageTitle: 'Selecteer taal',
          selectLanguageHint:
              'Kies de taal voor je gegenereerde\ncasusinhoud',
          generateCase: 'Genereer casus',
          uploadHint: 'Klik om te bladeren, of sleep je bestand hierheen',
          supportedFormats: 'Ondersteunde formaten: Afbeeldingen, PDF, DOCX, TXT',
        );
    }
  }
}

class CaseGeneratorApp extends StatelessWidget {
  const CaseGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Case Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0xFF181A1F),
      ),
      home: const CaseGeneratorHomePage(),
    );
  }
}

class CaseGeneratorHomePage extends StatefulWidget {
  const CaseGeneratorHomePage({super.key});

  @override
  State<CaseGeneratorHomePage> createState() => _CaseGeneratorHomePageState();
}

class _CaseGeneratorHomePageState extends State<CaseGeneratorHomePage> {
  AppLanguage _selectedLanguage = AppLanguage.dutch;

  @override
  Widget build(BuildContext context) {
    final copy = HomeCopy.fromLanguage(_selectedLanguage);
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomSpacing = (screenHeight * 0.06).clamp(32.0, 72.0).toDouble();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/app-background.png',
              fit: BoxFit.cover,
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.question_mark,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
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
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 28, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            copy.welcomeTitle,
                            style:
                                Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: const Color(0xFFE23198),
                              fontWeight: FontWeight.w700,
                              fontSize: 40,
                              height: 1.14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            copy.subtitle,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: const Color(0xFF737373),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  height: 1.18,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 28),
                          UploadDropzone(
                            uploadHint: copy.uploadHint,
                            supportedFormats: copy.supportedFormats,
                          ),
                          const SizedBox(height: 26),
                          Text(
                            copy.selectLanguageTitle,
                            style:
                                Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: const Color(0xFF111111),
                              fontWeight: FontWeight.w500,
                              fontSize: 29,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            copy.selectLanguageHint,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: const Color(0xFF737373),
                                  fontSize: 17,
                                  height: 1.12,
                                ),
                          ),
                          const SizedBox(height: 18),
                          LanguageSelector(
                            selectedLanguage: _selectedLanguage,
                            onLanguageChanged: (language) {
                              setState(() => _selectedLanguage = language);
                            },
                          ),
                          SizedBox(height: bottomSpacing),
                          SizedBox(
                            height: 72,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE62994),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 6,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                              ),
                              child: Text(copy.generateCase),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UploadDropzone extends StatelessWidget {
  const UploadDropzone({
    super.key,
    required this.uploadHint,
    required this.supportedFormats,
  });

  final String uploadHint;
  final String supportedFormats;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x21000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: CustomPaint(
        painter: DashedRoundRectPainter(
          color: const Color(0xFF9A9A9A),
          strokeWidth: 1.6,
          radius: 30,
          dashLength: 8,
          gapLength: 7,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF4D4D4D),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.upload, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  uploadHint,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF4E4E4E),
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  supportedFormats,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF7B7B7B),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
              child: Container(width: 44, height: 2.5, color: const Color(0xFFC8102E)),
            ),
          ),
          Align(
            child: Transform.rotate(
              angle: -0.56,
              child: Container(width: 44, height: 2.5, color: const Color(0xFFC8102E)),
            ),
          ),
          Align(child: Container(width: 36, height: 7, color: Colors.white)),
          Align(child: Container(width: 7, height: 24, color: Colors.white)),
          Align(
            child: Container(width: 36, height: 3.5, color: const Color(0xFFC8102E)),
          ),
          Align(
            child: Container(width: 3.5, height: 24, color: const Color(0xFFC8102E)),
          ),
        ],
      ),
    );
  }
}

class DashedRoundRectPainter extends CustomPainter {
  DashedRoundRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashLength,
    required this.gapLength,
  });

  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashLength;
  final double gapLength;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rect);
    final metric = path.computeMetrics().first;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    double distance = 0;
    while (distance < metric.length) {
      final next = distance + dashLength;
      canvas.drawPath(metric.extractPath(distance, next.clamp(0, metric.length)), paint);
      distance += dashLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant DashedRoundRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.gapLength != gapLength;
  }
}