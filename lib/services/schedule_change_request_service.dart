// lib/services/schedule_change_request_service.dart

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/generic_response.dart';

class ScheduleChangeRequestService {
  Future<GenericResponse<List<Map<String, dynamic>>>> fetchAll() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/jsons/mock_schedule_change_requests.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<Map<String, dynamic>> requests = jsonList
          .map((json) => json as Map<String, dynamic>)
          .toList();

      // Merge locally created requests stored in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final localRaw = prefs.getString('local_schedule_change_requests');
      if (localRaw != null) {
        try {
          final List<dynamic> localList = json.decode(localRaw);
          requests.addAll(localList.map((e) => e as Map<String, dynamic>));
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

  int countByStatus(List<Map<String, dynamic>> requests, String status) {
    return requests.where((request) => request['status'] == status).length;
  }
}
