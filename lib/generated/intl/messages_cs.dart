// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a cs locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'cs';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "add_card": MessageLookupByLibrary.simpleMessage("Přidat Novou Kartu"),
    "add_custom_card": MessageLookupByLibrary.simpleMessage(
      "Vytvořit Vlastní Kartu",
    ),
    "barcode": MessageLookupByLibrary.simpleMessage("Čárový Kód"),
    "cards": MessageLookupByLibrary.simpleMessage("Moje Karty"),
    "continue_to_scan": MessageLookupByLibrary.simpleMessage("Pokračovat"),
    "delete": MessageLookupByLibrary.simpleMessage("Smazat"),
    "edit_card": MessageLookupByLibrary.simpleMessage("Upravit Kartu"),
    "enter_manually": MessageLookupByLibrary.simpleMessage("Zadat Ručně"),
    "name": MessageLookupByLibrary.simpleMessage("Název"),
    "no_cards_yet": MessageLookupByLibrary.simpleMessage(
      "Žádné karty zatím nebyly přidány.",
    ),
    "note": MessageLookupByLibrary.simpleMessage("Poznámka (volitelné)"),
    "please_enter_barcode": MessageLookupByLibrary.simpleMessage(
      "Prosím, zadejte čárový kód!",
    ),
    "please_enter_name": MessageLookupByLibrary.simpleMessage(
      "Prosím, zadejte název!",
    ),
    "position_barcode": MessageLookupByLibrary.simpleMessage(
      "Pro skenování namiřte čárový kód do rámečku",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Uložit"),
    "scan": MessageLookupByLibrary.simpleMessage("Skenovat"),
    "share": MessageLookupByLibrary.simpleMessage("Sdílet"),
  };
}
