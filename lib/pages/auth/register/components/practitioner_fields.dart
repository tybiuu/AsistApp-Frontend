import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../register_controller.dart';

class PractitionerFields extends StatelessWidget {
  const PractitionerFields({super.key});

  String _getCicloLabel(int n) {
    const suffixes = {
      1: 'er', 2: 'do', 3: 'er', 4: 'to', 5: 'to',
      6: 'to', 7: 'mo', 8: 'vo', 9: 'no', 10: 'mo'
    };
    return '$n${suffixes[n] ?? 'mo'} ciclo';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();
    final List<String> carreras = [
      'Administración', 'Comunicación', 'Derecho', 'Ingeniería Ambiental',
      'Ingeniería Industrial', 'Ingeniería de Sistemas', 'Negocios Internacionales',
      'Arquitectura', 'Contabilidad y Finanzas', 'Economía', 'Ingeniería Civil',
      'Ingeniería Mecatrónica', 'Marketing', 'Psicología',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text(
          'Carrera',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Obx(() => DropdownButtonFormField<String>(
          initialValue: controller.selectedCarrera().isEmpty ? null : controller.selectedCarrera(),
          hint: Text(
            'Selecciona tu carrera',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          items: carreras.map((c) => DropdownMenuItem(
            value: c,
            child: Text(c),
          )).toList(),
          onChanged: (val) {
            if (val != null) controller.setCarrera(val);
          },
          dropdownColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
        )),
        const SizedBox(height: 16),
        Text(
          'Ciclo académico',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: controller.decreaseCiclo,
                icon: const Icon(Icons.remove),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                ),
              ),
              Expanded(
                child: Obx(() => Column(
                  children: [
                    Text(
                      '${controller.selectedCiclo()}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xfff97316),
                      ),
                    ),
                    Text(
                      _getCicloLabel(controller.selectedCiclo()),
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                )),
              ),
              IconButton(
                onPressed: controller.increaseCiclo,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
