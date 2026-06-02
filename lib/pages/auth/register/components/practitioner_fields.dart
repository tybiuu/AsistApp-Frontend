import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/number_stepper.dart';
import '../../../../../utils/label_utils.dart';
import '../register_controller.dart';

class PractitionerFields extends StatelessWidget {
  const PractitionerFields({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();
    final colors = Theme.of(context).colorScheme;
    const fieldLabelStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
    const List<String> carreras = [
      'Administración', 'Comunicación', 'Derecho', 'Ingeniería Ambiental',
      'Ingeniería Industrial', 'Ingeniería de Sistemas', 'Negocios Internacionales',
      'Arquitectura', 'Contabilidad y Finanzas', 'Economía', 'Ingeniería Civil',
      'Ingeniería Mecatrónica', 'Marketing', 'Psicología',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text('Carrera', style: fieldLabelStyle.copyWith(color: colors.onSurface)),
        const SizedBox(height: 6),
        Obx(() => DropdownButtonFormField<String>(
          initialValue: controller.selectedCarrera().isEmpty ? null : controller.selectedCarrera(),
          hint: Text(
            'Selecciona tu carrera',
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
          ),
          items: carreras
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: (val) { if (val != null) controller.setCarrera(val); },
          dropdownColor: colors.surfaceContainerHigh,
          style: TextStyle(color: colors.onSurface, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.surfaceContainer,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.outlineVariant),
            ),
          ),
        )),
        const SizedBox(height: 16),
        Text('Ciclo académico', style: fieldLabelStyle.copyWith(color: colors.onSurface)),
        const SizedBox(height: 6),
        Obx(() => NumberStepper(
          value: controller.selectedCiclo.value,
          valueLabel: cicloLabel(controller.selectedCiclo.value),
          canDecrease: controller.selectedCiclo.value > 5,
          canIncrease: controller.selectedCiclo.value < 10,
          onDecrease: controller.decreaseCiclo,
          onIncrease: controller.increaseCiclo,
        )),
      ],
    );
  }
}
