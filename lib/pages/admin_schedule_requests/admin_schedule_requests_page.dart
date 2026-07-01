import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import 'admin_schedule_requests_controller.dart';
import 'components/schedule_request_list_card.dart';

class AdminScheduleRequestsPage extends StatelessWidget {
  const AdminScheduleRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AdminScheduleRequestsController());
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppTopBar(title: 'Solicitudes de horario', showBack: true),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 4),
              child: Obx(
                () => Row(
                  children: [
                    _FilterChip(
                      label: 'Todos',
                      count: c.newCount + c.changeCount,
                      selected: c.selectedFilter.value == ScheduleRequestFilter.all,
                      onTap: () => c.setFilter(ScheduleRequestFilter.all),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Nuevos',
                      count: c.newCount,
                      selected: c.selectedFilter.value == ScheduleRequestFilter.newOnly,
                      onTap: () => c.setFilter(ScheduleRequestFilter.newOnly),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Cambios',
                      count: c.changeCount,
                      selected: c.selectedFilter.value == ScheduleRequestFilter.changeOnly,
                      onTap: () => c.setFilter(ScheduleRequestFilter.changeOnly),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (c.isLoading) {
                  return Center(child: CircularProgressIndicator(color: colors.primary));
                }

                final items = c.filteredItems;
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 48,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No hay solicitudes pendientes',
                          style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: c.reloadAll,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ScheduleRequestListCard(
                        item: item,
                        onViewDetails: () => c.viewDetails(item),
                        onApprove: c.isProcessing.value ? null : () => c.approve(item),
                        onReject: c.isProcessing.value ? null : () => c.reject(item),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? colors.primary : colors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? colors.primary : colors.outlineVariant,
            ),
          ),
          child: Text(
            '$label ($count)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? colors.onPrimary : colors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
