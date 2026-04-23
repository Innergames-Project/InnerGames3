import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/app_language.dart';
import '../models/evidence_item.dart';
import '../models/home_copy.dart';
import '../widgets/how_it_works_overlay.dart';
import '../widgets/language_selector.dart';
import '../widgets/upload_dropzone.dart';
import 'case_simulation_page.dart';
import 'loading_screen.dart';

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
                          onTap: () => showHowItWorksOverlay(context),
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

enum _EvidenceSource { photos, files }
