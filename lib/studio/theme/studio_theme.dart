import 'package:flutter/material.dart';

/// CMS Studio theme configuration following shadcn_ui design principles
/// Provides consistent theming across the studio interface
class StudioTheme {
  static const _lightColorScheme = ColorScheme.light(
    primary: Color(0xFF0F172A),
    onPrimary: Color(0xFFFAFAFA),
    primaryContainer: Color(0xFF1E293B),
    onPrimaryContainer: Color(0xFFF1F5F9),
    secondary: Color(0xFF64748B),
    onSecondary: Color(0xFFFAFAFA),
    secondaryContainer: Color(0xFFF1F5F9),
    onSecondaryContainer: Color(0xFF0F172A),
    tertiary: Color(0xFF3B82F6),
    onTertiary: Color(0xFFFAFAFA),
    tertiaryContainer: Color(0xFFDBEAFE),
    onTertiaryContainer: Color(0xFF1E3A8A),
    error: Color(0xFFEF4444),
    onError: Color(0xFFFAFAFA),
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF7F1D1D),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF0F172A),
    surfaceContainerHighest: Color(0xFFF8FAFC),
    onSurfaceVariant: Color(0xFF475569),
    outline: Color(0xFFE2E8F0),
    outlineVariant: Color(0xFFF1F5F9),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF0F172A),
    onInverseSurface: Color(0xFFF8FAFC),
    inversePrimary: Color(0xFF94A3B8),
    surfaceTint: Color(0xFF0F172A),
  );

  static const _darkColorScheme = ColorScheme.dark(
    primary: Color(0xFFF8FAFC),
    onPrimary: Color(0xFF0F172A),
    primaryContainer: Color(0xFF334155),
    onPrimaryContainer: Color(0xFFF1F5F9),
    secondary: Color(0xFF94A3B8),
    onSecondary: Color(0xFF0F172A),
    secondaryContainer: Color(0xFF1E293B),
    onSecondaryContainer: Color(0xFFF1F5F9),
    tertiary: Color(0xFF60A5FA),
    onTertiary: Color(0xFF0F172A),
    tertiaryContainer: Color(0xFF1E3A8A),
    onTertiaryContainer: Color(0xFFDBEAFE),
    error: Color(0xFFF87171),
    onError: Color(0xFF0F172A),
    errorContainer: Color(0xFF7F1D1D),
    onErrorContainer: Color(0xFFFEE2E2),
    surface: Color(0xFF0F172A),
    onSurface: Color(0xFFF8FAFC),
    surfaceContainerHighest: Color(0xFF1E293B),
    onSurfaceVariant: Color(0xFF94A3B8),
    outline: Color(0xFF475569),
    outlineVariant: Color(0xFF334155),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFF8FAFC),
    onInverseSurface: Color(0xFF0F172A),
    inversePrimary: Color(0xFF475569),
    surfaceTint: Color(0xFFF8FAFC),
  );

  /// Light theme for the studio
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      fontFamily: 'Inter',
      textTheme: _textTheme(_lightColorScheme),
      appBarTheme: _appBarTheme(_lightColorScheme),
      cardTheme: _cardTheme(_lightColorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(_lightColorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(_lightColorScheme),
      textButtonTheme: _textButtonTheme(_lightColorScheme),
      inputDecorationTheme: _inputDecorationTheme(_lightColorScheme),
      dividerTheme: _dividerTheme(_lightColorScheme),
      chipTheme: _chipTheme(_lightColorScheme),
      listTileTheme: _listTileTheme(_lightColorScheme),
      navigationBarTheme: _navigationBarTheme(_lightColorScheme),
      navigationRailTheme: _navigationRailTheme(_lightColorScheme),
      tabBarTheme: _tabBarTheme(_lightColorScheme),
      dialogTheme: _dialogTheme(_lightColorScheme),
      popupMenuTheme: _popupMenuTheme(_lightColorScheme),
      tooltipTheme: _tooltipTheme(_lightColorScheme),
      snackBarTheme: _snackBarTheme(_lightColorScheme),
    );
  }

  /// Dark theme for the studio
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      fontFamily: 'Inter',
      textTheme: _textTheme(_darkColorScheme),
      appBarTheme: _appBarTheme(_darkColorScheme),
      cardTheme: _cardTheme(_darkColorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(_darkColorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(_darkColorScheme),
      textButtonTheme: _textButtonTheme(_darkColorScheme),
      inputDecorationTheme: _inputDecorationTheme(_darkColorScheme),
      dividerTheme: _dividerTheme(_darkColorScheme),
      chipTheme: _chipTheme(_darkColorScheme),
      listTileTheme: _listTileTheme(_darkColorScheme),
      navigationBarTheme: _navigationBarTheme(_darkColorScheme),
      navigationRailTheme: _navigationRailTheme(_darkColorScheme),
      tabBarTheme: _tabBarTheme(_darkColorScheme),
      dialogTheme: _dialogTheme(_darkColorScheme),
      popupMenuTheme: _popupMenuTheme(_darkColorScheme),
      tooltipTheme: _tooltipTheme(_darkColorScheme),
      snackBarTheme: _snackBarTheme(_darkColorScheme),
    );
  }

  // Text Theme
  static TextTheme _textTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: colorScheme.onSurface,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: colorScheme.onSurface,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: colorScheme.onSurface,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: colorScheme.onSurface,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: colorScheme.onSurface,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: colorScheme.onSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: colorScheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: colorScheme.onSurface,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  // Component Themes
  static AppBarTheme _appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    );
  }

  static CardThemeData _cardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: colorScheme.outline,
          width: 1,
        ),
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      filled: true,
      fillColor: colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  static DividerThemeData _dividerTheme(ColorScheme colorScheme) {
    return DividerThemeData(
      color: colorScheme.outline,
      thickness: 1,
      space: 1,
    );
  }

  static ChipThemeData _chipTheme(ColorScheme colorScheme) {
    return ChipThemeData(
      backgroundColor: colorScheme.surfaceContainerHighest,
      selectedColor: colorScheme.primaryContainer,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  static ListTileThemeData _listTileTheme(ColorScheme colorScheme) {
    return ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      selectedTileColor: colorScheme.primaryContainer.withValues(alpha:0.1),
      selectedColor: colorScheme.primary,
    );
  }

  static NavigationBarThemeData _navigationBarTheme(ColorScheme colorScheme) {
    return NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      height: 80,
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  static NavigationRailThemeData _navigationRailTheme(ColorScheme colorScheme) {
    return NavigationRailThemeData(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      labelType: NavigationRailLabelType.all,
      selectedIconTheme: IconThemeData(color: colorScheme.primary),
      unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      selectedLabelTextStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colorScheme.primary,
      ),
      unselectedLabelTextStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  static TabBarThemeData _tabBarTheme(ColorScheme colorScheme) {
    return TabBarThemeData(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static DialogThemeData _dialogTheme(ColorScheme colorScheme) {
    return DialogThemeData(
      backgroundColor: colorScheme.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      contentTextStyle: TextStyle(
        fontSize: 14,
        color: colorScheme.onSurface,
      ),
    );
  }

  static PopupMenuThemeData _popupMenuTheme(ColorScheme colorScheme) {
    return PopupMenuThemeData(
      color: colorScheme.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colorScheme.outline),
      ),
      textStyle: TextStyle(
        fontSize: 14,
        color: colorScheme.onSurface,
      ),
    );
  }

  static TooltipThemeData _tooltipTheme(ColorScheme colorScheme) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: colorScheme.inverseSurface,
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: TextStyle(
        fontSize: 12,
        color: colorScheme.onInverseSurface,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  static SnackBarThemeData _snackBarTheme(ColorScheme colorScheme) {
    return SnackBarThemeData(
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: TextStyle(
        fontSize: 14,
        color: colorScheme.onInverseSurface,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      behavior: SnackBarBehavior.floating,
    );
  }
}

/// Studio-specific color extensions
extension StudioColors on ColorScheme {
  /// Accent colors for various UI states
  Color get success => const Color(0xFF22C55E);
  Color get successContainer => const Color(0xFFDCFCE7);
  Color get onSuccess => const Color(0xFFFFFFFF);
  Color get onSuccessContainer => const Color(0xFF15803D);

  Color get warning => const Color(0xFFF59E0B);
  Color get warningContainer => const Color(0xFFFEF3C7);
  Color get onWarning => const Color(0xFFFFFFFF);
  Color get onWarningContainer => const Color(0xFF92400E);

  Color get info => const Color(0xFF3B82F6);
  Color get infoContainer => const Color(0xFFDBEAFE);
  Color get onInfo => const Color(0xFFFFFFFF);
  Color get onInfoContainer => const Color(0xFF1E3A8A);

  /// Semantic colors for content status
  Color get draft => const Color(0xFF6B7280);
  Color get published => const Color(0xFF059669);
  Color get archived => const Color(0xFFF59E0B);
  Color get deleted => const Color(0xFFDC2626);

  /// Border and separator colors
  Color get border => outline;
  Color get separator => outlineVariant;
  Color get hover => onSurface.withValues(alpha:0.04);
  Color get pressed => onSurface.withValues(alpha:0.08);
  Color get focus => primary.withValues(alpha:0.12);
  Color get disabled => onSurface.withValues(alpha:0.38);
}