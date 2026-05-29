import 'package:flutter/material.dart';

class AdminValidatePage extends StatelessWidget {
  const AdminValidatePage({super.key});

  static const Color orange = Color(0xFFFF6A00);
  static const Color bg = Color(0xFF1F1F1F);
  static const Color card = Color(0xFF2A2A2A);
  static const Color border = Color(0xFF3A3A3A);
  static const Color muted = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: const [
            _Header(),
            SizedBox(height: 18),
            _SectionTitle(title: 'Esperando validación', count: '4'),
            SizedBox(height: 12),
            _ValidateCard(
              initials: 'JP',
              name: 'Juan Pérez Torres',
              career: 'Practicante · 30h/sem',
              status: 'Tardanza',
              statusColor: Color(0xFFF59E0B),
              inTime: '08:12',
              snackStart: '13:00',
              snackEnd: '14:00',
              outTime: '17:00',
            ),
            SizedBox(height: 12),
            _ValidateCard(
              initials: 'CQ',
              name: 'Carla Quispe Rojas',
              career: 'Practicante · 30h/sem',
              status: 'A tiempo',
              statusColor: Color(0xFF22C55E),
              inTime: '07:55',
              snackStart: '13:00',
              snackEnd: '14:00',
              outTime: '17:00',
            ),
            SizedBox(height: 12),
            _ValidateCard(
              initials: 'PR',
              name: 'Patricia Rojas Castillo',
              career: 'Practicante · 25h/sem',
              status: 'A tiempo',
              statusColor: Color(0xFF22C55E),
              inTime: '09:03',
              snackStart: null,
              snackEnd: null,
              outTime: '14:00',
            ),
            SizedBox(height: 24),
            _SectionTitle(title: 'Aún no han marcado', count: '1'),
            SizedBox(height: 12),
            _MissingCard(
              initials: 'RF',
              name: 'Roberto Flores Díaz',
              career: 'Practicante · 20h/sem',
              inTime: '14:00',
              outTime: '19:00',
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Validar asistencia',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AdminValidatePage.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AdminValidatePage.border),
          ),
          child: const Row(
            children: [
              Icon(Icons.calendar_today_rounded, color: AdminValidatePage.orange, size: 16),
              SizedBox(width: 8),
              Text(
                'Hoy, 28 abr',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String count;

  const _SectionTitle({
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AdminValidatePage.muted,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.7,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: const BoxDecoration(
            color: AdminValidatePage.orange,
            shape: BoxShape.circle,
          ),
          child: Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _ValidateCard extends StatelessWidget {
  final String initials;
  final String name;
  final String career;
  final String status;
  final Color statusColor;
  final String inTime;
  final String? snackStart;
  final String? snackEnd;
  final String outTime;

  const _ValidateCard({
    required this.initials,
    required this.name,
    required this.career,
    required this.status,
    required this.statusColor,
    required this.inTime,
    required this.snackStart,
    required this.snackEnd,
    required this.outTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AdminValidatePage.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AdminValidatePage.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                _Avatar(initials: initials),
                const SizedBox(width: 12),
                Expanded(
                  child: _PersonInfo(name: name, career: career),
                ),
                _StatusBadge(text: status, color: statusColor),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(
                  child: _TimeBox(
                    label: 'IN',
                    time: inTime,
                    color: status == 'Tardanza'
                        ? const Color(0xFFF97316)
                        : const Color(0xFF22C55E),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TimeBox(
                    label: 'REF. IN',
                    time: snackStart ?? '-',
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TimeBox(
                    label: 'REF. OUT',
                    time: snackEnd ?? '-',
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TimeBox(
                    label: 'OUT',
                    time: outTime,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminValidatePage.orange,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(18),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Validar →',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MissingCard extends StatelessWidget {
  final String initials;
  final String name;
  final String career;
  final String inTime;
  final String outTime;

  const _MissingCard({
    required this.initials,
    required this.name,
    required this.career,
    required this.inTime,
    required this.outTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AdminValidatePage.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2563EB)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          _Avatar(initials: initials),
          const SizedBox(width: 12),
          Expanded(
            child: _PersonInfo(name: name, career: career),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const _StatusBadge(
                text: 'Sin marcar',
                color: Color(0xFF3B82F6),
              ),
              const SizedBox(height: 8),
              Text(
                '$inTime - $outTime',
                style: const TextStyle(
                  color: AdminValidatePage.muted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;

  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AdminValidatePage.orange,
      radius: 22,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _PersonInfo extends StatelessWidget {
  final String name;
  final String career;

  const _PersonInfo({
    required this.name,
    required this.career,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          career,
          style: const TextStyle(
            color: AdminValidatePage.muted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusBadge({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String label;
  final String time;
  final Color color;

  const _TimeBox({
    required this.label,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}