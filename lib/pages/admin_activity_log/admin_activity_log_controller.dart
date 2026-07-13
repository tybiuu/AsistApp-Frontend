import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../models/activity_log.dart';
import '../../models/user.dart';
import '../../services/activity_log_service.dart';
import '../../services/trainee_service.dart';
import '../../utils/date_utils.dart';

enum ActivityFilter { todos, asistencias, horarios, miembros }

class ActivityEntry {
  final LogCategory category;
  final String title;
  final String subject;
  final String datetime;
  final String by;
  final String byRole;

  ActivityEntry({
    required this.category,
    required this.title,
    required this.subject,
    required this.datetime,
    required this.by,
    required this.byRole,
  });

  ActivityFilter get filter {
    switch (category) {
      case LogCategory.attendance:
        return ActivityFilter.asistencias;
      case LogCategory.schedule:
        return ActivityFilter.horarios;
      case LogCategory.members:
        return ActivityFilter.miembros;
    }
  }
}

class AdminActivityLogController extends GetxController {
  final entries = <ActivityEntry>[].obs;
  final selectedFilter = ActivityFilter.todos.obs;
  final isLoading = true.obs;

  List<ActivityEntry> get filteredEntries {
    if (selectedFilter.value == ActivityFilter.todos) return entries;
    return entries
        .where((e) => e.filter == selectedFilter.value)
        .toList();
  }

  void setFilter(ActivityFilter filter) => selectedFilter.value = filter;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final logsResponse = await Get.find<ActivityLogService>().fetchAll();
      final usersResponse = await Get.find<TraineeService>().fetchAll();

      final Map<String, User> usersById = {
        for (final user in usersResponse.data ?? <User>[]) user.id: user,
      };

      final logs = logsResponse.data ?? <ActivityLog>[];
      entries.value = logs.map((log) {
        final performer = usersById[log.performedById];
        final affected = usersById[log.affectedUserId];
        return ActivityEntry(
          category: log.category,
          title: log.title,
          subject: affected?.fullName ?? '',
          datetime: _formatDateTime(log.createdAt),
          by: performer?.fullName ?? 'Sistema',
          byRole: performer?.role == UserRole.admin ? 'admin' : '',
        );
      }).toList();
    } catch (e) {
      debugPrint('Activity log error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _formatDateTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '${dt.day} ${monthAbbrev(dt.month)}, $hour:$minute $period';
  }
}
