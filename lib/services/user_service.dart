// lib/services/user_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';

import '../configs/generic_response.dart';
import '../models/user.dart';

class UserService {
  /// Simulates a login request by fetching local mock users and verifying credentials.
  Future<GenericResponse<User>> login(String email, String password) async {
    try {
      // Load mock users JSON from app assets
      final String response = await rootBundle.loadString('assets/jsons/mock_users.json');
      final List<dynamic> data = jsonDecode(response);
      
      Map<String, dynamic>? foundUserMap;

      for (var item in data) {
        if (item['institutional_email'] == email && item['password'] == password) {
          foundUserMap = item;
          break;
        }
      }

      if (foundUserMap != null) {
        final user = User.fromJson(foundUserMap);
        return GenericResponse<User>(
          success: true,
          data: user,
          message: 'Login exitoso',
        );
      } else {
        return GenericResponse<User>(
          success: false,
          data: null,
          message: 'Credenciales incorrectas. Intenta con admin@ulima.edu.pe o practicante@ulima.edu.pe',
        );
      }
    } catch (e, stackTrace) {
      return GenericResponse<User>(
        success: false,
        data: null,
        message: 'Ocurrió un error al cargar los datos de prueba.',
        error: stackTrace.toString(),
      );
    }
  }
}
