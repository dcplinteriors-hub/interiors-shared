import 'package:flutter/material.dart' show Color, MaterialColor;

/// Raw brand colours for DCPL — "Molten".
///
/// The 2026 identity (new logo): a disciplined **graphite-on-paper** foundation
/// (the cold steel — the [steel] swatch, carried over for data legibility) lit
/// by the **Molten brand gradient** (saffron → ember → crimson → magenta — the
/// colours worked metal glows through). The gradient lives in `BrandGradient`;
/// its solid stand-in is the [crimson] swatch, used where a flat fill is needed
/// (text, icons, small chips). The functional colours are fixed semantic signals
/// (success/danger/warning/neutral/info) that must read the same in both apps
/// and are deliberately NOT brand colours.
///
/// Ramps are [MaterialColor] swatches — read a shade with `.shade500` (or
/// `swatch[950]!` for the off-scale steel shade). The swatch's own value is its
/// 500: `AppPalette.crimson` == the brand solid. Consumed by [AppTheme] (to
/// build the [ColorScheme]), by `BrandGradient`, and by `StatusColors`. Screens
/// should NOT reach in here directly — they read
/// `Theme.of(context).colorScheme` / `context.statusColors`, so the brand stays
/// swappable from one place.
abstract final class AppPalette {
  // --- Molten gradient stops (the brand signature; see BrandGradient) --------
  static const saffron = Color(0xFFF7941D); // hot orange — the logo "D"
  static const ember = Color(0xFFF15A29); //   orange-red bridge
  static const magenta = Color(0xFFC81D77); // magenta — the logo "P/L"

  // --- Crimson swatch (solid brand accent; the gradient's centre of gravity) -
  // The swatch value (500) is the brand solid — the logo "C".
  static const crimson = MaterialColor(0xFFED1C45, {
    50: Color(0xFFFFE9EE),
    100: Color(0xFFFBC4D0),
    200: Color(0xFFF8A9BC),
    300: Color(0xFFF58399),
    400: Color(0xFFF24E6E),
    500: Color(0xFFED1C45),
    600: Color(0xFFD4163C),
    700: Color(0xFFC2143A), // carries white text at AA
    800: Color(0xFFA01030),
    900: Color(0xFF8E0E2B),
  });

  // --- Steel swatch (graphite foundation: charcoal → blue-grey, "raw steel") -
  // 800 (the swatch value) is graphite/primary; 200 is the hairline; the
  // off-scale 950 is the darkest ink, read via `steel[950]!`.
  static const steel = MaterialColor(0xFF2E343B, {
    50: Color(0xFFF5F7F8),
    100: Color(0xFFE7ECEE),
    200: Color(0xFFCFD8DC), // hairlines / outlineVariant
    300: Color(0xFFB0BEC5),
    400: Color(0xFF8A9AA3),
    500: Color(0xFF607079),
    600: Color(0xFF455A64), // interactive steel
    700: Color(0xFF37474F),
    800: Color(0xFF2E343B), // primary (graphite)
    900: Color(0xFF21262B),
    950: Color(0xFF14181B),
  });

  // --- Functional / semantic signals ----------------------------------------
  // Surfaces tuned for chip presence (~1.3:1 against a white card) while
  // keeping ink at WCAG AA (>=4.5:1). Deliberately NOT brand colours, so a
  // "warning" never reads as "brand".

  // Success (accepted / completed).
  static const green = Color(0xFF2E7D52);
  static const greenSurface = Color(0xFFCDEAD8);
  static const greenInk = Color(0xFF1B5E3A);

  // Danger (declined / destructive).
  static const red = Color(0xFFC0392B);
  static const redSurface = Color(0xFFF6D4CF);
  static const redInk = Color(0xFF8E2A20);

  // Warning / needs-attention (e.g. unassigned).
  static const amber = Color(0xFFB45309);
  static const amberSurface = Color(0xFFF6DFC4);
  static const amberInk = Color(0xFF7A3D0E);

  // Neutral / dormant (cancelled).
  static const grey = Color(0xFF76808C);
  static const greySurface = Color(0xFFDDE2E8);
  static const greyInk = Color(0xFF4A535D);

  // Info / in-progress (requested / active). A semantic blue — deliberately NOT
  // a brand colour; its job is to be a distinct, calm "pending" signal.
  static const infoSurface = Color(0xFFC9EBF1);
  static const infoInk = Color(0xFF0E5663);

  // Paper white surfaces.
  static const white = Color(0xFFFFFFFF);
}
