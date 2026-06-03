import 'package:flutter/material.dart';

const woodBrown = Color(0xFF6B3A2A);
const woodLight = Color(0xFF8B5E3C);
const woodAccent = Color(0xFFD4956A);
const woodOrange = Color(0xFFFF6B35);
const creamBg = Color(0xFFFAF7F4);
const darkBg = Color(0xFF1C1410);
const darkSurface = Color(0xFF2A1F18);
const darkAppBar = Color(0xFF241A13);

final _cardShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));

ThemeData lightTheme() => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: creamBg,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: woodBrown,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFFFDDD0),
        onPrimaryContainer: woodBrown,
        secondary: woodAccent,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFFFEEE0),
        onSecondaryContainer: woodBrown,
        surface: Colors.white,
        onSurface: Color(0xFF1C1410),
        error: Color(0xFFBA1A1A),
        onError: Colors.white,
        outline: Color(0xFFD4B8A8),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: woodBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: woodBrown,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: woodBrown,
          side: const BorderSide(color: woodBrown),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: woodBrown.withOpacity(0.15),
        shape: _cardShape,
        clipBehavior: Clip.antiAlias,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: woodBrown.withOpacity(0.08),
        labelStyle: const TextStyle(color: woodBrown, fontSize: 12),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: woodBrown.withOpacity(0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: woodBrown);
          }
          return const IconThemeData(color: Color(0xFF9E7B6A));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
                color: woodBrown, fontWeight: FontWeight.w600, fontSize: 12);
          }
          return const TextStyle(color: Color(0xFF9E7B6A), fontSize: 12);
        }),
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: woodBrown, width: 2),
        ),
        labelStyle: const TextStyle(color: woodBrown),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? woodBrown : null),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? woodBrown.withOpacity(0.4)
                : null),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? woodBrown : null),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: woodBrown),
      dividerTheme: const DividerThemeData(color: Color(0xFFEDE0D8)),
    );

ThemeData darkTheme() => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: darkBg,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: woodAccent,
        onPrimary: darkBg,
        primaryContainer: woodBrown,
        onPrimaryContainer: Colors.white,
        secondary: woodLight,
        onSecondary: Colors.white,
        secondaryContainer: const Color(0xFF3A2318),
        onSecondaryContainer: woodAccent,
        surface: darkSurface,
        onSurface: const Color(0xFFF0E6DE),
        error: const Color(0xFFFFB4AB),
        onError: const Color(0xFF690005),
        outline: woodBrown.withOpacity(0.5),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkAppBar,
        foregroundColor: Color(0xFFF0E6DE),
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: woodAccent,
          foregroundColor: darkBg,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: woodAccent,
          side: const BorderSide(color: woodAccent),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: _cardShape,
        clipBehavior: Clip.antiAlias,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: woodBrown.withOpacity(0.3),
        labelStyle: const TextStyle(color: woodAccent, fontSize: 12),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkAppBar,
        indicatorColor: woodBrown.withOpacity(0.4),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: woodAccent);
          }
          return IconThemeData(
              color: const Color(0xFFF0E6DE).withOpacity(0.5));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
                color: woodAccent, fontWeight: FontWeight.w600, fontSize: 12);
          }
          return TextStyle(
              color: const Color(0xFFF0E6DE).withOpacity(0.5), fontSize: 12);
        }),
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: darkSurface),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: woodAccent, width: 2),
        ),
        labelStyle: const TextStyle(color: woodAccent),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? woodAccent : null),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? woodAccent.withOpacity(0.4)
                : null),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? woodAccent : null),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: woodAccent),
      dividerTheme: DividerThemeData(color: woodBrown.withOpacity(0.3)),
    );
