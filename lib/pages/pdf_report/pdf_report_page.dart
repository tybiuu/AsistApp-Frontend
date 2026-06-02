import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../configs/theme.dart';

import '../../components/app_top_bar.dart';
import 'components/month_picker.dart';
import 'pdf_report_controller.dart';
import 'components/document_preview.dart';

class PdfReportPage extends StatelessWidget {
  const PdfReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PdfReportController());
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.current == null) {
            return const Center(child: Text('Error al cargar datos'));
          }

          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: AppTopBar(
                  title: 'Control de asistencia',
                  showBack: true,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Obx(() => MonthPicker(
                          months: controller.monthNames,
                          selectedIndex: controller.selectedIndex.value,
                          onChanged: controller.selectMonth,
                        )),
                    const SizedBox(height: 16),
                    Obx(() => DocumentPreview(
                      trainee: controller.trainee,
                      month: controller.current!,
                    )),
                    const SizedBox(height: 16),
                    // Info notice
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xff1d4ed8).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xff1d4ed8).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: Color(0xff1d4ed8),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Las firmas deben completarse a mano antes de entregar al centro de empleabilidad.',
                              style: TextStyle(
                                color: colors.onSurface,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Download button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: () {}, // PDF generation will be wired up later
                        icon: const Icon(Icons.download_rounded, color: Colors.white),
                        label: const Text(
                          'Descargar PDF',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.chart1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
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