import 'package:core_dashboard/theme/colors.dart';
import 'package:core_dashboard/theme/widgets/app_text_form_field_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: AppColorsCustom.bgLight,
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColorsCustom.bgSecondaryLight,
        surfaceTintColor: AppColorsCustom.bgSecondaryLight,
      ),
      primaryColor: AppColorsCustom.primary,
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
          .apply(
              bodyColor: AppColorsCustom.titleLight,
              displayColor: AppColorsCustom.titleLight)
          .copyWith(
            bodyLarge: const TextStyle(color: AppColorsCustom.textLight),
            bodyMedium: const TextStyle(color: AppColorsCustom.textLight),
            bodySmall: const TextStyle(color: AppColorsCustom.textLight),
          ),
      iconTheme: const IconThemeData(color: AppColorsCustom.iconLight),
      dividerColor: AppColorsCustom.highlightLight,
      dividerTheme: const DividerThemeData(
        thickness: 1,
        color: AppColorsCustom.highlightLight,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(100, 56),
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: AppColorsCustom.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12), // Utilize um valor fixo ou de uma constante
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorsCustom.titleLight,
          minimumSize: const Size(100, 56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: AppColorsCustom.highlightLight, width: 2),
        ),
      ),
      inputDecorationTheme: AppTextFormFieldTheme.lightInputDecorationTheme,
      expansionTileTheme:
          const ExpansionTileThemeData(shape: const RoundedRectangleBorder()),
      badgeTheme:
          BadgeThemeData(backgroundColor: AppColorsCustom.error, smallSize: 8),
    );
  }

  static ThemeData dark(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: AppColorsCustom.bgDark,
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColorsCustom.bgSecondaryDark,
        surfaceTintColor: AppColorsCustom.bgSecondaryDark,
      ),
      primaryColor: AppColorsCustom.primary,
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
          .apply(
              bodyColor: AppColorsCustom.titleDark,
              displayColor: AppColorsCustom.titleDark)
          .copyWith(
            bodyLarge: const TextStyle(color: AppColorsCustom.textDark),
            bodyMedium: const TextStyle(color: AppColorsCustom.textDark),
            bodySmall: const TextStyle(color: AppColorsCustom.textDark),
          ),
      iconTheme: const IconThemeData(color: AppColorsCustom.iconDark),
      dividerColor: AppColorsCustom.highlightDark,
      dividerTheme: const DividerThemeData(
        thickness: 1,
        color: AppColorsCustom.highlightDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(100, 56),
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: AppColorsCustom.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12), // Utilize um valor fixo ou de uma constante
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorsCustom.titleDark,
          minimumSize: const Size(100, 56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: AppColorsCustom.highlightDark, width: 2),
        ),
      ),
      inputDecorationTheme: AppTextFormFieldTheme.darkInputDecorationTheme,
      expansionTileTheme:
          const ExpansionTileThemeData(shape: const RoundedRectangleBorder()),
      badgeTheme:
          BadgeThemeData(backgroundColor: AppColorsCustom.error, smallSize: 8),
    );
  }
}
