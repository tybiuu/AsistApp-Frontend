// lib/pages/analytics/analytics_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import 'analytics_controller.dart';
import 'components/trainees_summary_list.dart';
import 'components/metric_cards_grid.dart';
import 'components/lateness_bar_chart.dart';
import 'components/absences_progress_list.dart';
import 'components/distribution_donut_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AnalyticsController controller = Get.put(AnalyticsController());
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color chevronBg = isDark ? const Color(0xff1A1D27) : const Color(0xfff3f4f6);
    final Color chevronIconColor = isDark ? const Color(0xffd1d5db) : const Color(0xff4b5563);
    final Color monthTextColor = isDark ? const Color(0xffe5e7eb) : const Color(0xff374151);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Obx(() => AppTopBar(
          title: 'Analíticas',
          showBack: false,
          actions: [
            Row(
              children: [
                // Previous month button
                GestureDetector(
                  onTap: controller.previousMonth,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: chevronBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.chevron_left_rounded,
                      size: 18,
                      color: chevronIconColor,
                    ),
                  ),
                ),
                
                // Current month name
                Container(
                  constraints: const BoxConstraints(minWidth: 90),
                  child: Text(
                    controller.formattedMonth,
                    style: TextStyle(
                      color: monthTextColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                // Next month button
                GestureDetector(
                  onTap: controller.nextMonth,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: chevronBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: chevronIconColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6A00)),
                  ),
                );
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Month summary — Practitioners List
                    TraineesSummaryList(controller: controller),
                    const SizedBox(height: 20),

                    // 2. Month summary — KPI cards grid
                    MetricCardsGrid(controller: controller),
                    const SizedBox(height: 20),

                    // 3. Accumulated lateness bar chart
                    LatenessBarChart(controller: controller),
                    const SizedBox(height: 20),

                    // 4. Top absences list with horizontal progress bars
                    AbsencesProgressList(controller: controller),
                    const SizedBox(height: 20),

                    // 5. Monthly distribution donut chart and legend
                    DistributionDonutChart(controller: controller),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
