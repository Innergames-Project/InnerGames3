import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'simulation.dart';

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
          selectLanguageHint: 'Kies de taal voor je gegenereerde\ncasusinhoud',
          generateCase: 'Genereer casus',
          uploadHint: 'Klik om te bladeren, of sleep je bestand hierheen',
          supportedFormats:
              'Ondersteunde formaten: Afbeeldingen, PDF, DOCX, TXT',
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
  final List<EvidenceItem> _selectedEvidence = [];

  Future<void> _openEvidencePicker() async {
    final selection = await showModalBottomSheet<_EvidenceSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD7D7D7),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Photos'),
                subtitle: const Text('Choose from your photo library'),
                onTap: () => Navigator.pop(context, _EvidenceSource.photos),
              ),
              ListTile(
                leading: const Icon(Icons.folder_open_outlined),
                title: const Text('Files'),
                subtitle: const Text('Choose from the Files app'),
                onTap: () => Navigator.pop(context, _EvidenceSource.files),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (selection == null) {
      return;
    }

    switch (selection) {
      case _EvidenceSource.photos:
        await _pickPhotos();
      case _EvidenceSource.files:
        await _pickFiles();
    }
  }

  Future<void> _pickPhotos() async {
    final picker = ImagePicker();
    final photos = await picker.pickMultiImage(imageQuality: 85);

    if (!mounted || photos.isEmpty) {
      return;
    }

    setState(() {
      _selectedEvidence.addAll(
        photos.map(
          (file) => EvidenceItem(
            displayName: file.name,
            sourceLabel: 'Photo',
            icon: Icons.image_outlined,
          ),
        ),
      );
    });
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (!mounted || result == null || result.files.isEmpty) {
      return;
    }

    setState(() {
      _selectedEvidence.addAll(
        result.files.map(
          (file) => EvidenceItem(
            displayName: file.name,
            sourceLabel: 'File',
            icon: Icons.insert_drive_file_outlined,
          ),
        ),
      );
    });
  }

  Future<void> _generateCase() async {
    if (_selectedEvidence.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add evidence first, then generate the case.'),
        ),
      );
      return;
    }

    await Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) =>
            const CaseLoadingScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CaseSimulationPage()));
  }

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
                        GestureDetector(
                          onTap: () => _showHowItWorksOverlay(context),
                          child: Container(
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
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
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
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
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
                            selectedEvidence: _selectedEvidence,
                            onTap: _openEvidencePicker,
                          ),
                          const SizedBox(height: 26),
                          Text(
                            copy.selectLanguageTitle,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: const Color(0xFF111111),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 29,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            copy.selectLanguageHint,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
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
                              onPressed: _generateCase,
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
    required this.selectedEvidence,
    required this.onTap,
  });

  final String uploadHint;
  final String supportedFormats;
  final List<EvidenceItem> selectedEvidence;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedEvidence.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 210),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: hasSelection
                          ? const Color(0xFF2E8B57)
                          : const Color(0xFF4D4D4D),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      hasSelection ? Icons.check : Icons.upload,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!hasSelection) ...[
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: const Color(0xFF7B7B7B),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ] else ...[
                    Text(
                      'Selected evidence',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF4E4E4E),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        '${selectedEvidence.length} item${selectedEvidence.length == 1 ? '' : 's'} ready locally',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: const Color(0xFF7B7B7B),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 74),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedEvidence
                              .map(
                                (item) => Chip(
                                  avatar: Icon(
                                    item.icon,
                                    size: 18,
                                    color: const Color(0xFFE62994),
                                  ),
                                  label: Text(item.displayName),
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Color(0xFFD1D1D1),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        'Tap again to add more files or photos',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF7B7B7B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _EvidenceSource { photos, files }

class EvidenceItem {
  const EvidenceItem({
    required this.displayName,
    required this.sourceLabel,
    required this.icon,
  });

  final String displayName;
  final String sourceLabel;
  final IconData icon;
}

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
                    decoration: BoxDecoration(
                      color: const Color(0xFFE02D91),
                      shape: BoxShape.circle,
                      boxShadow: const [
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

class CaseSimulationPage extends StatelessWidget {
  const CaseSimulationPage({super.key});

  static const List<_CaseStep> _steps = [
    _CaseStep(
      index: 1,
      title: 'Introduction & context',
      subtitle: 'Set the stage for the case scenario',
      details: [
        _StepDetailBlock(
          title: 'Problem analysis',
          body:
              'Analyze underlying issues: potential depression diagnosis, social isolation following retirement, financial management difficulties, lack of structured daily routine.',
        ),
        _StepDetailBlock(
          title: 'Goal setting',
          body:
              'Collaborate with Maria to set SMART goals: reconnect with community activities, establish daily routine, address mental health needs, improve financial management.',
        ),
        _StepDetailBlock(
          title: 'Resource Mapping',
          body:
              'Identify available resources: community mental health services, local activity groups, financial counseling, volunteer visitor programs.',
        ),
      ],
    ),
    _CaseStep(
      index: 2,
      title: 'Assessment phase',
      subtitle: 'Gather and analyse relevant information',
      details: [
        _StepDetailBlock(
          title: 'Needs assessment',
          body:
              'Collect information about Maria\'s emotional wellbeing, social network, daily functioning, and practical challenges at home.',
        ),
        _StepDetailBlock(
          title: 'Risk and protective factors',
          body:
              'Map potential risks such as worsening isolation and low mood, while identifying strengths like motivation for change and existing support contacts.',
        ),
        _StepDetailBlock(
          title: 'Baseline documentation',
          body:
              'Record initial status indicators to compare progress over time: mood level, participation in activities, financial stress, and routine consistency.',
        ),
      ],
    ),
    _CaseStep(
      index: 3,
      title: 'Analysis & planning',
      subtitle: 'Develop intervention strategies',
      details: [
        _StepDetailBlock(
          title: 'Intervention strategy',
          body:
              'Select a balanced support approach combining psychosocial support, practical coaching, and community engagement pathways.',
        ),
        _StepDetailBlock(
          title: 'Scenario branching',
          body:
              'Prepare alternative plans for low-engagement and high-engagement responses so the support path can adapt quickly.',
        ),
        _StepDetailBlock(
          title: 'Success indicators',
          body:
              'Define measurable outcomes for this step: increased social contact, improved daily structure, and stabilized stress levels.',
        ),
      ],
    ),
    _CaseStep(
      index: 4,
      title: 'Intervention & implementation',
      subtitle: 'Execute the support plan',
      details: [
        _StepDetailBlock(
          title: 'Action rollout',
          body:
              'Start planned interventions in sequence: first routine-building, then social participation tasks, followed by targeted practical supports.',
        ),
        _StepDetailBlock(
          title: 'Communication plan',
          body:
              'Coordinate clear communication between Maria, case worker, and partner services to maintain alignment and accountability.',
        ),
        _StepDetailBlock(
          title: 'Real-time adjustments',
          body:
              'Monitor implementation barriers and make quick adjustments to intensity, pacing, or support channel when needed.',
        ),
      ],
    ),
    _CaseStep(
      index: 5,
      title: 'Monitoring & review',
      subtitle: 'Track progress and adjust as needed',
      details: [
        _StepDetailBlock(
          title: 'Progress tracking',
          body:
              'Review weekly indicators against baseline: emotional wellbeing, activity participation, practical stability, and confidence levels.',
        ),
        _StepDetailBlock(
          title: 'Reflection moments',
          body:
              'Facilitate structured reflection with Maria to identify what is working, what feels difficult, and what should be prioritized next.',
        ),
        _StepDetailBlock(
          title: 'Outcome review',
          body:
              'Assess progress toward SMART goals and decide whether to intensify support, maintain course, or transition to lighter follow-up.',
        ),
      ],
    ),
    _CaseStep(
      index: 6,
      title: 'Closure & transition',
      subtitle: 'Ensure sustainable outcomes',
      details: [
        _StepDetailBlock(
          title: 'Transition plan',
          body:
              'Create a structured step-down plan with clear responsibilities, timelines, and support contacts for the post-case period.',
        ),
        _StepDetailBlock(
          title: 'Sustainability supports',
          body:
              'Secure long-term community anchors, practical check-ins, and self-management tools that help maintain progress.',
        ),
        _StepDetailBlock(
          title: 'Follow-up schedule',
          body:
              'Set follow-up milestones and escalation triggers so emerging concerns can be addressed early and safely.',
        ),
      ],
    ),
  ];

  void _openStepOverlay(BuildContext context, _CaseStep step) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Step details',
      barrierColor: const Color(0xA6000000),
      transitionDuration: const Duration(milliseconds: 170),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _StepOverlayDialog(step: step);
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

  @override
  Widget build(BuildContext context) {
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
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, 0.22, 0.22, 1],
                  colors: [
                    const Color(0xFFA66936).withValues(alpha: 0.60),
                    const Color(0xFFA66936).withValues(alpha: 0.60),
                    Colors.transparent,
                    Colors.transparent,
                  ],
                ),
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
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showHowItWorksOverlay(context),
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
                            size: 33,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6E6E6),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(36),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(26, 24, 26, 24),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: _steps.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final step = _steps[index];
                                return _CaseStepCard(
                                  step: step,
                                  onTap: () => _openStepOverlay(context, step),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 64,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const StartScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE02D91),
                                foregroundColor: Colors.white,
                                elevation: 5,
                                shadowColor: const Color(0x55000000),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Start case simulation',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 64,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x45000000),
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const DownloadSuccessPage(),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFE02D91),
                                  side: const BorderSide(
                                    color: Color(0xFFE02D91),
                                    width: 3,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: const Color(0xFFF2F2F2),
                                ),
                                child: const Text(
                                  'Download case',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
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
            ),
          ),
        ],
      ),
    );
  }
}

