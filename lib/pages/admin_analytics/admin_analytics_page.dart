// lib/pages/admin_analytics/admin_analytics_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import 'admin_analytics_controller.dart';
import 'components/trainees_summary_list.dart';
import 'components/metric_cards_grid.dart';
import 'components/lateness_bar_chart.dart';
import 'components/absences_progress_list.dart';
import 'components/distribution_donut_chart.dart';

class AdminAnalyticsPage extends StatelessWidget {
  const AdminAnalyticsPage({super.key});

  Widget _buildBody(BuildContext context, AdminAnalyticsController controller) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color chevronBg = isDark ? const Color(0xff1A1D27) : const Color(0xfff3f4f6);
    final Color chevronIconColor = isDark ? const Color(0xffd1d5db) : const Color(0xff4b5563);
    final Color monthTextColor = isDark ? const Color(0xffe5e7eb) : const Color(0xff374151);

    return SafeArea(
      child: Column(
        children: [
          // 1. AppTopBar placed inside SafeArea column to respect status bar
          Obx(() => AppTopBar(
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

          // 2. Scrollable content bounded inside Expanded
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6A00)),
                  ),
                );
              }

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Month summary — Practitioners List
                        TraineesSummaryList(controller: controller),
                        const SizedBox(height: 20),

                        // Month summary — KPI cards grid
                        MetricCardsGrid(controller: controller),
                        const SizedBox(height: 20),

                        // Accumulated lateness bar chart
                        LatenessBarChart(controller: controller),
                        const SizedBox(height: 20),

                        // Top absences list with horizontal progress bars
                        AbsencesProgressList(controller: controller),
                        const SizedBox(height: 20),

                        // Monthly distribution donut chart and legend
                        DistributionDonutChart(controller: controller),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),

          // 3. Navigation Bar Bottom Indicator pill matching AdminSetupPage precisely
          Container(
            height: 18,
            color: colors.surfaceContainerLow,
            alignment: Alignment.center,
            child: Container(
              width: 98,
              height: 4,
              decoration: BoxDecoration(
                color: colors.outline,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AdminAnalyticsController controller = Get.put(AdminAnalyticsController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: _buildBody(context, controller),
    );
  }
}
