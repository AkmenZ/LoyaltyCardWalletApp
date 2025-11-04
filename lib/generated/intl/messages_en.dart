// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "add_card": MessageLookupByLibrary.simpleMessage("Add New Card"),
    "add_custom_card": MessageLookupByLibrary.simpleMessage("Add Custom Card"),
    "barcode": MessageLookupByLibrary.simpleMessage("Barcode"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cards": MessageLookupByLibrary.simpleMessage("My Cards"),
    "confirm_delete_card": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this card?",
    ),
    "continue_to_scan": MessageLookupByLibrary.simpleMessage("Continue"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "edit_card": MessageLookupByLibrary.simpleMessage("Edit Card"),
    "enter_manually": MessageLookupByLibrary.simpleMessage("Enter Manually"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "no_cards_yet": MessageLookupByLibrary.simpleMessage(
      "No cards yet. Add some!",
    ),
    "note": MessageLookupByLibrary.simpleMessage("Note (optional)"),
    "please_enter_barcode": MessageLookupByLibrary.simpleMessage(
      "Please enter a barcode!",
    ),
    "please_enter_name": MessageLookupByLibrary.simpleMessage(
      "Please enter a name!",
    ),
    "position_barcode": MessageLookupByLibrary.simpleMessage(
      "Position the barcode within the frame to scan",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "scan": MessageLookupByLibrary.simpleMessage("Scan"),
    "share": MessageLookupByLibrary.simpleMessage("Share"),
  };
}
