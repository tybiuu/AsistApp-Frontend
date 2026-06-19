import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/app_top_bar.dart';
import '../../components/attendance_record_card.dart';
import '../../components/month_nav_button.dart';
import '../../models/attendance_record.dart';
import '../../utils/date_utils.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  late Future<List<AttendanceRecord>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadRecords();
  }

  Future<List<AttendanceRecord>> _loadRecords() async {
    final jsonString = await rootBundle.loadString(
      'assets/jsons/mock_attendance_records.json',
    );
    final list = jsonDecode(jsonString) as List<dynamic>;
    return list
        .map((j) => AttendanceRecord.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textColor = colors.onSurface;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<AttendanceRecord>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: AppTopBar(title: 'Mi historial', showBack: true),
                ),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (snapshot.hasError)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Error al cargar registros',
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MonthNavButton(icon: Icons.chevron_left_rounded),
                            Text(
                              'Mayo 2026',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            MonthNavButton(icon: Icons.chevron_right_rounded),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...(snapshot.data ?? [])
                            .where((r) => r.status != AttendanceStatus.pending)
                            .map((record) {
                          final status = attendanceStatusText(record);
                          final color = attendanceStatusColor(context, status);

                          return AttendanceRecordCard(
                            date: '${dayAbbrevFromDate(record.date)} ${formatDateShort(record.date)}',
                            status: status,
                            statusColor: color,
                            time: 'Entrada: ${formatTime12h(record.checkIn?.toIso8601String())}  Salida: ${formatTime12h(record.checkOut?.toIso8601String())}',
                            hours: hoursText(record.totalMinutes),
                          );
                        }),
                      ]),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
