import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/difficulty_level.dart';
import '../models/evidence_item.dart';
import '../models/home_copy.dart';
import '../models/language_scope.dart';
import '../widgets/difficulty_selector.dart';
import '../widgets/how_it_works_overlay.dart';
import '../widgets/language_selector.dart';
import '../widgets/upload_dropzone.dart';
import 'loading_screen.dart';

class CaseGeneratorHomePage extends StatefulWidget {
  const CaseGeneratorHomePage({super.key});

  @override
  State<CaseGeneratorHomePage> createState() => _CaseGeneratorHomePageState();
}

class _CaseGeneratorHomePageState extends State<CaseGeneratorHomePage> {
  DifficultyLevel _selectedDifficulty = DifficultyLevel.medium;
  final List<EvidenceItem> _selectedEvidence = [];
  final TextEditingController _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _openEvidencePicker() async {
    final copy = HomeCopy.fromLanguage(LanguageScope.read(context));

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
                title: Text(copy.photosPickerLabel),
                subtitle: Text(copy.photosPickerSubtitle),
                onTap: () => Navigator.pop(context, _EvidenceSource.photos),
              ),
              ListTile(
                leading: const Icon(Icons.folder_open_outlined),
                title: Text(copy.filesPickerLabel),
                subtitle: Text(copy.filesPickerSubtitle),
                onTap: () => Navigator.pop(context, _EvidenceSource.files),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (selection == null) return;

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
    if (!mounted || photos.isEmpty) return;
    setState(() {
      _selectedEvidence.addAll(
        photos.map(
          (f) => EvidenceItem(
            displayName: f.name,
            sourceLabel: 'Photo',
            icon: Icons.image_outlined,
          ),
        ),
      );
    });
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.pickFiles(allowMultiple: true);
    if (!mounted || result == null || result.files.isEmpty) return;
    setState(() {
      _selectedEvidence.addAll(
        result.files.map(
          (f) => EvidenceItem(
            displayName: f.name,
            sourceLabel: 'File',
            icon: Icons.insert_drive_file_outlined,
          ),
        ),
      );
    });
  }

  void _removeEvidence(int index) {
    setState(() => _selectedEvidence.removeAt(index));
  }

  void _clearEvidence() {
    setState(() => _selectedEvidence.clear());
  }

  Future<void> _confirmStartOver() async {
    final copy = HomeCopy.fromLanguage(LanguageScope.read(context));
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          copy.startOver,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        content: Text(copy.startOverContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              copy.startOverCancel,
              style: const TextStyle(color: Color(0xFF737373)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE02D91),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(copy.startOverConfirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _promptController.clear();
        _selectedEvidence.clear();
        _selectedDifficulty = DifficultyLevel.medium;
      });
    }
  }

  Future<void> _generateCase() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      final copy = HomeCopy.fromLanguage(LanguageScope.read(context));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(copy.promptHint)),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    await Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) =>
            CaseLoadingScreen(
              difficulty: _selectedDifficulty,
              prompt: prompt,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = LanguageScope.of(context);
    final copy = HomeCopy.fromLanguage(language);
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomSpacing = (screenHeight * 0.05).clamp(24.0, 56.0).toDouble();

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
                  // Top bar: help button + language toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => showHowItWorksOverlay(context),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.question_mark,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 156,
                          child: LanguageSelector(
                            selectedLanguage: language,
                            onLanguageChanged: (lang) =>
                                LanguageScope.notifierOf(context).value = lang,
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
                      padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── Title & subtitle ───────────────────────────────
                          Text(
                            copy.welcomeTitle,
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  color: const Color(0xFFE23198),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 38,
                                  height: 1.14,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            copy.subtitle,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: const Color(0xFF737373),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  height: 1.18,
                                ),
                            textAlign: TextAlign.center,
                          ),

                          // ── Divider ────────────────────────────────────────
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(
                              color: Color(0xFFDDDDDD),
                              thickness: 1,
                              height: 1,
                            ),
                          ),

                          // ── Case prompt ────────────────────────────────────
                          _SectionLabel(label: copy.promptTitle),
                          const SizedBox(height: 10),
                          Container(
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
                            child: TextField(
                              controller: _promptController,
                              maxLines: 5,
                              minLines: 3,
                              textCapitalization: TextCapitalization.sentences,
                              style: const TextStyle(
                                color: Color(0xFF1A1A1A),
                                fontSize: 15,
                                height: 1.45,
                              ),
                              decoration: InputDecoration(
                                hintText: copy.promptHint,
                                hintStyle: const TextStyle(
                                  color: Color(0xFF8A8A8A),
                                  fontSize: 14,
                                ),
                                contentPadding: const EdgeInsets.all(16),
                                border: InputBorder.none,
                                suffixIcon: ValueListenableBuilder<
                                  TextEditingValue
                                >(
                                  valueListenable: _promptController,
                                  builder: (_, value, child) =>
                                      value.text.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(
                                                Icons.close,
                                                size: 18,
                                                color: Color(0xFF888888),
                                              ),
                                              onPressed: () =>
                                                  _promptController.clear(),
                                            )
                                          : const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ── Supporting materials ───────────────────────────
                          _SectionLabel(
                            label: copy.uploadSectionTitle,
                            isOptional: true,
                            optionalLabel: copy.optional,
                          ),
                          const SizedBox(height: 10),
                          UploadDropzone(
                            uploadHint: copy.uploadHint,
                            supportedFormats: copy.supportedFormats,
                            selectedEvidence: _selectedEvidence,
                            selectedLabel: copy.evidenceSelectedLabel,
                            tapToAddLabel: copy.evidenceTapToAdd,
                            clearAllLabel: copy.evidenceClearAll,
                            onTap: _openEvidencePicker,
                            onRemoveItem: _removeEvidence,
                            onClearAll: _clearEvidence,
                          ),

                          const SizedBox(height: 24),

                          // ── Difficulty ─────────────────────────────────────
                          _SectionLabel(label: copy.difficultyTitle),
                          const SizedBox(height: 4),
                          Text(
                            copy.difficultyHint,
                            style: const TextStyle(
                              color: Color(0xFF737373),
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          DifficultySelector(
                            selected: _selectedDifficulty,
                            onChanged: (level) =>
                                setState(() => _selectedDifficulty = level),
                            labelEasy: copy.difficultyEasy,
                            labelMedium: copy.difficultyMedium,
                            labelHard: copy.difficultyHard,
                          ),

                          SizedBox(height: bottomSpacing),

                          // ── Generate button ────────────────────────────────
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
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              child: Text(copy.generateCase),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // ── Start over ─────────────────────────────────────
                          Center(
                            child: TextButton(
                              onPressed: _confirmStartOver,
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF888888),
                              ),
                              child: Text(
                                copy.startOver,
                                style: const TextStyle(fontSize: 14),
                              ),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.label,
    this.isOptional = false,
    this.optionalLabel = 'optional',
  });

  final String label;
  final bool isOptional;
  final String optionalLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF111111),
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        if (isOptional) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              optionalLabel,
              style: const TextStyle(
                color: Color(0xFF888888),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

enum _EvidenceSource { photos, files }
