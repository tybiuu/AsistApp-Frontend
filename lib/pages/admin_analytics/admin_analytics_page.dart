// lib/pages/admin_analytics/admin_analytics_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import '../../configs/routes.dart';
import 'admin_analytics_controller.dart';
import 'components/member_row.dart';
import 'components/summary_grid.dart';
import 'components/lateness_chart.dart';
import 'components/absences_chart.dart';
import 'components/distribution_chart.dart';

class AdminAnalyticsPage extends StatelessWidget {
  const AdminAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminAnalyticsController());
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      body: SafeArea(top: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AppTopBar(
                  title: 'Analíticas',
                  actions: [
                    Text(
                      'Abril 2025',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(
                      'Resumen del mes',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (controller.members.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.groups_outlined,
                              size: 40,
                              color: colors.onSurfaceVariant,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Todavía no tienes practicantes activos',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...controller.members.map(
                        (m) => MemberRow(
                          member: m,
                          onTap: () => Get.toNamed(
                            AppRoutes.adminMemberDetail,
                            arguments: m.toUser(),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Text(
                      'Métricas generales',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SummaryGrid(summary: controller.summary.value!),
                    const SizedBox(height: 16),
                    if (controller.members.isNotEmpty) ...[
                      LatenessChart(ranking: controller.latenessRanking),
                      const SizedBox(height: 16),
                      AbsencesChart(ranking: controller.absencesRanking),
                      const SizedBox(height: 16),
                    ],
                    DistributionChart(summary: controller.summary.value!),
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

