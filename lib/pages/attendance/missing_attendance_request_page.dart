import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../configs/theme.dart';

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

  String _formatDate(String date) {
    final parts = date.split('-');
    if (parts.length != 3) return date;

    const months = {
      '01': 'ene',
      '02': 'feb',
      '03': 'mar',
      '04': 'abr',
      '05': 'may',
      '06': 'jun',
      '07': 'jul',
      '08': 'ago',
      '09': 'sep',
      '10': 'oct',
      '11': 'nov',
      '12': 'dic',
    };

    return '${parts[2]} ${months[parts[1]] ?? parts[1]}';
  }

  String _formatTimeFromIso(String value) {
    if (value.length < 16) return '--:--';

    final hour = int.tryParse(value.substring(11, 13)) ?? 0;
    final minute = value.substring(14, 16);

    final suffix = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    return '${hour12.toString().padLeft(2, '0')}:$minute $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final background =
        isDark ? const Color(0xff0f1117) : const Color(0xfff7f8fa);
    final cardColor = isDark ? const Color(0xff1A1D27) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.foreground;
    final mutedColor =
        isDark ? const Color(0xff9ca3af) : AppColors.mutedForeground;
    final borderColor = isDark ? const Color(0xff333333) : AppColors.border;

    return Scaffold(
      backgroundColor: background,
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
                    _formatDate(request['requested_date'].toString());
                final createdAt =
                    _formatTimeFromIso(request['created_at'].toString());
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
                          backgroundColor: AppColors.chart1.withOpacity(0.65),
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