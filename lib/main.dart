import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loyalty_cards_app/generated/l10n.dart';
import 'package:loyalty_cards_app/services/shared_preferences_service.dart';
import 'package:loyalty_cards_app/theme.dart';
import 'package:loyalty_cards_app/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:toastification/toastification.dart';

void main() async {
  // ensure bindings are initialized
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // preserve splash screen while app initializes
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // lock device orientation to portrait up
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // initialize shared preferences
  await SharedPrefs.init();

  // small 500 milliseconds delay to preserve splash screen to look smoother
  await Future.delayed(const Duration(milliseconds: 500));

  // remove splash screen
  FlutterNativeSplash.remove();

  // run the app
  runApp(const ProviderScope(child: ToastificationWrapper(child: MyApp())));
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
}
