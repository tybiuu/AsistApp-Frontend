import 'package:flutter/material.dart';

import '../pdf_report_controller.dart';

class DocumentPreview extends StatelessWidget {
  final TraineeInfo trainee;
  final MonthRecord month;

  const DocumentPreview({
    super.key,
    required this.trainee,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final headerBg = isDark ? const Color(0xff1A1D27) : const Color(0xff1f2937);
    final docBg = isDark ? const Color(0xff1A1D27) : Colors.white;
    final mutedColor = isDark ? const Color(0xff6b7280) : const Color(0xff9ca3af);
    final textColor = isDark ? Colors.white : const Color(0xff1f2937);
    final borderColor = isDark ? const Color(0xff2D3042) : const Color(0xffe5e7eb);
    final rowAltBg = isDark ? const Color(0xff0f1117) : const Color(0xfffdf8f0);

    return Container(
      decoration: BoxDecoration(
        color: docBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Header banner ─────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: headerBg,
            child: Row(
              children: [
                const Icon(
                  Icons.description_rounded,
                  color: Color(0xffe15d27),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  'VISTA PREVIA DEL DOCUMENTO',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ── Document title ───────────────────────────────────
                const Text(
                  'REGISTRO DE CONTROL DE\nASISTENCIA DE PRACTICANTE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Trainee info grid ────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoLine(
                            label: 'Nombre:',
                            value: trainee.name,
                            mutedColor: mutedColor,
                            textColor: textColor,
                          ),
                          const SizedBox(height: 6),
                          _InfoLine(
                            label: 'Código:',
                            value: trainee.code,
                            mutedColor: mutedColor,
                            textColor: textColor,
                          ),
                          const SizedBox(height: 6),
                          _InfoLine(
                            label: 'Dependencia:',
                            value: trainee.dependency,
                            mutedColor: mutedColor,
                            textColor: textColor,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoLine(
                            label: 'Mes:',
                            value: month.month,
                            mutedColor: mutedColor,
                            textColor: textColor,
                          ),
                          const SizedBox(height: 6),
                          _InfoLine(
                            label: 'Hs. sem.:',
                            value: '${trainee.weeklyHours}h',
                            mutedColor: mutedColor,
                            textColor: textColor,
                          ),
                          const SizedBox(height: 6),
                          _InfoLine(
                            label: 'Carrera:',
                            value: trainee.career,
                            mutedColor: mutedColor,
                            textColor: textColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Table ────────────────────────────────────────────
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1.4),
                    1: FlexColumnWidth(1.2),
                    2: FlexColumnWidth(1.2),
                    3: FlexColumnWidth(1.2),
                    4: FlexColumnWidth(1.2),
                    5: FlexColumnWidth(1.2),
                  },
                  children: [
                    // Header row
                    TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: borderColor),
                        ),
                      ),
                      children: ['FECHA', 'INGR.', 'S.REF', 'R.REF', 'SAL.', 'HS.']
                          .map((h) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8),
                                child: Text(
                                  h,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    // Data rows
                    ...month.records.asMap().entries.map((entry) {
                      final isAlt = entry.key % 2 == 1;
                      final record = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: isAlt ? rowAltBg : Colors.transparent,
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
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              cell.value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isHours
                                    ? const Color(0xffe15d27)
                                    : textColor,
                                fontSize: 11,
                                fontWeight: isHours
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 8),

                // ── Total row ────────────────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: rowAltBg,
                    border: Border(top: BorderSide(color: borderColor)),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'TOTAL ${month.month.split(' ')[0].toUpperCase()}:',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        month.totalHours,
                        style: const TextStyle(
                          color: Color(0xffe15d27),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Signature row ────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Divider(color: borderColor),
                          const SizedBox(height: 4),
                          Text(
                            'Firma del practicante',
                            style: TextStyle(
                              color: mutedColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        children: [
                          Divider(color: borderColor),
                          const SizedBox(height: 4),
                          Text(
                            'Firma del jefe de área',
                            style: TextStyle(
                              color: mutedColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info line ─────────────────────────────────────────────────────────────────

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  final Color mutedColor;
  final Color textColor;

  const _InfoLine({
    required this.label,
    required this.value,
    required this.mutedColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: TextStyle(
              color: mutedColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}