// lib/services/admin_home_service.dart

import 'dart:convert';

import 'package:flutter/services.dart';

import '../configs/generic_response.dart';
import '../models/admin_home.dart';

class AdminHomeService {
  Future<GenericResponse<AdminHomeData>> fetchHomeData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/jsons/admin_home.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final AdminHomeData homeData = AdminHomeData.fromJson(jsonMap);

      return GenericResponse(
        success: true,
        data: homeData,
        message: 'Resumen del administrador',
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
}
