// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `My Cards`
  String get cards {
    return Intl.message('My Cards', name: 'cards', desc: '', args: []);
  }

  /// `No cards yet. Add some!`
  String get no_cards_yet {
    return Intl.message(
      'No cards yet. Add some!',
      name: 'no_cards_yet',
      desc: '',
      args: [],
    );
  }

  /// `Edit Card`
  String get edit_card {
    return Intl.message('Edit Card', name: 'edit_card', desc: '', args: []);
  }

  /// `Add New Card`
  String get add_card {
    return Intl.message('Add New Card', name: 'add_card', desc: '', args: []);
  }

  /// `Add Custom Card`
  String get add_custom_card {
    return Intl.message(
      'Add Custom Card',
      name: 'add_custom_card',
      desc: '',
      args: [],
    );
  }

  /// `Enter Manually`
  String get enter_manually {
    return Intl.message(
      'Enter Manually',
      name: 'enter_manually',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Continue`
  String get continue_to_scan {
    return Intl.message(
      'Continue',
      name: 'continue_to_scan',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `Barcode`
  String get barcode {
    return Intl.message('Barcode', name: 'barcode', desc: '', args: []);
  }

  /// `Note (optional)`
  String get note {
    return Intl.message('Note (optional)', name: 'note', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Scan`
  String get scan {
    return Intl.message('Scan', name: 'scan', desc: '', args: []);
  }

  /// `Please enter a name!`
  String get please_enter_name {
    return Intl.message(
      'Please enter a name!',
      name: 'please_enter_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a barcode!`
  String get please_enter_barcode {
    return Intl.message(
      'Please enter a barcode!',
      name: 'please_enter_barcode',
      desc: '',
      args: [],
    );
  }

  /// `Position the barcode within the frame to scan`
  String get position_barcode {
    return Intl.message(
      'Position the barcode within the frame to scan',
      name: 'position_barcode',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'et'),
      Locale.fromSubtags(languageCode: 'lt'),
      Locale.fromSubtags(languageCode: 'lv'),
      Locale.fromSubtags(languageCode: 'pl'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
