import 'package:flutter/material.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xffff6a00),
      surfaceTint: Color(0xffff6a00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffddcc),
      onPrimaryContainer: Color(0xff5c1900),
      secondary: Color(0xfff1f1f3),
      onSecondary: Color(0xff030213),
      secondaryContainer: Color(0xffececf0),
      onSecondaryContainer: Color(0xff030213),
      tertiary: Color(0xffe9ebef),
      onTertiary: Color(0xff030213),
      tertiaryContainer: Color(0xffececf0),
      onTertiaryContainer: Color(0xff030213),
      error: Color(0xffd4183d),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffd9df),
      onErrorContainer: Color(0xff5f0014),
      surface: Color(0xffffffff),
      onSurface: Color(0xff242424),
      onSurfaceVariant: Color(0xff717182),
      outline: Color(0x1a000000),
      outlineVariant: Color(0xffe9ebef),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff242424),
      inversePrimary: Color(0xffffb380),
      primaryFixed: Color(0xffffddcc),
      onPrimaryFixed: Color(0xff5c1900),
      primaryFixedDim: Color(0xffffb380),
      onPrimaryFixedVariant: Color(0xff5c1900),
      secondaryFixed: Color(0xfff1f1f3),
      onSecondaryFixed: Color(0xff030213),
      secondaryFixedDim: Color(0xffececf0),
      onSecondaryFixedVariant: Color(0xff030213),
      tertiaryFixed: Color(0xffe9ebef),
      onTertiaryFixed: Color(0xff030213),
      tertiaryFixedDim: Color(0xffececf0),
      onTertiaryFixedVariant: Color(0xff030213),
      surfaceDim: Color(0xfff3f3f5),
      surfaceBright: Color(0xffffffff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f7f8),
      surfaceContainer: Color(0xfff3f3f5),
      surfaceContainerHigh: Color(0xffececf0),
      surfaceContainerHighest: Color(0xffe9ebef),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffff6a00),
      surfaceTint: Color(0xffff6a00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb34c00),
      onPrimaryContainer: Color(0xffffddcc),
      secondary: Color(0xff444444),
      onSecondary: Color(0xfffafafa),
      secondaryContainer: Color(0xff333333),
      onSecondaryContainer: Color(0xfffafafa),
      tertiary: Color(0xff333333),
      onTertiary: Color(0xfffafafa),
      tertiaryContainer: Color(0xff444444),
      onTertiaryContainer: Color(0xfffafafa),
      error: Color(0xff9f273d),
      onError: Color(0xffff8b99),
      errorContainer: Color(0xff5f0014),
      onErrorContainer: Color(0xffffd9df),
      surface: Color(0xff2d2c37),
      onSurface: Color(0xfffafafa),
      onSurfaceVariant: Color(0xffa9a9a9),
      outline: Color(0xff333333),
      outlineVariant: Color(0xff444444),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfffafafa),
      inversePrimary: Color(0xffff6a00),
      primaryFixed: Color(0xffffddcc),
      onPrimaryFixed: Color(0xff5c1900),
      primaryFixedDim: Color(0xffff6a00),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff444444),
      onSecondaryFixed: Color(0xfffafafa),
      secondaryFixedDim: Color(0xff333333),
      onSecondaryFixedVariant: Color(0xfffafafa),
      tertiaryFixed: Color(0xff444444),
      onTertiaryFixed: Color(0xfffafafa),
      tertiaryFixedDim: Color(0xff333333),
      onTertiaryFixedVariant: Color(0xfffafafa),
      surfaceDim: Color(0xff171717),
      surfaceBright: Color(0xff333333),
      surfaceContainerLowest: Color(0xff0a0a0a),
      surfaceContainerLow: Color(0xff242029),
      surfaceContainer: Color(0xff242424),
      surfaceContainerHigh: Color(0xff2b2b2b),
      surfaceContainerHighest: Color(0xff333333),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );
}

class AppColors {
  const AppColors._();
  static const Color background = Color(0xffffffff);
  static const Color foreground = Color(0xff242424);
  static const Color card = Color(0xffffffff);
  static const Color cardForeground = Color(0xff242424);
  static const Color popover = Color(0xffffffff);
  static const Color popoverForeground = Color(0xff242424);
  static const Color primary = Color(0xffff6a00);
  static const Color primaryForeground = Color(0xffffffff);
  static const Color secondary = Color(0xfff1f1f3);
  static const Color secondaryForeground = Color(0xff030213);
  static const Color muted = Color(0xffececf0);
  static const Color mutedForeground = Color(0xff717182);
  static const Color accent = Color(0xffe9ebef);
  static const Color accentForeground = Color(0xff030213);
  static const Color destructive = Color(0xffd4183d);
  static const Color destructiveForeground = Color(0xffffffff);
  static const Color border = Color(0x1a000000);
  static const Color inputBackground = Color(0xfff3f3f5);
  static const Color switchBackground = Color(0xffcbced4);
  static const Color ring = Color(0xffa9a9a9);

  static const Color success = Color(0xff16a34a);
  static const Color warning = Color(0xfff59e0b);
  static const Color error = Color(0xffef4444);
  static const Color info = Color(0xff1d4ed8);

  static const Color chart1 = Color(0xffe15d27);
  static const Color chart2 = Color(0xff1d9ba4);
  static const Color chart3 = Color(0xff3f5f8a);
  static const Color chart4 = Color(0xffe9c521);
  static const Color chart5 = Color(0xffefaa17);
  static const Color chart6 = Color(0xff0ea5e9);
  static const Color chart7 = Color(0xff7c3aed);
}