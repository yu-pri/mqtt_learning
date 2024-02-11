import 'package:flutter/material.dart';

sealed class AppColors {
  static const bg = Colors.black;
  static const inactive = Colors.grey;
  static const fg = Color(0xFF4AF626);
  static const pending = Color.fromARGB(255, 232, 246, 38);
  static const error = Color.fromARGB(255, 246, 62, 38);
}

final textTheme = const TextTheme().apply(
  bodyColor: AppColors.fg,
  displayColor: AppColors.fg,
);

final buttonTextTheme = const TextTheme().apply(
  bodyColor: AppColors.bg,
  displayColor: AppColors.bg,
);

final theme = ThemeData(
  colorScheme: const ColorScheme.dark(
    background: AppColors.bg,
    primary: AppColors.fg,
    onPrimary: AppColors.bg,
    secondary: AppColors.fg,
    onSecondary: AppColors.bg,
    onSurface: AppColors.fg,
  ),
  buttonTheme: ButtonThemeData(
    disabledColor: AppColors.inactive,
    shape: Border.all(color: Colors.lightBlueAccent),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.disabled)
              ? AppColors.inactive
              : AppColors.bg),
      textStyle: MaterialStatePropertyAll(buttonTextTheme.bodyMedium),
      shape: const MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(1)),
          side: BorderSide(
            color: AppColors.fg,
            width: 2,
          ),
        ),
      ),
    ),
  ),
  appBarTheme: AppBarTheme(
    titleTextStyle: textTheme.titleMedium,
    backgroundColor: AppColors.bg,
  ),
);
