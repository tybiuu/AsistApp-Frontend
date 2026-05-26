import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/input_field.dart';
import '../register_controller.dart';

class PersonalInfoFields extends StatelessWidget {
  const PersonalInfoFields({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InputField(
                label: 'Nombres',
                placeholder: 'Juan Carlos',
                icon: const Icon(Icons.person, size: 18),
                controller: controller.nombresCtrl,
                onChanged: (val) => controller.nombres.value = val,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InputField(
                label: 'Apellidos',
                placeholder: 'Pérez Torres',
                icon: const Icon(Icons.person, size: 18),
                controller: controller.apellidosCtrl,
                onChanged: (val) => controller.apellidos.value = val,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        InputField(
          label: 'Correo institucional',
          placeholder: 'usuario@universidad.edu.pe',
          keyboardType: TextInputType.emailAddress,
          icon: const Icon(Icons.email, size: 18),
          controller: controller.correoCtrl,
          onChanged: (val) => controller.correo.value = val,
        ),
        const SizedBox(height: 16),
        InputField(
          label: 'Celular',
          placeholder: '987 654 321',
          keyboardType: TextInputType.phone,
          icon: const Icon(Icons.phone, size: 18),
          prefixText: '+51',
          controller: controller.celularCtrl,
          onChanged: (val) => controller.celular.value = val,
        ),
      ],
    );
  }
}
