import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/app_top_bar.dart';
import '../../configs/theme.dart';
import '../../utils/date_utils.dart';
import '../../utils/trainee_utils.dart';
import 'components/missing_card.dart';
import 'components/section_title.dart';
import 'components/validate_card.dart';

class AdminValidatePage extends StatelessWidget {
  const AdminValidatePage({super.key});

  Future<_AdminValidateData> _loadData() async {
    final recordsString = await rootBundle.loadString(
      'assets/jsons/mock_attendance_records.json',
    );
    final traineesString = await rootBundle.loadString(
      'assets/jsons/mock_trainees.json',
    );

    return _AdminValidateData(
      records: (jsonDecode(recordsString) as List<dynamic>).cast<Map<String, dynamic>>(),
      trainees: (jsonDecode(traineesString) as List<dynamic>).cast<Map<String, dynamic>>(),
    );
  }

  String _statusText(Map<String, dynamic> record) {
    final status = record['status'];
    if (status == 'pending') {
      final lateMinutes = record['late_minutes'];
      return (lateMinutes != null && lateMinutes > 0) ? 'Tardanza' : 'Pendiente';
    }
    if (status == 'confirmed') {
      final lateMinutes = record['late_minutes'];
      return (lateMinutes != null && lateMinutes > 0) ? 'Tardanza' : 'A tiempo';
    }
    if (status == 'absence') return 'Sin marcar';
    return status.toString();
  }

  Color _statusColor(String status) {
    if (status == 'A tiempo')  return AppColors.success;
    if (status == 'Tardanza')  return AppColors.warning;
    if (status == 'Sin marcar') return const Color(0xFF3B82F6);
    return const Color(0xFF64748B);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dateLabel = 'Hoy, ${DateTime.now().day} ${monthAbbrev(DateTime.now().month)}';

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            AppTopBar(
              title: 'Validar asistencia',
              actions: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Color.alphaBlend(
                        Colors.black.withValues(alpha: 0.12),
                        colors.surfaceContainerHighest,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today_rounded, color: colors.primary, size: 13),
                      const SizedBox(width: 6),
                      Text(
                        dateLabel,
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: FutureBuilder<_AdminValidateData>(
                    future: _loadData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(color: colors.primary));
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error al cargar datos', style: TextStyle(color: colors.onSurface)),
                        );
                      }

                      final data = snapshot.data!;
                      final records = data.records;
                      final trainees = data.trainees;

                      final pendingRecords   = records.where((r) => r['status'] == 'pending').toList();
                      final confirmedRecords = records.where((r) => r['status'] == 'confirmed').toList();
                      final validationRecords = [...pendingRecords, ...confirmedRecords];
                      final missingRecords   = records.where((r) => r['status'] == 'absence').toList();

                      return ListView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        children: [
                          const SizedBox(height: 4),
                          AdminSectionTitle(
                            title: 'Esperando validación',
                            count: validationRecords.length.toString(),
                          ),
                          const SizedBox(height: 12),
                          ...validationRecords.map((record) {
                            final trainee = findTrainee(trainees, record['user_id'].toString());
                            final status = _statusText(record);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ValidateCard(
                                initials:   traineeInitials(trainee),
                                name:       traineeFullName(trainee),
                                career:     traineeCareerText(trainee),
                                status:     status,
                                statusColor: _statusColor(status),
                                inTime:     formatTimeShort(record['check_in']),
                                snackStart: formatTimeShort(record['lunch_start']),
                                snackEnd:   formatTimeShort(record['lunch_end']),
                                outTime:    formatTimeShort(record['check_out']),
                              ),
                            );
                          }),
                          const SizedBox(height: 12),
                          AdminSectionTitle(
                            title: 'Aún no han marcado',
                            count: missingRecords.length.toString(),
                          ),
                          const SizedBox(height: 12),
                          ...missingRecords.map((record) {
                            final trainee = findTrainee(trainees, record['user_id'].toString());
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: MissingCard(
                                initials: traineeInitials(trainee),
                                name:     traineeFullName(trainee),
                                career:   traineeCareerText(trainee),
                                inTime:   'Sin registro',
                                outTime:  'Sin registro',
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminValidateData {
  final List<Map<String, dynamic>> records;
  final List<Map<String, dynamic>> trainees;

  const _AdminValidateData({required this.records, required this.trainees});
}
