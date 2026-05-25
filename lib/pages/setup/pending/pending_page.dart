// lib/pages/auth/pending_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/theme.dart';
import 'pending_controller.dart';

class PendingPage extends StatefulWidget {
  const PendingPage({super.key});

  @override
  State<PendingPage> createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PendingController());
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> steps = [
      {'step': '1', 'text': 'El jefe de área revisa tu solicitud', 'done': true},
      {'step': '2', 'text': 'Recibirás un correo con la decisión', 'done': false},
      {'step': '3', 'text': 'Propones tu horario semanal', 'done': false},
      {'step': '4', 'text': '¡Empiezas a usar AsistApp!', 'done': false},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Role icon with subtle rotation animation
                RotationTransition(
                  turns: Tween(begin: -0.05, end: 0.05).animate(CurvedAnimation(
                    parent: _rotationController,
                    curve: Curves.easeInOut,
                  )),
                  child: Container(
                    width: 96,
                    height: 96,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.chart1.withValues(alpha: 0.3) : const Color(0xfffff7ed),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.access_time_filled,
                        size: 40,
                        color: AppColors.chart1,
                      ),
                    ),
                  ),
                ),

                // Role badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.chart1.withValues(alpha: 0.3) : const Color(0xfffff7ed),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.school_rounded, size: 13, color: AppColors.chart1),
                      const SizedBox(width: 6),
                      Text(
                        'Practicante',
                        style: TextStyle(
                          color: AppColors.chart1,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  'Solicitud enviada',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: 'Tu solicitud para unirte a '),
                      TextSpan(
                        text: 'ITLAB',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const TextSpan(
                        text: ' está pendiente de aprobación. Te notificaremos cuando el jefe de área la revise.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xff1e3a8a).withValues(alpha: 0.3) : const Color(0xffdbeafe),
                    border: Border.all(
                      color: isDark ? const Color(0xff1d4ed8) : const Color(0xffbfdbfe),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Pendiente de aprobación',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xff60a5fa) : const Color(0xff1d4ed8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Timeline
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¿Qué sigue?',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...steps.map((s) {
                        final bool isDone = s['done'] as bool;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  color: isDone ? AppColors.chart1 : Theme.of(context).colorScheme.surfaceContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    s['step'] as String,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isDone ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  s['text'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDone 
                                      ? Theme.of(context).colorScheme.onSurface 
                                      : Theme.of(context).colorScheme.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
