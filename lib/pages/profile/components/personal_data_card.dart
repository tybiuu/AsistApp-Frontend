// lib/pages/profile/components/personal_data_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../components/number_stepper.dart';
import '../../../configs/theme.dart';
import '../../../models/schedule.dart';
import '../profile_controller.dart';

/// Card that shows personal data in view mode and a form in edit mode.
class PersonalDataCard extends StatelessWidget {
  const PersonalDataCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(
      () => _Card(
        isDark: isDark,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardHeader(c: c, isDark: isDark),
            if (c.editing.value)
              _EditForm(c: c, isDark: isDark)
            else
              _ViewRows(c: c, isDark: isDark),
          ],
        ),
      ),
    );
  }
}

// ── Shell ─────────────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final bool isDark;
  final Widget child;
  const _Card({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xff1A1D27) : Colors.white;
    final border = isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

// ── Card header ───────────────────────────────────────────────────────────────

class _CardHeader extends StatelessWidget {
  final ProfileController c;
  final bool isDark;
  const _CardHeader({required this.c, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final border = isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);
    final onCard = isDark ? Colors.white : const Color(0xff1f2937);
    final muted = isDark ? const Color(0xff6b7280) : const Color(0xff9ca3af);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Mis datos',
            style: TextStyle(
              color: onCard,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Obx(
            () => c.editing.value
                ? Row(
                    children: [
                      _IconTextBtn(
                        icon: Icons.close,
                        label: 'Cancelar',
                        color: muted,
                        onTap: c.cancelEdit,
                      ),
                    ],
                  )
                : _IconTextBtn(
                    icon: Icons.edit_outlined,
                    label: 'Editar',
                    color: AppColors.chart1,
                    onTap: c.startEdit,
                  ),
          ),
        ],
      ),
    );
  }
}

class _IconTextBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _IconTextBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

// ── View rows ─────────────────────────────────────────────────────────────────

