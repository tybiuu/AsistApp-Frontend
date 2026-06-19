// lib/services/user_service.dart

import 'dart:convert';
import 'package:asist_app/configs/constants.dart';
import 'package:flutter/services.dart';

import '../configs/generic_response.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<GenericResponse<User>> login(String email, String password) async {
    try {
      final String baseURL = Constants.baseUrl;
      final url = Uri.parse('$baseURL/apis/v1/users/login');
      
      final String response = await rootBundle.loadString('assets/jsons/mock_users.json');
      final List<dynamic> data = jsonDecode(response);
      
      Map<String, dynamic>? foundUserMap;

      for (var item in data) {
        if (item['institutionalEmail'] == email && item['password'] == password) {
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
