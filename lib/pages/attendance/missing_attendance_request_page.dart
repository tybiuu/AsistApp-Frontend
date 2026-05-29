import 'package:flutter/material.dart';

import '../../configs/theme.dart';

class MissingAttendanceRequestPage extends StatelessWidget {
  const MissingAttendanceRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final background = isDark ? const Color(0xff0f1117) : const Color(0xfff7f8fa);
    final cardColor = isDark ? const Color(0xff1A1D27) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.foreground;
    final mutedColor = isDark ? const Color(0xff9ca3af) : AppColors.mutedForeground;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Solicitar asistencia faltante',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xfffff7ed),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xffffd7aa)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded, color: AppColors.chart1),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Usa este formulario si viniste a trabajar pero olvidaste marcar tu asistencia en la app. Al aprobar, tu asistencia quedará registrada sin tardanza.',
                          style: TextStyle(
                            color: AppColors.chart1,
                            fontSize: 13,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  '¿A cuál entrada de trabajo corresponde?',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Entradas de trabajo de hoy · Lunes 4 May',
                  style: TextStyle(color: mutedColor, fontSize: 12),
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? const Color(0xff333333) : AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.work_outline_rounded, color: AppColors.chart1),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Entrada 1', style: TextStyle(color: textColor, fontWeight: FontWeight.w800)),
                            Text('08:00 – 13:00 · 5h', style: TextStyle(color: mutedColor, fontSize: 12)),
                          ],
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded, color: mutedColor),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  'Elige el bloque específico que olvidaste marcar hoy.',
                  style: TextStyle(color: mutedColor, fontSize: 12),
                ),

                const SizedBox(height: 24),

                Text(
                  '¿A qué hora llegaste?',
                  style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? const Color(0xff333333) : AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_rounded, color: AppColors.chart1),
                      const SizedBox(width: 12),
                      Text('8  :  01', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  'Indica la hora aproximada en que ingresaste a tu área de trabajo.',
                  style: TextStyle(color: mutedColor, fontSize: 12),
                ),

                const SizedBox(height: 24),

                Text(
                  '¿Por qué no marcaste?',
                  style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),

                Container(
                  height: 110,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? const Color(0xff333333) : AppColors.border),
                  ),
                  child: Text(
                    'Ej: No tenía el celular a la mano al llegar, luego se me olvidó por completo...',
                    style: TextStyle(color: mutedColor, fontSize: 14, height: 1.4),
                  ),
                ),

                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('0/200', style: TextStyle(color: mutedColor, fontSize: 12)),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.chart1.withOpacity(0.65),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'Enviar solicitud',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}