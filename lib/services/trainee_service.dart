// lib/services/trainee_service.dart

import 'dart:convert';

import 'package:flutter/services.dart';

import '../configs/generic_response.dart';
import '../models/user.dart';

class TraineeService {
  Future<GenericResponse<List<User>>> fetchAll() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/jsons/mock_trainees.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<User> trainees = jsonList
          .map((json) => User.fromJson(json))
          .where((user) => user.role == UserRole.trainee)
          .toList();

      return GenericResponse(
        success: true,
        data: trainees,
        message: 'Lista de practicantes',
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
