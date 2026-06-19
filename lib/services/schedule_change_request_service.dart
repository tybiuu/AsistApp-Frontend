import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/generic_response.dart';
import '../models/schedule_change_request.dart';

class ScheduleChangeRequestService {
  Future<GenericResponse<List<ScheduleChangeRequest>>> fetchAll() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/jsons/mock_schedule_change_requests.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      final requests = jsonList
          .map((j) => ScheduleChangeRequest.fromJson(j as Map<String, dynamic>))
          .toList();

      final prefs = await SharedPreferences.getInstance();
      final localRaw = prefs.getString('local_schedule_change_requests');
      if (localRaw != null) {
        try {
          final List<dynamic> localList = json.decode(localRaw);
          requests.addAll(
            localList.map(
              (e) => ScheduleChangeRequest.fromJson(e as Map<String, dynamic>),
            ),
          );
        } catch (_) {}
      }

      return GenericResponse(
        success: true,
        data: requests,
        message: 'Solicitudes de cambio de horario',
        error: null,
      );
    } catch (e, stackTrace) {
      return GenericResponse(
        success: false,
        data: null,
        message: 'Ocurrió un error no esperado',
        error: stackTrace.toString(),
      );
    }
  }

  int countByStatus(List<ScheduleChangeRequest> requests, String status) =>
      requests.where((r) => r.status.name == status).length;
}
