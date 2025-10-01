import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loyalty_cards_app/generated/l10n.dart';
import 'package:loyalty_cards_app/services/shared_preferences_service.dart';
import 'package:loyalty_cards_app/theme.dart';
import 'package:loyalty_cards_app/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  // ensure bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // initialize shared preferences
  await SharedPrefs.init();

  // run the app
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return PlatformProvider(
      builder: (context) => PlatformTheme(
        themeMode: themeMode,
        materialLightTheme: materialLightTheme,
        materialDarkTheme: materialDarkTheme,
        cupertinoLightTheme: cupertinoLightTheme,
        cupertinoDarkTheme: cupertinoDarkTheme,
        matchCupertinoSystemChromeBrightness: true,
        builder: (context) => PlatformApp(
          title: 'Loyalty Cards',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            S.delegate, // intl_utils generated
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const HomePage(),
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return PlatformProvider(
  //     builder: (context) => PlatformTheme(
  //       themeMode: themeMode,
  //       // apply system-specific themes
  //       materialLightTheme: materialLightTheme,
  //       materialDarkTheme: materialDarkTheme,
  //       cupertinoLightTheme: cupertinoLightTheme,
  //       cupertinoDarkTheme: cupertinoDarkTheme,
  //       // keeps iOS status bar brightness in sync with light/dark
  //       matchCupertinoSystemChromeBrightness: true,
  //       builder: (context) => PlatformApp(
  //         title: 'Loyalty Cards',
  //         debugShowCheckedModeBanner: false,
  //         localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
  //           DefaultMaterialLocalizations.delegate,
  //           DefaultWidgetsLocalizations.delegate,
  //           DefaultCupertinoLocalizations.delegate,
  //         ],
  //         home: const HomePage(),
  //       ),
  //     ),
  //   );
  // }
}
