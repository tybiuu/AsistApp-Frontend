import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../pages/pdf_report/pdf_report_controller.dart';

class PdfGenerator {
  static Future<void> downloadAttendanceReport({
    required TraineeInfo trainee,
    required MonthRecord month,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ── Title ───────────────────────────────────────────────
              pw.Center(
                child: pw.Text(
                  'REGISTRO DE CONTROL DE ASISTENCIA DE PRACTICANTE',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              // ── Trainee info ─────────────────────────────────────────
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _infoLine('Nombre:', trainee.name),
                        pw.SizedBox(height: 4),
                        _infoLine('Código:', trainee.code),
                        pw.SizedBox(height: 4),
                        _infoLine('Dependencia:', trainee.dependency),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _infoLine('Mes:', month.month),
                        pw.SizedBox(height: 4),
                        _infoLine('Hs. sem.:', '${trainee.weeklyHours}h'),
                        pw.SizedBox(height: 4),
                        _infoLine('Carrera:', trainee.career),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // ── Table ─────────────────────────────────────────────────
              pw.Table(
                border: pw.TableBorder.all(
                  color: PdfColors.grey300,
                  width: 0.5,
                ),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1.4),
                  1: const pw.FlexColumnWidth(1.2),
                  2: const pw.FlexColumnWidth(1.2),
                  3: const pw.FlexColumnWidth(1.2),
                  4: const pw.FlexColumnWidth(1.2),
                  5: const pw.FlexColumnWidth(1.2),
                },
                children: [
                  // Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    children: ['FECHA', 'INGR.', 'S.REF', 'R.REF', 'SAL.', 'HS.']
                        .map((h) => pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 4),
                              child: pw.Text(
                                h,
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  fontSize: 9,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  // Data rows
                  ...month.records.asMap().entries.map((entry) {
                    final isAlt = entry.key % 2 == 1;
                    final record = entry.value;
                    return pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: isAlt ? PdfColors.orange50 : PdfColors.white,
                      ),
                      children: [
                        record.date,
                        record.checkIn,
                        record.lunchStart,
                        record.lunchEnd,
                        record.checkOut,
                        record.hoursWorked,
                      ].asMap().entries.map((cell) {
                        final isHours = cell.key == 5;
                        return pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              vertical: 6, horizontal: 4),
                          child: pw.Text(
                            cell.value,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: isHours
                                  ? pw.FontWeight.bold
                                  : pw.FontWeight.normal,
                              color: isHours
                                  ? const PdfColor.fromInt(0xffe15d27)
                                  : PdfColors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 8),

              // ── Total row ─────────────────────────────────────────────
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'TOTAL ${month.month.split(' ')[0].toUpperCase()}: ',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    month.totalHours,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: const PdfColor.fromInt(0xffe15d27),
                    ),
                  ),
                ],
              ),
              pw.Spacer(),

              // ── Signatures ────────────────────────────────────────────
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Divider(color: PdfColors.grey400),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Firma del practicante',
                          style: const pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 40),
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Divider(color: PdfColors.grey400),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Firma del jefe de área',
                          style: const pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _infoLine(String label, String value) {
    return pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: '$label ',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
          pw.TextSpan(
            text: value,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}