// lib/services/trainee_service.dart

import 'package:get/get.dart';

import '../configs/generic_response.dart';
import '../models/user.dart';
import 'api_service.dart';

class TraineeService {
  ApiService get _api => Get.find<ApiService>();

  Future<GenericResponse<List<User>>> fetchAll() async {
    try {
      final List<dynamic> data = await _api.getList('users');
      final List<User> trainees = data.map((e) => User.fromJson(e)).toList();
      return GenericResponse(
        success: true,
        data: trainees,
        message: 'Lista de practicantes',
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
