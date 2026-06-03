import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/app_top_bar.dart';
import 'schedule_change_controller.dart';
import 'components/editor_view.dart';
import 'components/status_view.dart';

class ScheduleChangePage extends StatelessWidget {
  const ScheduleChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ScheduleChangeController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(
              title: 'Configura tu horario',
              showBack: true,
            ),
            Expanded(
              child: Obx(() => c.isSubmitted.value ? const StatusView() : const EditorView()),
            ),
          ],
        ),
      ),
    );
  }
}