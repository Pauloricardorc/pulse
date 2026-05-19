import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Glass / Aurora — Pulse design system.
///
/// Direction: deep ink background with soft mesh-gradient aurora, glassy
/// surfaces with translucent borders, neon-cyan accent with magenta highlights.
/// Display font: Bricolage Grotesque (variable, distinctive cuts).
/// Body font: Manrope (refined, soft humanist).
/// Mono font: JetBrains Mono.
class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color backgroundDeep;
  final Color glass;
  final Color glassStrong;
  final Color glassEdge;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  // Aurora hues (mesh-gradient blobs)
  final Color auroraA;
  final Color auroraB;
  final Color auroraC;

  const AppColors({
    required this.background,
    required this.backgroundDeep,
    required this.glass,
    required this.glassStrong,
    required this.glassEdge,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.auroraA,
    required this.auroraB,
    required this.auroraC,
  });

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  static const dark = AppColors(
    background:     Color(0xFF07080C),
    backgroundDeep: Color(0xFF030409),
    glass:          Color(0x14FFFFFF), // ~8% white
    glassStrong:    Color(0x22FFFFFF), // ~13% white
    glassEdge:      Color(0x33FFFFFF), // ~20% white — stronger borders for legibility
    textPrimary:    Color(0xFFF4F6F2),
    textSecondary:  Color(0xFFB0B7AE),
    textMuted:      Color(0xFF676E68),
    auroraA:        Color(0xFFB6F26F), // lime
    auroraB:        Color(0xFFA78BFA), // violet
    auroraC:        Color(0xFF14B8A6), // teal
  );

  static const light = AppColors(
    background:     Color(0xFFF4F6F0),
    backgroundDeep: Color(0xFFE9EDE2),
    glass:          Color(0x14FFFFFF),
    glassStrong:    Color(0xFFFFFFFF),
    glassEdge:      Color(0x1A000000),
    textPrimary:    Color(0xFF0B0E0A),
    textSecondary:  Color(0xFF4B524A),
    textMuted:      Color(0xFF8A918A),
    auroraA:        Color(0xFFB6F26F),
    auroraB:        Color(0xFFA78BFA),
    auroraC:        Color(0xFF14B8A6),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? backgroundDeep,
    Color? glass,
    Color? glassStrong,
    Color? glassEdge,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? auroraA,
    Color? auroraB,
    Color? auroraC,
  }) =>
      AppColors(
        background:     background     ?? this.background,
        backgroundDeep: backgroundDeep ?? this.backgroundDeep,
        glass:          glass          ?? this.glass,
        glassStrong:    glassStrong    ?? this.glassStrong,
        glassEdge:      glassEdge      ?? this.glassEdge,
        textPrimary:    textPrimary    ?? this.textPrimary,
        textSecondary:  textSecondary  ?? this.textSecondary,
        textMuted:      textMuted      ?? this.textMuted,
        auroraA:        auroraA        ?? this.auroraA,
        auroraB:        auroraB        ?? this.auroraB,
        auroraC:        auroraC        ?? this.auroraC,
      );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      background:     Color.lerp(background,     other.background,     t)!,
      backgroundDeep: Color.lerp(backgroundDeep, other.backgroundDeep, t)!,
      glass:          Color.lerp(glass,          other.glass,          t)!,
      glassStrong:    Color.lerp(glassStrong,    other.glassStrong,    t)!,
      glassEdge:      Color.lerp(glassEdge,      other.glassEdge,      t)!,
      textPrimary:    Color.lerp(textPrimary,    other.textPrimary,    t)!,
      textSecondary:  Color.lerp(textSecondary,  other.textSecondary,  t)!,
      textMuted:      Color.lerp(textMuted,      other.textMuted,      t)!,
      auroraA:        Color.lerp(auroraA,        other.auroraA,        t)!,
      auroraB:        Color.lerp(auroraB,        other.auroraB,        t)!,
      auroraC:        Color.lerp(auroraC,        other.auroraC,        t)!,
    );
  }
}

class AppTheme {
  // Lime/Violet — primary lime, highlight violet.
  static const accent       = Color(0xFFB6F26F); // lime
  static const accentDeep   = Color(0xFF7BC93A);
  static const accentSpark  = Color(0xFFA78BFA); // violet highlight

  // "on-accent" text/icon color used on filled buttons over lime.
  static const onAccent     = Color(0xFF0A1503);

  static const statusUp      = Color(0xFFB6F26F); // lime (matches accent)
  static const statusDown    = Color(0xFFFF6B7A); // coral
  static const statusPending = Color(0xFFFFC857); // amber
  static const statusDegraded = Color(0xFFFB923C); // orange

  static Color latencyColor(int? ms) {
    if (ms == null) return const Color(0x55FFFFFF);
    if (ms < 300) return statusUp;
    if (ms < 1000) return statusPending;
    return statusDown;
  }

  static Color tagColor(String name) {
    final hash = name.codeUnits.fold<int>(0, (a, b) => a * 31 + b);
    const palette = <Color>[
      Color(0xFFB6F26F), // lime
      Color(0xFFA78BFA), // violet
      Color(0xFF14B8A6), // teal
      Color(0xFFFFC857), // amber
      Color(0xFFFB923C), // orange
      Color(0xFFF472B6), // rose
      Color(0xFF38BDF8), // sky
      Color(0xFF4ADE80), // green
    ];
    return palette[hash.abs() % palette.length];
  }

