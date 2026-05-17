import 'package:flutter/material.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff030213),
      surfaceTint: Color(0xff030213),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffe9ebef),
      onPrimaryContainer: Color(0xff030213),
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
      inversePrimary: Color(0xffffffff),
      primaryFixed: Color(0xffe9ebef),
      onPrimaryFixed: Color(0xff030213),
      primaryFixedDim: Color(0xffececf0),
      onPrimaryFixedVariant: Color(0xff030213),
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
      surfaceContainerLow: Color(0xfffafafa),
      surfaceContainer: Color(0xfff3f3f5),
      surfaceContainerHigh: Color(0xffececf0),
      surfaceContainerHighest: Color(0xffe9ebef),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff030213),
      surfaceTint: Color(0xff030213),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff030213),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff30303a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff717182),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff30303a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff717182),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8f0024),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffd4183d),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xffffffff),
      onSurface: Color(0xff111111),
      onSurfaceVariant: Color(0xff30303a),
      outline: Color(0xff717182),
      outlineVariant: Color(0xffa5a5b0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff242424),
      inversePrimary: Color(0xffffffff),
      primaryFixed: Color(0xff030213),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff30303a),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff717182),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff30303a),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff717182),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff30303a),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffececf0),
      surfaceBright: Color(0xffffffff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f5),
      surfaceContainer: Color(0xffececf0),
      surfaceContainerHigh: Color(0xffe9ebef),
      surfaceContainerHighest: Color(0xffd9d9df),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff000000),
      surfaceTint: Color(0xff030213),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff030213),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff202026),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff30303a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff202026),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff30303a),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff650018),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffa9002d),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xffffffff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff202026),
      outlineVariant: Color(0xff30303a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff242424),
      inversePrimary: Color(0xffffffff),
      primaryFixed: Color(0xff030213),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff000000),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff30303a),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff202026),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff30303a),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff202026),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffececf0),
      surfaceBright: Color(0xffffffff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f5),
      surfaceContainer: Color(0xffececf0),
      surfaceContainerHigh: Color(0xffd9d9df),
      surfaceContainerHighest: Color(0xffc9c9d0),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffafafa),
      surfaceTint: Color(0xfffafafa),
      onPrimary: Color(0xff343434),
      primaryContainer: Color(0xff333333),
      onPrimaryContainer: Color(0xfffafafa),
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
      surface: Color(0xff242424),
      onSurface: Color(0xfffafafa),
      onSurfaceVariant: Color(0xffa9a9a9),
      outline: Color(0xff333333),
      outlineVariant: Color(0xff444444),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfffafafa),
      inversePrimary: Color(0xff030213),
      primaryFixed: Color(0xfffafafa),
      onPrimaryFixed: Color(0xff242424),
      primaryFixedDim: Color(0xffa9a9a9),
      onPrimaryFixedVariant: Color(0xff333333),
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
      surfaceContainerLowest: Color(0xff111111),
      surfaceContainerLow: Color(0xff1f1f1f),
      surfaceContainer: Color(0xff242424),
      surfaceContainerHigh: Color(0xff2b2b2b),
      surfaceContainerHighest: Color(0xff333333),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffffff),
      surfaceTint: Color(0xfffafafa),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffd9d9df),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffd9d9df),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff717182),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffd9d9df),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff717182),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffccd4),
      onError: Color(0xff000000),
      errorContainer: Color(0xffff8b99),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff242424),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffececf0),
      outline: Color(0xffd9d9df),
      outlineVariant: Color(0xffa5a5b0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfffafafa),
      inversePrimary: Color(0xff030213),
      primaryFixed: Color(0xffffffff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffd9d9df),
      onPrimaryFixedVariant: Color(0xff000000),
      secondaryFixed: Color(0xffd9d9df),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffa5a5b0),
      onSecondaryFixedVariant: Color(0xff000000),
      tertiaryFixed: Color(0xffd9d9df),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa5a5b0),
      onTertiaryFixedVariant: Color(0xff000000),
      surfaceDim: Color(0xff171717),
      surfaceBright: Color(0xff444444),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1f1f1f),
      surfaceContainer: Color(0xff2b2b2b),
      surfaceContainerHigh: Color(0xff333333),
      surfaceContainerHighest: Color(0xff444444),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffffff),
      surfaceTint: Color(0xffffffff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffffff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffffff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffd9d9df),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffd9d9df),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffffff),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffccd4),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff242424),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffffff),
      outlineVariant: Color(0xffececf0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffffffff),
      inversePrimary: Color(0xff000000),
      primaryFixed: Color(0xffffffff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffececf0),
      onPrimaryFixedVariant: Color(0xff000000),
      secondaryFixed: Color(0xffffffff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffececf0),
      onSecondaryFixedVariant: Color(0xff000000),
      tertiaryFixed: Color(0xffffffff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffececf0),
      onTertiaryFixedVariant: Color(0xff000000),
      surfaceDim: Color(0xff111111),
      surfaceBright: Color(0xff555555),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff242424),
      surfaceContainer: Color(0xff333333),
      surfaceContainerHigh: Color(0xff444444),
      surfaceContainerHighest: Color(0xff555555),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
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

  List<ExtendedColor> get extendedColors => [
        ExtendedColor(
          seed: AppColors.muted,
          value: AppColors.muted,
          light: const ColorFamily(
            color: AppColors.muted,
            onColor: AppColors.mutedForeground,
            colorContainer: AppColors.muted,
            onColorContainer: AppColors.foreground,
          ),
          lightHighContrast: const ColorFamily(
            color: Color(0xffc9c9d0),
            onColor: Color(0xff000000),
            colorContainer: Color(0xffa5a5b0),
            onColorContainer: Color(0xff000000),
          ),
          lightMediumContrast: const ColorFamily(
            color: Color(0xffd9d9df),
            onColor: Color(0xff111111),
            colorContainer: Color(0xffc9c9d0),
            onColorContainer: Color(0xff111111),
          ),
          dark: const ColorFamily(
            color: Color(0xff333333),
            onColor: Color(0xffa9a9a9),
            colorContainer: Color(0xff444444),
            onColorContainer: Color(0xfffafafa),
          ),
          darkHighContrast: const ColorFamily(
            color: Color(0xff555555),
            onColor: Color(0xffffffff),
            colorContainer: Color(0xff666666),
            onColorContainer: Color(0xffffffff),
          ),
          darkMediumContrast: const ColorFamily(
            color: Color(0xff444444),
            onColor: Color(0xffffffff),
            colorContainer: Color(0xff555555),
            onColorContainer: Color(0xffffffff),
          ),
        ),
      ];
}

class AppColors {
  const AppColors._();

  static const Color background = Color(0xffffffff);
  static const Color foreground = Color(0xff242424);
  static const Color card = Color(0xffffffff);
  static const Color cardForeground = Color(0xff242424);
  static const Color popover = Color(0xffffffff);
  static const Color popoverForeground = Color(0xff242424);
  static const Color primary = Color(0xff030213);
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

  static const Color chart1 = Color(0xffe15d27);
  static const Color chart2 = Color(0xff1d9ba4);
  static const Color chart3 = Color(0xff3f5f8a);
  static const Color chart4 = Color(0xffe9c521);
  static const Color chart5 = Color(0xffefaa17);

  static const Color sidebar = Color(0xfffafafa);
  static const Color sidebarForeground = Color(0xff242424);
  static const Color sidebarPrimary = Color(0xff030213);
  static const Color sidebarPrimaryForeground = Color(0xfffafafa);
  static const Color sidebarAccent = Color(0xfff7f7f7);
  static const Color sidebarAccentForeground = Color(0xff343434);
  static const Color sidebarBorder = Color(0xffe5e5e5);
  static const Color sidebarRing = Color(0xffa9a9a9);
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}