import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import '../../configs/theme.dart';
import '../../models/attendance_request.dart';
import '../../models/user.dart';
import '../../utils/date_utils.dart';
import '../../utils/trainee_utils.dart';

class AdminMissingAttendancePage extends StatefulWidget {
  const AdminMissingAttendancePage({super.key});

  @override
  State<AdminMissingAttendancePage> createState() =>
      _AdminMissingAttendancePageState();
}

class _AdminMissingAttendancePageState
    extends State<AdminMissingAttendancePage> {
  late Future<_MissingAttendanceData> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  Future<_MissingAttendanceData> _loadData() async {
    final requestsString = await rootBundle.loadString(
      'assets/jsons/mock_attendance_requests.json',
    );
    final traineesString = await rootBundle.loadString(
      'assets/jsons/mock_trainees.json',
    );

    final allRequests = (jsonDecode(requestsString) as List<dynamic>)
        .map((j) => AttendanceRequest.fromJson(j as Map<String, dynamic>))
        .toList();

    final trainees = (jsonDecode(traineesString) as List<dynamic>)
        .map((j) => User.fromJson(j as Map<String, dynamic>))
        .toList();

    final pendingRequests =
        allRequests.where((r) => r.status == RequestStatus.pending).toList();

    return _MissingAttendanceData(requests: pendingRequests, trainees: trainees);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: FutureBuilder<_MissingAttendanceData>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: colors.primary),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error al cargar solicitudes',
                      style: TextStyle(color: colors.onSurface),
                    ),
                  );
                }

                final data = snapshot.data!;
                final requests = data.requests;
                final trainees = data.trainees;

                return Column(
                  children: [
                    AppTopBar(
                      title: 'Asistencias faltantes',
                      showBack: true,
                      onBack: Get.back,
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                        children: [
                          Text(
                            '${requests.length} practicantes que solicitaron regularizar asistencia',
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...requests.map((request) {
                            final trainee =
                                findTrainee(trainees, request.userId);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _MissingRequestCard(
                                initials: traineeInitials(trainee),
                                name: traineeFullName(trainee),
                                requestedAt: formatTime12h(
                                    request.createdAt.toIso8601String()),
                                date: formatDateShort(request.requestedDate),
                                arrivedAt: formatTime12h(
                                    request.createdAt.toIso8601String()),
                                reason: request.reason,
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
  final List<AttendanceRequest> requests;
  final List<User> trainees;

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
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.04),
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
                      backgroundColor: colors.primary,
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: colors.onPrimary,
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
                            style: TextStyle(
                              color: colors.onSurface,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Solicitó: $requestedAt',
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
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
                        background: colors.surfaceContainerLow,
                        iconColor: colors.onSurfaceVariant,
                        valueColor: colors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _InfoBox(
                        icon: Icons.access_time_rounded,
                        label: 'LLEGÓ A',
                        value: arrivedAt,
                        background: colors.primary.withValues(alpha: 0.1),
                        iconColor: colors.primary,
                        valueColor: colors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '"$reason"',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      height: 1.45,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.outlineVariant),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cancel_outlined,
                            color: AppColors.error, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Denegar',
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 54, color: colors.outlineVariant),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline_rounded,
                            color: AppColors.success, size: 20),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Registrar sin tardanza',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.success,
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
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: iconColor),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
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
