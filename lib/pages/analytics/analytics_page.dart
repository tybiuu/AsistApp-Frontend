import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import 'analytics_controller.dart';
import 'components/hours_card.dart';
import 'components/stats_grid.dart';
import 'components/distribution_chart.dart';
import 'components/overall_progress_card.dart';
import 'components/pdf_button.dart';  
import '../../configs/routes.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnalyticsController());
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = controller.current;
          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }
  
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AppTopBar(
                  title: 'Mi reporte',
                  actions: [
                    Obx(() => GestureDetector(
                      onTap: controller.canGoPrev ? controller.prevMonth : null,
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: controller.canGoPrev
                            ? colors.onSurface
                            : colors.onSurfaceVariant,
                      ),
                    )),
                    const SizedBox(width: 8),
                    Obx(() => Text(
                      controller.current?.month ?? '',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                    const SizedBox(width: 8),
                    Obx(() => GestureDetector(
                      onTap: controller.canGoNext ? controller.nextMonth : null,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: controller.canGoNext
                            ? colors.onSurface
                            : colors.onSurfaceVariant,
                      ),
                    )),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    HoursCard(data: data),
                    const SizedBox(height: 16),
                    StatsGrid(data: data),
                    const SizedBox(height: 16),
                    DistributionChart(data: data),
                    const SizedBox(height: 16),
                    OverallProgressCard(data: data),
                    const SizedBox(height: 16),
                    PdfButton(onTap: () => Get.toNamed(AppRoutes.pdfReport)), // navigation will be wired up later
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}