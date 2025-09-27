import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const ThemeMode themeMode = ThemeMode.system;

// App brand color
const Color seed = Colors.indigoAccent;

final ThemeData materialLightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: seed,
    foregroundColor: Colors.white,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    scrolledUnderElevation: 0,
  ),
);

final ThemeData materialDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: seed,
    foregroundColor: Colors.white,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    scrolledUnderElevation: 0,
  ),
);

// Global Cupertino themes
final CupertinoThemeData cupertinoLightTheme = MaterialBasedCupertinoThemeData(
  materialTheme: materialLightTheme.copyWith(
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: Brightness.light,
      barBackgroundColor: CupertinoColors.systemGrey6,
    ),
  ),
);

final CupertinoThemeData cupertinoDarkTheme = MaterialBasedCupertinoThemeData(
  materialTheme: materialDarkTheme.copyWith(
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: Brightness.dark,
      barBackgroundColor: CupertinoColors.systemGrey5.darkColor,
    ),
  ),
);