class _ViewRows extends StatelessWidget {
  final ProfileController c;
  final bool isDark;
  const _ViewRows({required this.c, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final border = isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);
    final label = isDark ? const Color(0xff9ca3af) : const Color(0xff6b7280);
    final value = isDark ? Colors.white : const Color(0xff1f2937);

    final rows = [
      (Icons.person_outline, 'Nombres', c.firstName),
      (Icons.person_outline, 'Apellidos', c.lastName),
      (Icons.phone_outlined, 'Celular', '+51 ${c.phone}'),
      (Icons.school_outlined, 'Carrera', c.career.isEmpty ? '—' : c.career),
      (Icons.menu_book_outlined, 'Ciclo', cicloLabel(c.cycle)),
    ];

    return Column(
      children: rows.asMap().entries.map((e) {
        final i = e.key;
        final row = e.value;
        return Container(
          decoration: BoxDecoration(
            border: i < rows.length - 1
                ? Border(bottom: BorderSide(color: border))
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Icon(row.$1, size: 15, color: const Color(0xfffb923c)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(row.$2, style: TextStyle(color: label, fontSize: 10)),
                    const SizedBox(height: 2),
                    Text(
                      row.$3,
                      style: TextStyle(
                        color: value,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Edit form ─────────────────────────────────────────────────────────────────

class _EditForm extends StatelessWidget {
  final ProfileController c;
  final bool isDark;
  const _EditForm({required this.c, required this.isDark});

  Color get _inputBg =>
      isDark ? const Color(0xff242836) : const Color(0xfff9fafb);
  Color get _border =>
      isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);
  Color get _label =>
      isDark ? const Color(0xff9ca3af) : const Color(0xff6b7280);
  Color get _muted =>
      isDark ? const Color(0xff6b7280) : const Color(0xff9ca3af);
  Color get _value => isDark ? Colors.white : const Color(0xff1f2937);

  InputDecoration _decoration() => InputDecoration(
    filled: true,
    fillColor: _inputBg,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: _border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: _border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.chart1),
    ),
  );

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _field('Nombres', Icons.person_outline, c.cFirstName),
        const SizedBox(height: 12),
        _field('Apellidos', Icons.person_outline, c.cLastName),
        const SizedBox(height: 12),
        _phoneField(),
        const SizedBox(height: 12),
        _CarreraDropdown(c: c, isDark: isDark),
        const SizedBox(height: 12),
        Obx(
          () => NumberStepper(
            icon: Icons.menu_book_outlined,
            title: 'Ciclo académico',
            value: c.dCiclo.value,
            valueLabel: cicloLabel(c.dCiclo.value),
            canDecrease: c.dCiclo.value > 5,
            canIncrease: c.dCiclo.value < 10,
            onDecrease: c.decrementCiclo,
            onIncrease: c.incrementCiclo,
          ),
        ),
        const SizedBox(height: 16),
        _saveBtn(),
      ],
    ),
  );

  Widget _labelRow(String text, IconData icon) => Row(
    children: [
      Icon(icon, size: 12, color: _label),
      const SizedBox(width: 5),
      Text(
        text,
        style: TextStyle(
          color: _label,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );

  Widget _field(String label, IconData icon, TextEditingController ctrl) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelRow(label, icon),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            style: TextStyle(color: _value, fontSize: 14),
            decoration: _decoration(),
          ),
        ],
      );

  Widget _phoneField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _labelRow('Celular', Icons.phone_outlined),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: _inputBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            Text(
              '+51',
              style: TextStyle(
                color: _muted,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(width: 1, height: 18, color: _border),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: c.cPhone,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(color: _value, fontSize: 14),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _saveBtn() => GestureDetector(
    onTap: c.saveEdit,
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.chart1,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Guardar cambios',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

// ── Carrera dropdown ──────────────────────────────────────────────────────────

class _CarreraDropdown extends StatelessWidget {
  final ProfileController c;
  final bool isDark;
  const _CarreraDropdown({required this.c, required this.isDark});

  Color get _inputBg =>
      isDark ? const Color(0xff242836) : const Color(0xfff9fafb);
  Color get _border =>
      isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);
  Color get _label =>
      isDark ? const Color(0xff9ca3af) : const Color(0xff6b7280);
  Color get _muted =>
      isDark ? const Color(0xff6b7280) : const Color(0xff9ca3af);
  Color get _value => isDark ? Colors.white : const Color(0xff1f2937);
  Color get _cardBg => isDark ? const Color(0xff1A1D27) : Colors.white;

  @override
  Widget build(BuildContext context) => Obx(() {
    final isOpen = c.carreraOpen.value;
    final selected = c.dCarrera.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.school_outlined, size: 12, color: _label),
            const SizedBox(width: 5),
            Text(
              'Carrera',
              style: TextStyle(
                color: _label,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Trigger
        GestureDetector(
          onTap: c.toggleCarreraDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: _inputBg,
              borderRadius: isOpen
                  ? const BorderRadius.vertical(top: Radius.circular(12))
                  : BorderRadius.circular(12),
              border: Border.all(color: isOpen ? AppColors.chart1 : _border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selected.isEmpty ? 'Selecciona tu carrera' : selected,
                    style: TextStyle(
                      color: selected.isEmpty ? _muted : _value,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  isOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: _muted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        // List
        if (isOpen)
          Container(
            constraints: const BoxConstraints(maxHeight: 180),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
              border: Border(
                left: BorderSide(color: AppColors.chart1),
                right: BorderSide(color: AppColors.chart1),
                bottom: BorderSide(color: AppColors.chart1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: c.carreras.length,
                itemBuilder: (_, i) {
                  final carrera = c.carreras[i];
                  final isActive = carrera == selected;
                  return GestureDetector(
                    onTap: () => c.selectCarrera(carrera),
                    child: Container(
                      color: isActive
                          ? AppColors.chart1.withValues(
                              alpha: isDark ? 0.15 : 0.08,
                            )
                          : Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      child: Text(
                        carrera,
                        style: TextStyle(
                          color: isActive
                              ? (isDark
                                    ? const Color(0xfffb923c)
                                    : AppColors.chart1)
                              : _value,
                          fontSize: 14,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  });
}
