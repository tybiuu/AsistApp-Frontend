// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:asist_app/components/schedule_card.dart';
import 'package:asist_app/models/schedule.dart';

void main() {
  testWidgets('ScheduleCard exposes editable block actions', (WidgetTester tester) async {
    final schedule = <String, DaySchedule>{
      'Lunes': const DaySchedule(
        enabled: true,
        blocks: [
          ScheduleBlock(type: BlockType.work, start: '09:00', end: '13:00'),
        ],
      ),
    }.obs;

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ScheduleCard(
            schedule: schedule,
            expandedDay: RxnInt(0),
            onToggleDay: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Toca un día y un bloque para editarlo'), findsOneWidget);
    expect(find.text('Agregar bloque'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsWidgets);
  });
}
