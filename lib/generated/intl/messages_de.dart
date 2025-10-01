// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "add_card": MessageLookupByLibrary.simpleMessage("Neue Karte hinzufügen"),
    "add_custom_card": MessageLookupByLibrary.simpleMessage(
      "Eigene Karte erstellen",
    ),
    "barcode": MessageLookupByLibrary.simpleMessage("Barcode"),
    "cards": MessageLookupByLibrary.simpleMessage("Meine Karten"),
    "continue_to_scan": MessageLookupByLibrary.simpleMessage("Weiter"),
    "delete": MessageLookupByLibrary.simpleMessage("Löschen"),
    "edit_card": MessageLookupByLibrary.simpleMessage("Karte bearbeiten"),
    "enter_manually": MessageLookupByLibrary.simpleMessage("Manuell eingeben"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "no_cards_yet": MessageLookupByLibrary.simpleMessage(
      "Noch keine Karten hinzugefügt.",
    ),
    "note": MessageLookupByLibrary.simpleMessage("Notiz (optional)"),
    "please_enter_barcode": MessageLookupByLibrary.simpleMessage(
      "Bitte geben Sie einen Barcode ein!",
    ),
    "please_enter_name": MessageLookupByLibrary.simpleMessage(
      "Bitte geben Sie einen Namen ein!",
    ),
    "position_barcode": MessageLookupByLibrary.simpleMessage(
      "Um zu scannen, richten Sie den Barcode in den Rahmen",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Speichern"),
    "scan": MessageLookupByLibrary.simpleMessage("Scannen"),
    "share": MessageLookupByLibrary.simpleMessage("Teilen"),
  };
}