  static Color environmentColor(String name) {
    final n = name.toLowerCase();
    if (n.contains('prod')) return statusDown;
    if (n.contains('staging') || n.contains('homolog')) return statusPending;
    if (n.contains('dev') || n.contains('local')) return accentSpark;
    return const Color(0xFFB0B7AE);
  }

  static ThemeData buildTheme(AppColors colors, Brightness brightness) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    final display = GoogleFonts.bricolageGrotesqueTextTheme(base.textTheme);
    final body = GoogleFonts.manropeTextTheme(base.textTheme);

    final textTheme = base.textTheme.copyWith(
      displayLarge:   display.displayLarge?.copyWith(
          color: colors.textPrimary, fontWeight: FontWeight.w800, letterSpacing: -1.2),
      displayMedium:  display.displayMedium?.copyWith(
          color: colors.textPrimary, fontWeight: FontWeight.w800, letterSpacing: -1),
      displaySmall:   display.displaySmall?.copyWith(
          color: colors.textPrimary, fontWeight: FontWeight.w700, letterSpacing: -0.6),
      headlineLarge:  display.headlineLarge?.copyWith(
          color: colors.textPrimary, fontWeight: FontWeight.w700, letterSpacing: -0.6),
      headlineMedium: display.headlineMedium?.copyWith(
          color: colors.textPrimary, fontWeight: FontWeight.w700, letterSpacing: -0.4),
      headlineSmall:  display.headlineSmall?.copyWith(
          color: colors.textPrimary, fontWeight: FontWeight.w700, letterSpacing: -0.3),
      titleLarge:     body.titleLarge?.copyWith(
          color: colors.textPrimary, fontWeight: FontWeight.w600),
      titleMedium:    body.titleMedium?.copyWith(
          color: colors.textPrimary, fontWeight: FontWeight.w600),
      titleSmall:     body.titleSmall?.copyWith(
          color: colors.textPrimary, fontWeight: FontWeight.w600),
      bodyLarge:      body.bodyLarge?.copyWith(color: colors.textPrimary),
      bodyMedium:     body.bodyMedium?.copyWith(color: colors.textPrimary),
      bodySmall:      body.bodySmall?.copyWith(color: colors.textSecondary),
      labelLarge:     body.labelLarge?.copyWith(
          color: colors.textPrimary, fontWeight: FontWeight.w600),
      labelMedium:    body.labelMedium?.copyWith(color: colors.textSecondary),
      labelSmall:     body.labelSmall?.copyWith(color: colors.textMuted),
    );

    return base.copyWith(
      extensions: [colors],
      scaffoldBackgroundColor: colors.background,
      textTheme: textTheme,
      colorScheme: (brightness == Brightness.dark
              ? ColorScheme.dark
              : ColorScheme.light)(
        surface: colors.background,
        primary: accent,
        onPrimary: onAccent,
        secondary: accentSpark,
        error: statusDown,
        onSurface: colors.textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.glass,
        labelStyle: body.bodyMedium?.copyWith(color: colors.textSecondary),
        hintStyle: body.bodyMedium?.copyWith(color: colors.textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.glassEdge),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.glassEdge),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: statusDown),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: onAccent,
          textStyle: body.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          side: BorderSide(color: colors.glassEdge),
          backgroundColor: colors.glass,
          textStyle: body.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.textSecondary,
          textStyle: body.labelLarge,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.backgroundDeep,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.glassEdge),
        ),
        titleTextStyle: display.headlineSmall?.copyWith(
            color: colors.textPrimary, fontWeight: FontWeight.w700),
        contentTextStyle:
            body.bodyMedium?.copyWith(color: colors.textSecondary),
      ),
      dividerColor: colors.glassEdge,
      dividerTheme: DividerThemeData(
          color: colors.glassEdge, thickness: 1, space: 0),
      iconTheme: IconThemeData(color: colors.textSecondary, size: 18),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.backgroundDeep,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.glassEdge),
        ),
        textStyle:
            body.bodySmall?.copyWith(color: colors.textPrimary, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
    );
  }

  static ThemeData get dark => buildTheme(AppColors.dark, Brightness.dark);
  static ThemeData get light => buildTheme(AppColors.light, Brightness.light);
}

/// Display font preset shortcut.
TextStyle displayStyle({
  double size = 28,
  FontWeight weight = FontWeight.w800,
  Color? color,
  double letterSpacing = -0.6,
}) =>
    GoogleFonts.bricolageGrotesque(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
    );

TextStyle bodyStyle({
  double size = 13,
  FontWeight weight = FontWeight.w400,
  Color? color,
  double? letterSpacing,
  double? height,
}) =>
    GoogleFonts.manrope(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );

TextStyle monoStyle({
  double size = 12,
  FontWeight weight = FontWeight.w500,
  Color? color,
  double? letterSpacing,
}) =>
    GoogleFonts.jetBrainsMono(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
    );
