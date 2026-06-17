import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import 'admin_activity_log_controller.dart';
import 'components/activity_entry_card.dart';
import 'components/filter_tabs.dart';

class AdminActivityLogPage extends StatelessWidget {
  const AdminActivityLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminActivityLogController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(top: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: AppTopBar(
                  title: 'Registro de actividad',
                  showBack: true,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Obx(() => FilterTabs(
                        selected: controller.selectedFilter.value,
                        onChanged: controller.setFilter,
                      )),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                sliver: Obx(() {
                  final entries = controller.filteredEntries;
                  if (entries.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 48),
                          child: Text(
                            'No hay registros para este filtro.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          ActivityEntryCard(entry: entries[index]),
                      childCount: entries.length,
                    ),
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}