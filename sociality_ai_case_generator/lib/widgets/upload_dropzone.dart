import 'package:flutter/material.dart';

import '../models/evidence_item.dart';
import 'dashed_round_rect_painter.dart';

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
