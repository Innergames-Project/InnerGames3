import 'dart:io';
import 'dart:ui' show Rect;

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../models/generated_case.dart';
import '../models/home_copy.dart';

// App colours reproduced for the PDF
const _pink = PdfColor(0.878, 0.176, 0.569); // #E02D91
const _darkPink = PdfColor(0.478, 0.055, 0.282); // #7A0E48
const _darkPinkHeader = PdfColor(0.302, 0.031, 0.188); // #4D0830
const _green = PdfColor(0.627, 0.741, 0.0); // #A0BD00
const _textDark = PdfColor(0.118, 0.118, 0.118); // #1E1E1E
const _textGray = PdfColor(0.451, 0.451, 0.451);

// Card size: 85 × 55 mm (landscape business-card proportions)
// Two columns per row → 6 cards per A4 page with 15 mm margins.
const _cardW = 85.0 * PdfPageFormat.mm;
const _cardH = 55.0 * PdfPageFormat.mm;
const _cardGap = 8.0 * PdfPageFormat.mm;
const _radius = 6.0;

class PdfExportService {
  /// Generates a two-page PDF (fronts then backs) and opens the system share
  /// sheet. Uses Open Sans via PdfGoogleFonts for full Unicode support.
  static Future<void> export({
    required List<GeneratedCaseStep> steps,
    required HomeCopy copy,
    required String filename,
    Rect? shareOrigin,
  }) async {
    // Download Unicode-capable fonts (HTTP call, result is cached on device).
    final fontRegular = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();

    final doc = pw.Document(
      theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
    );

    doc.addPage(_buildPage(steps, copy, showFront: true));
    // Backs are mirrored column-order so they align when printed double-sided.
    doc.addPage(_buildPage(steps, copy, showFront: false, mirrorColumns: true));

    // Write to a temp file then hand off to the platform share sheet.
    // This avoids the method-channel used by Printing.sharePdf, which is not
    // available on projects that use Swift Package Manager for plugins.
    final bytes = await doc.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename.pdf');
    await file.writeAsBytes(bytes, flush: true);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/pdf', name: '$filename.pdf')],
      subject: filename,
      sharePositionOrigin: shareOrigin,
    );
  }

  static pw.Page _buildPage(
    List<GeneratedCaseStep> steps,
    HomeCopy copy, {
    required bool showFront,
    bool mirrorColumns = false,
  }) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(
        horizontal: 15 * PdfPageFormat.mm,
        vertical: 18 * PdfPageFormat.mm,
      ),
      build: (context) {
        final rows = <pw.Widget>[];
        for (int i = 0; i < steps.length; i += 2) {
          final a = steps[i];
          final b = i + 1 < steps.length ? steps[i + 1] : null;

          final cardA = showFront ? _front(a, copy) : _back(a, copy);
          final cardB = b != null
              ? (showFront ? _front(b, copy) : _back(b, copy))
              : pw.SizedBox(width: _cardW, height: _cardH);

          rows.add(
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: mirrorColumns
                  ? [
                      if (b != null) cardB else pw.SizedBox(width: _cardW),
                      cardA,
                    ]
                  : [cardA, cardB],
            ),
          );
          if (i + 2 < steps.length) {
            rows.add(pw.SizedBox(height: _cardGap));
          }
        }

        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: rows,
        );
      },
    );
  }

  // ── Front face ───────────────────────────────────────────────────────────────

  static pw.Widget _front(GeneratedCaseStep step, HomeCopy copy) {
    return pw.Container(
      width: _cardW,
      height: _cardH,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(_radius),
        border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
      ),
      child: pw.ClipRRect(
        horizontalRadius: _radius,
        verticalRadius: _radius,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header strip
            pw.Container(
              color: _pink,
              padding: const pw.EdgeInsets.fromLTRB(10, 6, 10, 6),
              child: pw.Row(
                children: [
                  pw.Container(
                    width: 18,
                    height: 18,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: pw.BorderRadius.circular(9),
                    ),
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      '${step.index}',
                      style: pw.TextStyle(
                        color: _pink,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  pw.Text(
                    copy.stepLabel.toUpperCase(),
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 7,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            // Scenario text
            pw.Expanded(
              child: pw.Padding(
                padding: const pw.EdgeInsets.fromLTRB(10, 8, 10, 6),
                child: pw.Text(
                  step.subtitle,
                  style: pw.TextStyle(
                    color: _textDark,
                    fontSize: 8,
                    lineSpacing: 2,
                  ),
                  maxLines: 8,
                  overflow: pw.TextOverflow.clip,
                ),
              ),
            ),
            // Flip hint
            pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(10, 0, 10, 6),
              child: pw.Text(
                copy.tapToSeeChoices,
                style: pw.TextStyle(color: _textGray, fontSize: 6.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Back face ────────────────────────────────────────────────────────────────

  static pw.Widget _back(GeneratedCaseStep step, HomeCopy copy) {
    return pw.Container(
      width: _cardW,
      height: _cardH,
      decoration: pw.BoxDecoration(
        color: _darkPink,
        borderRadius: pw.BorderRadius.circular(_radius),
        border: pw.Border.all(color: _darkPinkHeader, width: 0.5),
      ),
      child: pw.ClipRRect(
        horizontalRadius: _radius,
        verticalRadius: _radius,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header strip
            pw.Container(
              color: _darkPinkHeader,
              padding: const pw.EdgeInsets.fromLTRB(10, 6, 10, 6),
              child: pw.Text(
                copy.choicesLabel.toUpperCase(),
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 7,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 1.4,
                ),
              ),
            ),
            // Choices
            pw.Expanded(
              child: pw.Padding(
                padding: const pw.EdgeInsets.fromLTRB(10, 7, 10, 6),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < step.details.length; i++) ...[
                      _pdfChoiceRow(step.details[i]),
                      if (i != step.details.length - 1)
                        pw.SizedBox(height: 4),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _pdfChoiceRow(GeneratedStepDetail detail) {
    final parts = detail.title.split(' ');
    final letter = parts.isNotEmpty ? parts.last : '?';

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 14,
          height: 14,
          decoration: pw.BoxDecoration(
            color: _green,
            borderRadius: pw.BorderRadius.circular(3),
          ),
          alignment: pw.Alignment.center,
          child: pw.Text(
            letter,
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 7,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(width: 5),
        pw.Expanded(
          child: pw.Text(
            detail.body,
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 7.5,
              lineSpacing: 1.5,
            ),
            maxLines: 3,
            overflow: pw.TextOverflow.clip,
          ),
        ),
      ],
    );
  }
}
