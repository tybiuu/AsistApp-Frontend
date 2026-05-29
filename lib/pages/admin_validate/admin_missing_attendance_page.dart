import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminMissingAttendancePage extends StatelessWidget {
  const AdminMissingAttendancePage({super.key});

  static const Color orange = Color(0xFFFF6A00);
  static const Color bg = Color(0xFFF7F8FA);
  static const Color card = Colors.white;
  static const Color text = Color(0xFF111827);
  static const Color muted = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color green = Color(0xFF16A34A);
  static const Color red = Color(0xFFEF4444);

  Future<_MissingAttendanceData> _loadData() async {
    final requestsString = await rootBundle.loadString(
      'assets/jsons/mock_attendance_requests.json',
    );

    final traineesString = await rootBundle.loadString(
      'assets/jsons/mock_trainees.json',
    );

    final requests = (jsonDecode(requestsString) as List<dynamic>)
        .cast<Map<String, dynamic>>();

    final trainees = (jsonDecode(traineesString) as List<dynamic>)
        .cast<Map<String, dynamic>>();

    final pendingRequests = requests
        .where((request) => request['status'] == 'pending')
        .toList();

    return _MissingAttendanceData(
      requests: pendingRequests,
      trainees: trainees,
    );
  }

  Map<String, dynamic>? _findTrainee(
    List<Map<String, dynamic>> trainees,
    String userId,
  ) {
    for (final trainee in trainees) {
      if (trainee['id'] == userId) return trainee;
    }
    return null;
  }

  String _initials(Map<String, dynamic>? trainee) {
    if (trainee == null) return '--';

    final first = trainee['first_name']?.toString() ?? '';
    final last = trainee['last_name']?.toString() ?? '';

    final f = first.isNotEmpty ? first[0] : '';
    final l = last.isNotEmpty ? last[0] : '';

    return '$f$l'.toUpperCase();
  }

  String _fullName(Map<String, dynamic>? trainee) {
    if (trainee == null) return 'Practicante no encontrado';

    final first = trainee['first_name']?.toString() ?? '';
    final last = trainee['last_name']?.toString() ?? '';

    return '$first $last'.trim();
  }

  String _requestTime(String value) {
    if (value.length < 16) return '--:--';

    final hour = int.tryParse(value.substring(11, 13)) ?? 0;
    final minute = value.substring(14, 16);
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    return '${hour12.toString().padLeft(2, '0')}:$minute $suffix';
  }

  String _formatDate(String value) {
    final parts = value.split('-');
    if (parts.length != 3) return value;

    const months = {
      '01': 'ene',
      '02': 'feb',
      '03': 'mar',
      '04': 'abr',
      '05': 'may',
      '06': 'jun',
      '07': 'jul',
      '08': 'ago',
      '09': 'sep',
      '10': 'oct',
      '11': 'nov',
      '12': 'dic',
    };

    return '${parts[2]} ${months[parts[1]] ?? parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: FutureBuilder<_MissingAttendanceData>(
              future: _loadData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error al cargar solicitudes'),
                  );
                }

                final data = snapshot.data!;
                final requests = data.requests;
                final trainees = data.trainees;

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFF3F4F6)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                color: Color(0xFF374151),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Text(
                              'Asistencias faltantes',
                              style: TextStyle(
                                color: text,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                        children: [
                          Text(
                            '${requests.length} practicantes que solicitaron regularizar asistencia',
                            style: const TextStyle(
                              color: muted,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),

                          ...requests.map((request) {
                            final trainee = _findTrainee(
                              trainees,
                              request['user_id'].toString(),
                            );

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _MissingRequestCard(
                                initials: _initials(trainee),
                                name: _fullName(trainee),
                                requestedAt:
                                    _requestTime(request['created_at'].toString()),
                                date: _formatDate(
                                  request['requested_date'].toString(),
                                ),
                                arrivedAt:
                                    _requestTime(request['created_at'].toString()),
                                reason: request['reason'].toString(),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _MissingAttendanceData {
  final List<Map<String, dynamic>> requests;
  final List<Map<String, dynamic>> trainees;

  const _MissingAttendanceData({
    required this.requests,
    required this.trainees,
  });
}

class _MissingRequestCard extends StatelessWidget {
  final String initials;
  final String name;
  final String requestedAt;
  final String date;
  final String arrivedAt;
  final String reason;

  const _MissingRequestCard({
    required this.initials,
    required this.name,
    required this.requestedAt,
    required this.date,
    required this.arrivedAt,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AdminMissingAttendancePage.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AdminMissingAttendancePage.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AdminMissingAttendancePage.orange,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: AdminMissingAttendancePage.text,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Solicitó: $requestedAt',
                            style: const TextStyle(
                              color: AdminMissingAttendancePage.muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _InfoBox(
                        icon: Icons.calendar_today_rounded,
                        label: 'FECHA',
                        value: date,
                        background: const Color(0xFFF9FAFB),
                        iconColor: AdminMissingAttendancePage.orange,
                        valueColor: AdminMissingAttendancePage.text,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _InfoBox(
                        icon: Icons.access_time_rounded,
                        label: 'LLEGÓ A',
                        value: arrivedAt,
                        background: const Color(0xFFFFF7ED),
                        iconColor: AdminMissingAttendancePage.orange,
                        valueColor: AdminMissingAttendancePage.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '"$reason"',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      height: 1.45,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF3F4F6)),

          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cancel_outlined,
                          color: AdminMissingAttendancePage.red,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Denegar',
                          style: TextStyle(
                            color: AdminMissingAttendancePage.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 54,
                color: const Color(0xFFF3F4F6),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          color: AdminMissingAttendancePage.green,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Registrar sin tardanza',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AdminMissingAttendancePage.green,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
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
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color background;
  final Color iconColor;
  final Color valueColor;

  const _InfoBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.background,
    required this.iconColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: iconColor,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AdminMissingAttendancePage.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
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
