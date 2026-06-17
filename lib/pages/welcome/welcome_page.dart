// lib/pages/welcome/welcome_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../components/primary_button.dart';
import '../../configs/theme.dart';
import 'welcome_controller.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late final WelcomeController control;

  late final AnimationController _entryController;
  late final AnimationController _floatingControllerOne;
  late final AnimationController _floatingControllerTwo;
  late final AnimationController _floatingControllerThree;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    control = Get.put(WelcomeController());

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _floatingControllerOne = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _floatingControllerTwo = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);

    _floatingControllerThree = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutCubic,
      ),
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _floatingControllerOne.dispose();
    _floatingControllerTwo.dispose();
    _floatingControllerThree.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _Body(
        fadeAnimation: _fadeAnimation,
        slideAnimation: _slideAnimation,
        floatingOne: _floatingControllerOne,
        floatingTwo: _floatingControllerTwo,
        floatingThree: _floatingControllerThree,
        controller: control,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final AnimationController floatingOne;
  final AnimationController floatingTwo;
  final AnimationController floatingThree;
  final WelcomeController controller;

  const _Body({
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.floatingOne,
    required this.floatingTwo,
    required this.floatingThree,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
              child: Center(
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 360),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _IllustrationMock(
                            firstController: floatingOne,
                            secondController: floatingTwo,
                            thirdController: floatingThree,
                          ),
                          const SizedBox(height: 32),
                          const _WelcomeText(),
                          const SizedBox(height: 28),
                          const _FeaturesSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
            child: FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: Obx(
                  () => Column(
                    children: [
                      PrimaryButton(
                        text: controller.isLoading()
                            ? 'Cargando...'
                            : 'Crear cuenta',
                        onPressed: controller.isLoading()
                            ? () {}
                            : controller.goToRoleSelect,
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        text: 'Ya tengo cuenta',
                        variant: PrimaryButtonVariant.secondary,
                        onPressed: controller.isLoading()
                            ? () {}
                            : controller.goToLogin,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IllustrationMock extends StatelessWidget {
  final AnimationController firstController;
  final AnimationController secondController;
  final AnimationController thirdController;

  const _IllustrationMock({
    required this.firstController,
    required this.secondController,
    required this.thirdController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 228,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 192,
            height: 192,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.chart1.withValues(alpha: 0.15),
            ),
          ),
          Container(
            width: 82,
            height: 82,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.20),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SvgPicture.asset(
              'assets/logo.svg',
              fit: BoxFit.contain,
            ),
          ),
          _FloatingInfoCard(
            controller: firstController,
            beginY: -4,
            endY: 4,
            top: 18,
            right: 8,
            icon: Icons.check_circle,
            iconColor: AppColors.success,
            text: 'Asistencia marcada',
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
            textColor:
                Theme.of(context).colorScheme.onSurface,
          ),
          _FloatingInfoCard(
            controller: secondController,
            beginY: 4,
            endY: -4,
            left: 0,
            bottom: 38,
            icon: Icons.access_time_filled,
            iconColor: AppColors.chart1,
            text: '08:12 AM',
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
            textColor:
                Theme.of(context).colorScheme.onSurface,
          ),
          _FloatingInfoCard(
            controller: thirdController,
            beginY: -2,
            endY: 6,
            right: 24,
            bottom: 12,
            icon: Icons.calendar_month,
            iconColor: Colors.white,
            text: 'Lun–Vie',
            backgroundColor: AppColors.chart1,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _FloatingInfoCard extends StatelessWidget {
  final AnimationController controller;
  final double beginY;
  final double endY;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final IconData icon;
  final Color iconColor;
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const _FloatingInfoCard({
    required this.controller,
    required this.beginY,
    required this.endY,
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = Tween<double>(
      begin: beginY,
      end: endY,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );

    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, animation.value),
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: iconColor,
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeText extends StatelessWidget {
  const _WelcomeText();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Bienvenido a AsistApp',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 30,
            fontWeight: FontWeight.w900,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Gestiona tu asistencia de prácticas preprofesionales desde tu celular',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _FeatureItem(
            icon: Icons.check_circle,
            text: 'Marca asistencia fácil',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _FeatureItem(
            icon: Icons.bar_chart_rounded,
            text: 'Reportes automáticos',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _FeatureItem(
            icon: Icons.access_time_filled,
            text: 'Control de horas',
          ),
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.chart1.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.chart1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 10.5,
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
