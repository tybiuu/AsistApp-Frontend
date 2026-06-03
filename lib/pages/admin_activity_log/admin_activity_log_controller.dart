import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum ActivityFilter { todos, asistencias, horarios, miembros }

class ActivityEntry {
  final String type;
  final String subject;
  final String datetime;
  final String by;
  final String byRole;

  ActivityEntry({
    required this.type,
    required this.subject,
    required this.datetime,
    required this.by,
    required this.byRole,
  });

  factory ActivityEntry.fromJson(Map<String, dynamic> json) {
    return ActivityEntry(
      type:     json['type'],
      subject:  json['subject'],
      datetime: json['datetime'],
      by:       json['by'],
      byRole:   json['byRole'],
    );
  }

  ActivityFilter get filter {
    switch (type) {
      case 'asistencia_confirmada':
      case 'asistencia_faltante_procesada':
      case 'tardanza_registrada':
      case 'inasistencia_marcada':
        return ActivityFilter.asistencias;
      case 'horario_aprobado':
      case 'cambio_de_horario_aprobado':
        return ActivityFilter.horarios;
      case 'miembro_aceptado':
      case 'miembro_rechazado':
        return ActivityFilter.miembros;
      default:
        return ActivityFilter.todos;
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
      final String raw = await rootBundle
          .loadString('assets/jsons/mock_activity_log.json');
      final Map<String, dynamic> json = jsonDecode(raw);
      entries.value = (json['entries'] as List)
          .map((e) => ActivityEntry.fromJson(e))
          .toList();
    } catch (e) {
      print('Activity log error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}