import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../configs/theme.dart';
import '../../utils/date_utils.dart';

class MissingAttendanceRequestPage extends StatelessWidget {
  const MissingAttendanceRequestPage({super.key});

  Future<Map<String, dynamic>> _loadRequest() async {
    final jsonString = await rootBundle.loadString(
      'assets/jsons/mock_attendance_requests.json',
    );

    final List<dynamic> requests = jsonDecode(jsonString);

    return requests.firstWhere(
      (item) => item['status'] == 'pending',
      orElse: () => requests.first,
    ) as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final cardColor = colors.surfaceContainerHigh;
    final textColor = colors.onSurface;
    final mutedColor = colors.onSurfaceVariant;
    final borderColor = colors.outlineVariant;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: FutureBuilder<Map<String, dynamic>>(
              future: _loadRequest(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error al cargar solicitud',
                      style: TextStyle(color: textColor),
                    ),
                  );
                }

                final request = snapshot.data!;
                final requestedDate =
                    formatDateShort(request['requested_date'].toString());
                final createdAt =
                    formatTime12h(request['created_at'].toString());
                final reason = request['reason'].toString();

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Solicitar asistencia faltante',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
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
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.chart1,
                          ),
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
                      'Solicitud registrada para el $requestedDate',
                      style: TextStyle(color: mutedColor, fontSize: 12),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.work_outline_rounded,
                            color: AppColors.chart1,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Entrada registrada',
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Fecha: $requestedDate',
                                  style: TextStyle(
                                    color: mutedColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: mutedColor,
                          ),
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
                      '¿A qué hora realizaste la solicitud?',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            color: AppColors.chart1,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            createdAt,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'Hora tomada desde el JSON mock de solicitudes.',
                      style: TextStyle(color: mutedColor, fontSize: 12),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      '¿Por qué no marcaste?',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      constraints: const BoxConstraints(minHeight: 110),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Text(
                        reason,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${reason.length}/200',
                        style: TextStyle(color: mutedColor, fontSize: 12),
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.chart1.withValues(alpha: 0.65),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Enviar solicitud',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}