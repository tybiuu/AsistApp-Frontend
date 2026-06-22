// lib/services/user_service.dart

import 'dart:convert';
import 'package:asist_app/configs/constants.dart';
import 'package:http/http.dart' as http;

import '../configs/generic_response.dart';
import '../models/user.dart';
import 'preferences_service.dart';

class UserService {
  final PreferencesService _prefs = PreferencesService();

  Future<GenericResponse<User>> login(String email, String password) async {
    try {
      final String baseURL = Constants.baseUrl;
      final url = Uri.parse('${baseURL}users/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
        }),
      );

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final String token = body['token'] as String;
        final dynamic userData = body['user'];

        // Guardar token en SharedPreferences
        await _prefs.saveToken(token);

        final user = User.fromJson(userData);
        return GenericResponse<User>(
          success: true,
          data: user,
          message: 'Login exitoso',
        );
      } else {
        final String errorMessage = body['error'] as String? ?? 'Credenciales incorrectas.';
        return GenericResponse<User>(
          success: false,
          data: null,
          message: errorMessage,
        );
      }
    } catch (e, stackTrace) {
      return GenericResponse<User>(
        success: false,
        data: null,
        message: 'No se pudo conectar con el servidor.',
        error: stackTrace.toString(),
      );
    }
  }

  Future<GenericResponse<User>> register(User user, String password) async {
    try {
      final String baseURL = Constants.baseUrl;
      final url = Uri.parse('${baseURL}users/register');

      final payload = {
        'firstName': user.firstName,
        'lastName': user.lastName,
        'institutionalEmail': user.institutionalEmail,
        'phoneNumber': user.phoneNumber,
        'career': user.career,
        'cycle': user.cycle,
        'organizationId': user.organizationId,
        'role': user.role.name,
        'status': user.status.name,
        'deviceToken': user.deviceToken,
        'password': password,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final createdUser = User.fromJson(body);
        return GenericResponse<User>(
          success: true,
          data: createdUser,
          message: 'Usuario registrado exitosamente',
        );
      } else {
        final String errorMessage = body['error'] as String? ?? 'Error al registrar el usuario.';
        return GenericResponse<User>(
          success: false,
          data: null,
          message: errorMessage,
        );
      }
    } catch (e, stackTrace) {
      return GenericResponse<User>(
        success: false,
        data: null,
        message: 'No se pudo conectar con el servidor.',
        error: stackTrace.toString(),
      );
    }
  }

  Future<GenericResponse<User>> updateUser(String id, Map<String, dynamic> data) async {
    try {
      final String baseURL = Constants.baseUrl;
      final url = Uri.parse('${baseURL}users/$id');
      final String? token = await _prefs.getToken();

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final updatedUser = User.fromJson(body);
        return GenericResponse<User>(
          success: true,
          data: updatedUser,
          message: 'Usuario actualizado exitosamente',
        );
      } else {
        final String errorMessage = body['error'] as String? ?? 'Error al actualizar el usuario.';
        return GenericResponse<User>(
          success: false,
          data: null,
          message: errorMessage,
        );
      }
    } catch (e, stackTrace) {
      return GenericResponse<User>(
        success: false,
        data: null,
        message: 'No se pudo conectar con el servidor.',
        error: stackTrace.toString(),
      );
    }
  }
}