class DownloadSuccessPage extends StatelessWidget {
  const DownloadSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showHowItWorksOverlay(context),
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
                            size: 33,
                          ),
                        ),
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
                                'Download\nsuccessful!',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displaySmall
                                    ?.copyWith(
                                      color: const Color(0xFFE02D91),
                                      fontSize: 62,
                                      fontWeight: FontWeight.w700,
                                      height: 1.06,
                                    ),
                              ),
                              const SizedBox(height: 26),
                              Text(
                                'Your case has been downloaded\nsuccessfully. You can now use it in\nyour educational programs.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Try your case!',
                                      style: TextStyle(
                                        color: Color(0xFF101010),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Test your generated case in an\ninteractive simulation to see how it\nworks in practice.',
                                      style: TextStyle(
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
                                          Navigator.of(context).push(
                                            MaterialPageRoute<void>(
                                              builder: (_) =>
                                                  const StartScreen(),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFE02D91,
                                          ),
                                          foregroundColor: Colors.white,
                                          elevation: 5,
                                          shadowColor: const Color(0x55000000),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              22,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Start case simulation',
                                          style: TextStyle(
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
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) =>
                                            const CaseSimulationPage(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE02D91),
                                    foregroundColor: Colors.white,
                                    elevation: 5,
                                    shadowColor: const Color(0x55000000),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                  child: const Text(
                                    'Generate another case',
                                    style: TextStyle(
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
  }
}

class _CaseStep {
  const _CaseStep({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.details,
  });

  final int index;
  final String title;
  final String subtitle;
  final List<_StepDetailBlock> details;
}

class _CaseStepCard extends StatelessWidget {
  const _CaseStepCard({required this.step, required this.onTap});

  final _CaseStep step;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(19),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: const Color(0xFFA0BD00), width: 2.4),
            boxShadow: const [
              BoxShadow(
                color: Color(0x37000000),
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFA0BD00),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child: Text(
                    '${step.index}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 43,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: const TextStyle(
                        color: Color(0xFF141414),
                        fontWeight: FontWeight.w700,
                        fontSize: 16.8,
                        height: 1.04,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      step.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF4F4F4F),
                        fontSize: 12,
                        height: 1.12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF7E7E7E),
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepDetailBlock {
  const _StepDetailBlock({required this.title, required this.body});

  final String title;
  final String body;
}

class _StepOverlayDialog extends StatelessWidget {
  const _StepOverlayDialog({required this.step});

  final _CaseStep step;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.88;

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
                  color: const Color(0xFF5D5D5D),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x8A000000),
                      blurRadius: 8,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: const Color(0xFF6F0F47),
                      width: 2.3,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step.title,
                                  style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111111),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  step.subtitle,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    color: Color(0xFF454545),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.close,
                              color: Color(0xFFE02D91),
                              size: 42,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              for (int i = 0; i < step.details.length; i++) ...[
                                _OverlayDetailCard(block: step.details[i]),
                                if (i != step.details.length - 1)
                                  const SizedBox(height: 12),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE02D91),
                            foregroundColor: Colors.white,
                            elevation: 5,
                            shadowColor: const Color(0x55000000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Regenerate this step',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x45000000),
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFE02D91),
                              side: const BorderSide(
                                color: Color(0xFFE02D91),
                                width: 3,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: const Color(0xFFF2F2F2),
                            ),
                            child: const Text(
                              'Edit manually',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
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
    );
  }
}

class _OverlayDetailCard extends StatelessWidget {
  const _OverlayDetailCard({required this.block});

  final _StepDetailBlock block;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFD7DCB1),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  block.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111111),
                  ),
                ),
              ),
              const Icon(Icons.edit_square, color: Color(0xFFA0BD00), size: 26),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            block.body,
            style: const TextStyle(
              color: Color(0xFF3E3E3E),
              fontSize: 14,
              height: 1.22,
            ),
          ),
        ],
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

