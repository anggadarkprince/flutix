import 'package:flutix/l10n/messages_all.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Extract dart to arb:
//  flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/locale/my_localization.dart
// Convert arb to dart:
//  flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n/intl_messages.arb lib/l10n/intl_en.arb lib/l10n/intl_id.arb lib/locale/my_localization.dart
class MyLocalization {
  static Future<MyLocalization> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return MyLocalization();
    });
  }

  static MyLocalization of (BuildContext context) {
    return Localizations.of<MyLocalization>(context, MyLocalization);
  }

  String get helloWorld {
    return Intl.message(
      'Hello World',
      name: 'helloWorld',
      desc: 'Kata Hello World',
    );
  }
  
  String get menuMovies => Intl.message('Movies',  name: 'menuMovies');
  String get menuLikes => Intl.message('Likes',  name: 'menuLikes');
  String get menuTickets => Intl.message('Tickets',  name: 'menuTickets');
  String get menuAccount => Intl.message('Account',  name: 'menuAccount');

}