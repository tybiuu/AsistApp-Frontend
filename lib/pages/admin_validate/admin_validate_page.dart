import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/app_top_bar.dart';
import '../../configs/theme.dart';
import '../../utils/date_utils.dart';
import '../../utils/trainee_utils.dart';

class AdminValidatePage extends StatelessWidget {
  const AdminValidatePage({super.key});

  Future<_AdminValidateData> _loadData() async {
    final recordsString = await rootBundle.loadString(
      'assets/jsons/mock_attendance_records.json',
    );

    final traineesString = await rootBundle.loadString(
      'assets/jsons/mock_trainees.json',
    );

    final records = (jsonDecode(recordsString) as List<dynamic>)
        .cast<Map<String, dynamic>>();

    final trainees = (jsonDecode(traineesString) as List<dynamic>)
        .cast<Map<String, dynamic>>();

    return _AdminValidateData(records: records, trainees: trainees);
  }


  String _statusText(Map<String, dynamic> record) {
    final status = record['status'];

    if (status == 'pending') {
      final lateMinutes = record['late_minutes'];
      if (lateMinutes != null && lateMinutes > 0) return 'Tardanza';
      return 'Pendiente';
    }

    if (status == 'confirmed') {
      final lateMinutes = record['late_minutes'];
      if (lateMinutes != null && lateMinutes > 0) return 'Tardanza';
      return 'A tiempo';
    }

    if (status == 'absence') return 'Sin marcar';

    return status.toString();
  }

  Color _statusColor(String status) {
    if (status == 'A tiempo') return AppColors.success;
    if (status == 'Tardanza') return AppColors.warning;
    if (status == 'Sin marcar') return const Color(0xFF3B82F6);
    return const Color(0xFF64748B);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final now = DateTime.now();
    final dateLabel = 'Hoy, ${now.day} ${monthAbbrev(now.month)}';

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
                        return Center(
                          child: CircularProgressIndicator(color: colors.primary),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error al cargar datos',
                            style: TextStyle(color: colors.onSurface),
                          ),
                        );
                      }

                      final data = snapshot.data!;
                      final records = data.records;
                      final trainees = data.trainees;

                      final pendingRecords = records
                          .where((record) => record['status'] == 'pending')
                          .toList();

                      final confirmedRecords = records
                          .where((record) => record['status'] == 'confirmed')
                          .toList();

                      final validationRecords = [
                        ...pendingRecords,
                        ...confirmedRecords,
                      ];

                      final missingRecords = records
                          .where((record) => record['status'] == 'absence')
                          .toList();

                      return ListView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        children: [
                          const SizedBox(height: 4),

                    _SectionTitle(
                      title: 'Esperando validación',
                      count: validationRecords.length.toString(),
                    ),

                    const SizedBox(height: 12),

                    ...validationRecords.map((record) {
                      final trainee = findTrainee(
                        trainees,
                        record['user_id'].toString(),
                      );

                      final status = _statusText(record);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ValidateCard(
                          initials: traineeInitials(trainee),
                          name: traineeFullName(trainee),
                          career: traineeCareerText(trainee),
                          status: status,
                          statusColor: _statusColor(status),
                          inTime: formatTimeShort(record['check_in']),
                          snackStart: formatTimeShort(record['lunch_start']),
                          snackEnd: formatTimeShort(record['lunch_end']),
                          outTime: formatTimeShort(record['check_out']),
                        ),
                      );
                    }),

                    const SizedBox(height: 12),

                    _SectionTitle(
                      title: 'Aún no han marcado',
                      count: missingRecords.length.toString(),
                    ),

                    const SizedBox(height: 12),

                    ...missingRecords.map((record) {
                      final trainee = findTrainee(
                        trainees,
                        record['user_id'].toString(),
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _MissingCard(
                          initials: traineeInitials(trainee),
                          name: traineeFullName(trainee),
                          career: traineeCareerText(trainee),
                          inTime: 'Sin registro',
                          outTime: 'Sin registro',
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

  const _AdminValidateData({
    required this.records,
    required this.trainees,
  });
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String count;

  const _SectionTitle({
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.7,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
          ),
          child: Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _ValidateCard extends StatelessWidget {
  final String initials;
  final String name;
  final String career;
  final String status;
  final Color statusColor;
  final String inTime;
  final String? snackStart;
  final String? snackEnd;
  final String outTime;

  const _ValidateCard({
    required this.initials,
    required this.name,
    required this.career,
    required this.status,
    required this.statusColor,
    required this.inTime,
    required this.snackStart,
    required this.snackEnd,
    required this.outTime,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                _Avatar(initials: initials),
                const SizedBox(width: 12),
                Expanded(
                  child: _PersonInfo(name: name, career: career),
                ),
                _StatusBadge(text: status, color: statusColor),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(
                  child: _TimeBox(
                    label: 'IN',
                    time: inTime,
                    color: status == 'Tardanza'
                        ? const Color(0xFFF97316)
                        : AppColors.success,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TimeBox(
                    label: 'REF. IN',
                    time: snackStart ?? '-',
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TimeBox(
                    label: 'REF. OUT',
                    time: snackEnd ?? '-',
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TimeBox(
                    label: 'OUT',
                    time: outTime,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(18),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Validar →',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MissingCard extends StatelessWidget {
  final String initials;
  final String name;
  final String career;
  final String inTime;
  final String outTime;

  const _MissingCard({
    required this.initials,
    required this.name,
    required this.career,
    required this.inTime,
    required this.outTime,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2563EB)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          _Avatar(initials: initials),
          const SizedBox(width: 12),
          Expanded(
            child: _PersonInfo(name: name, career: career),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const _StatusBadge(
                text: 'Sin marcar',
                color: Color(0xFF3B82F6),
              ),
              const SizedBox(height: 8),
              Text(
                '$inTime - $outTime',
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;

  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      radius: 22,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _PersonInfo extends StatelessWidget {
  final String name;
  final String career;

  const _PersonInfo({
    required this.name,
    required this.career,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            color: colors.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          career,
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusBadge({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String label;
  final String time;
  final Color color;

  const _TimeBox({
    required this.label,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
