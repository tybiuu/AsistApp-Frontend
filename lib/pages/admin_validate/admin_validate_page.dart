import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import '../../configs/theme.dart';
import '../../models/attendance_record.dart';
import '../../models/user.dart';
import '../../services/attendance_record_service.dart';
import '../../services/session_service.dart';
import '../../services/trainee_service.dart';
import '../../utils/date_utils.dart';
import '../../utils/trainee_utils.dart';
import '../root/root_controller.dart';
import 'components/missing_card.dart';
import 'components/section_title.dart';
import 'components/validate_card.dart';

class AdminValidatePage extends StatefulWidget {
  const AdminValidatePage({super.key});

  @override
  State<AdminValidatePage> createState() => _AdminValidatePageState();
}

class _AdminValidatePageState extends State<AdminValidatePage> {
  // Posición de esta pestaña dentro de `adminViews` en root_page.dart.
  // Se usa para refrescar los datos cada vez que el admin vuelve a esta
  // pestaña, ya que el IndexedStack mantiene el widget vivo y `initState`
  // solo corre una vez por sesión.
  static const int _tabIndex = 1;

  late Future<_AdminValidateData> _dataFuture;
  Worker? _tabWorker;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();

    if (Get.isRegistered<RootController>()) {
      _tabWorker = ever<int>(Get.find<RootController>().currentIndex, (index) {
        if (!mounted || index != _tabIndex) return;
        setState(() => _dataFuture = _loadData());
      });
    }
  }

  @override
  void dispose() {
    _tabWorker?.dispose();
    super.dispose();
  }

  Future<_AdminValidateData> _loadData() async {
    final recordsResponse = await Get.find<AttendanceRecordService>().fetchAll();
    final traineesResponse = await Get.find<TraineeService>().fetchAll();

    return _AdminValidateData(
      records: recordsResponse.data ?? <AttendanceRecord>[],
      trainees: traineesResponse.data ?? <User>[],
    );
  }

  Future<void> _validate(AttendanceRecord record) async {
    final currentUserId = SessionService.to.currentUser.value?.id;
    final response = await Get.find<AttendanceRecordService>().setStatus(
      record.id,
      'confirmed',
      validatedById: currentUserId,
    );
    if (!mounted) return;
    if (response.success) {
      setState(() => _dataFuture = _loadData());
    } else {
      Get.snackbar('Error', 'No se pudo validar la asistencia.');
    }
  }

  String _statusText(AttendanceRecord record) {
    if (record.status == AttendanceStatus.pending) {
      return (record.lateMinutes != null && record.lateMinutes! > 0)
          ? 'Tardanza'
          : 'Pendiente';
    }
    if (record.status == AttendanceStatus.confirmed) {
      return (record.lateMinutes != null && record.lateMinutes! > 0)
          ? 'Tardanza'
          : 'A tiempo';
    }
    if (record.status == AttendanceStatus.absence) return 'Sin marcar';
    return record.status.name;
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
    final dateLabel =
        'Hoy, ${DateTime.now().day} ${monthAbbrev(DateTime.now().month)}';

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
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
                      Icon(Icons.calendar_today_rounded,
                          color: colors.primary, size: 13),
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
                    future: _dataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                                color: colors.primary));
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error al cargar datos',
                              style: TextStyle(color: colors.onSurface)),
                        );
                      }

                      final data = snapshot.data!;
                      final records = data.records;
                      final trainees = data.trainees;

                      final pendingRecords = records
                          .where(
                              (r) => r.status == AttendanceStatus.pending)
                          .toList();
                      final confirmedRecords = records
                          .where(
                              (r) => r.status == AttendanceStatus.confirmed)
                          .toList();
                      final validationRecords = [
                        ...pendingRecords,
                        ...confirmedRecords
                      ];
                      final missingRecords = records
                          .where(
                              (r) => r.status == AttendanceStatus.absence)
                          .toList();

                      return ListView(
                        padding:
                            const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        children: [
                          const SizedBox(height: 4),
                          AdminSectionTitle(
                            title: 'Esperando validación',
                            count: validationRecords.length.toString(),
                          ),
                          const SizedBox(height: 12),
                          ...validationRecords.map((record) {
                            final trainee =
                                findTrainee(trainees, record.userId);
                            final status = _statusText(record);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ValidateCard(
                                initials: traineeInitials(trainee),
                                name: traineeFullName(trainee),
                                career: traineeCareerText(trainee),
                                status: status,
                                statusColor: _statusColor(status),
                                inTime: formatTimeShort(
                                    record.checkIn?.toIso8601String()),
                                snackStart: formatTimeShort(
                                    record.lunchStart?.toIso8601String()),
                                snackEnd: formatTimeShort(
                                    record.lunchEnd?.toIso8601String()),
                                outTime: formatTimeShort(
                                    record.checkOut?.toIso8601String()),
                                isLate: (record.lateMinutes ?? 0) > 0,
                                onValidate: record.status == AttendanceStatus.pending
                                    ? () => _validate(record)
                                    : null,
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
                            final trainee =
                                findTrainee(trainees, record.userId);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: MissingCard(
                                initials: traineeInitials(trainee),
                                name: traineeFullName(trainee),
                                career: traineeCareerText(trainee),
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
  final List<AttendanceRecord> records;
  final List<User> trainees;

  const _AdminValidateData({required this.records, required this.trainees});
}