void _showHowItWorksOverlay(BuildContext context) {
  showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'How it works',
    barrierColor: const Color(0xA6000000),
    transitionDuration: const Duration(milliseconds: 170),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const _HowItWorksOverlay();
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
  const _HowItWorksOverlay();

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
                                    'How it works',
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
                                    'Create engaging case-based learning\ncontent in three simple steps',
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
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.close,
                                    color: Color(0xFFE02D91),
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _HowItWorksCard(
                          number: '1',
                          title: 'Upload Your Document',
                          description:
                              'Upload your case study or educational material in PDF, DOCX, or TXT format. Select your preferred language (Dutch or English).',
                          icon: Icons.cloud_upload_outlined,
                        ),
                        const SizedBox(height: 12),
                        _HowItWorksCard(
                          number: '2',
                          title: 'AI Generates Your Case',
                          description:
                              'Our AI analyzes your document and automatically creates structured, game-based learning content following a proven six-step pedagogical model.',
                          icon: Icons.auto_awesome,
                        ),
                        const SizedBox(height: 12),
                        _HowItWorksCard(
                          number: '3',
                          title: 'Review & Download',
                          description:
                              'Review the generated content, make any edits you need, and download your case for immediate use in your educational programs.',
                          icon: Icons.download_outlined,
                        ),
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
                            child: const Text(
                              'Got it!',
                              style: TextStyle(
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
      ),
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String number;
  final String title;
  final String description;
  final IconData icon;

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
            child: Center(child: Icon(icon, color: Colors.white, size: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$number. $title',
                  style: const TextStyle(
                    color: Color(0xFF101010),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
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
      canvas.drawPath(
        metric.extractPath(distance, next.clamp(0, metric.length)),
        paint,
      );
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
