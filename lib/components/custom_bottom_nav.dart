import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';

class NavTab {
  final String label;
  final IconData icon;

  const NavTab({
    required this.label,
    required this.icon,
  });
}

class CustomBottomNav extends StatelessWidget {
  final bool isAdmin;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<int> disabledIndices;

  const CustomBottomNav({
    super.key,
    required this.isAdmin,
    required this.currentIndex,
    required this.onTap,
    this.disabledIndices = const [],
  });

  static const practitionerTabs = [
    NavTab(label: 'Inicio', icon: Icons.home_rounded),
    NavTab(label: 'Asistencia', icon: Icons.check_box_rounded),
    NavTab(label: 'Reporte', icon: Icons.bar_chart_rounded),
    NavTab(label: 'Perfil', icon: Icons.person_rounded),
  ];

  static const adminTabs = [
    NavTab(label: 'Inicio', icon: Icons.home_rounded),
    NavTab(label: 'Validar', icon: Icons.check_box_rounded),
    NavTab(label: 'Analíticas', icon: Icons.bar_chart_rounded),
    NavTab(label: 'Config.', icon: Icons.settings_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final tabs = isAdmin ? adminTabs : practitionerTabs;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1A1D27) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final tab = tabs[index];
            final bool isActive = currentIndex == index;
            final bool isDisabled = disabledIndices.contains(index);

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (!isDisabled) {
                    onTap(index);
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Opacity(
                  opacity: isDisabled ? 0.3 : 1.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: (isActive && !isDisabled)
                              ? AppColors.chart1
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          tab.icon,
                          size: 20,
                          color: (isActive && !isDisabled)
                              ? Colors.white
                              : (isDark ? const Color(0xff6b7280) : const Color(0xff9ca3af)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tab.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: (isActive && !isDisabled)
                              ? AppColors.chart1
                              : (isDark ? const Color(0xff6b7280) : const Color(0xff9ca3af)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
