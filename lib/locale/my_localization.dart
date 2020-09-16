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
      desc: 'Hello World',
    );
  }
  
  String get signUp => Intl.message('Sign Up',  name: 'signUp');
  String get signIn => Intl.message('Sign In',  name: 'signIn');
  String get signOut => Intl.message('Sign Out',  name: 'signOut');
  String get cancel => Intl.message('Cancel',  name: 'cancel');

  String get menuMovies => Intl.message('Movies',  name: 'menuMovies');
  String get menuLikes => Intl.message('Likes',  name: 'menuLikes');
  String get menuTickets => Intl.message('Tickets',  name: 'menuTickets');
  String get menuAccount => Intl.message('Account',  name: 'menuAccount');

  String get menuGeneral => Intl.message('General',  name: 'menuGeneral');
  String get menuEditAccount => Intl.message('Edit Account',  name: 'menuEditAccount');
  String get menuTransactionHistories => Intl.message('Transaction Histories',  name: 'menuTransactionHistories');
  String get menuEnterPromoCode => Intl.message('Enter Promo Code',  name: 'menuEnterPromoCode');
  String get menuMyVoucher => Intl.message('My Voucher',  name: 'menuMyVoucher');
  String get menuChangeLanguage => Intl.message('Change Language',  name: 'menuChangeLanguage');
  String get menuPrivacyPolicy => Intl.message('Privacy Policy',  name: 'menuPrivacyPolicy');
  String get menuTermsOfService => Intl.message('Terms Of Service',  name: 'menuTermsOfService');
  String get menuRateApp => Intl.message('Rate App',  name: 'menuRateApp');
  
  String get getStarted => Intl.message('Get Started',  name: 'getStarted');
  String get alreadyHaveAnAccount => Intl.message('Already have an account? ',  name: 'alreadyHaveAnAccount');
  String get newExperience => Intl.message('New Experience',  name: 'newExperience');
  String get watchNewMovie => Intl.message('Watch a new movie much\neasier than any before',  name: 'watchNewMovie');
  String get startFreshNow => Intl.message('Start fresh now? ',  name: 'startFreshNow');
  String get resetHere => Intl.message('Reset Here',  name: 'resetHere');
  String get forgotPassword => Intl.message('Forgot Password? ',  name: 'forgotPassword');
  String get welcomeBackExplorer => Intl.message('Welcome Back,\nExplorer!',  name: 'welcomeBackExplorer');
  String get rememberPassword => Intl.message('Remember Password? ',  name: 'rememberPassword');
  String get resetLinkMessage => Intl.message('The link to change your password has been sent to your email.',  name: 'resetLinkMessage');
  String get resetYourPassword => Intl.message('Reset Your Password',  name: 'resetYourPassword');
  String get weWillSendYouRecoveryEmail => Intl.message('We will send you recovery email',  name: 'weWillSendYouRecoveryEmail');
  String get exploreThousandsMovies => Intl.message('Explore thousands movies',  name: 'exploreThousandsMovies');
  String get confirmPasswordMismatch => Intl.message('Confirm password mismatch',  name: 'confirmPasswordMismatch');
  String get summary => Intl.message('Summary',  name: 'summary');
  String get confirmRegistration => Intl.message('Confirm Registration',  name: 'confirmRegistration');
  String get oneStepCloserRegistration => Intl.message('One step closer\nto explore thousands of movies',  name: 'oneStepCloserRegistration');
  String get moviePreferences => Intl.message('Movie Preferences',  name: 'moviePreferences');
  String get yourFavoriteGenre => Intl.message('Your Favorite Genre',  name: 'yourFavoriteGenre');
  String get languageYourPrefer => Intl.message('Language You Prefer',  name: 'languageYourPrefer');
  String get selectGenreMessage => Intl.message('Please select 4 genres',  name: 'selectGenreMessage');

  String get emailAddress => Intl.message('Email Address',  name: 'emailAddress');
  String get registeredEmail => Intl.message('Registered Email',  name: 'registeredEmail');
  String get password => Intl.message('Password',  name: 'password');
  String get confirmPassword => Intl.message('Confirm Password',  name: 'confirmPassword');
  String get fullName => Intl.message('Full Name',  name: 'fullName');

  String get iAgree => Intl.message('I Agree',  name: 'iAgree');
  String get closePage => Intl.message('Close Page',  name: 'closePage');
  String get movieDatabase => Intl.message('Movie Database',  name: 'movieDatabase');
  String get furtherInformation => Intl.message('Further Information',  name: 'furtherInformation');

  String get happyWatching => Intl.message('Happy Watching!',  name: 'happyWatching');
  String get readyToExplore => Intl.message('Ready To Explore',  name: 'readyToExplore');
  String get successTopUpMessage => Intl.message('You have successfully\ntop up the wallet',  name: 'successTopUpMessage');
  String get successBoughtTicketMessage => Intl.message('You have successfully\nbought the ticket',  name: 'successBoughtTicketMessage');
  String get myWallet => Intl.message('My Wallet',  name: 'myWallet');
  String get myTickets => Intl.message('My Tickets',  name: 'myTickets');
  String get discoverNewMovie => Intl.message('Discover new movie? ',  name: 'discoverNewMovie');
  String get backToHome => Intl.message('Back to Home',  name: 'backToHome');
  String get seatNumbers => Intl.message('Seat Numbers',  name: 'seatNumbers');
  String get checkout => Intl.message('Checkout',  name: 'checkout');
  String get orderId => Intl.message('Order ID',  name: 'orderId');
  String get cinema => Intl.message('Cinema',  name: 'cinema');
  String get date => Intl.message('Date',  name: 'date');
  String get time => Intl.message('Time',  name: 'time');
  String get price => Intl.message('Price',  name: 'price');
  String get fee => Intl.message('Fee',  name: 'fee');
  String get total => Intl.message('Total',  name: 'total');
  String get yourWallet => Intl.message('Your Wallet',  name: 'yourWallet');
  String get checkoutNow => Intl.message('Checkout Now',  name: 'checkoutNow');
  String get topUpMyWallet => Intl.message('Top Up My Wallet',  name: 'topUpMyWallet');
  String get theater => Intl.message('Theater',  name: 'theater');
  String get chooseDate => Intl.message('Choose Date',  name: 'chooseDate');
  String get selectSchedule => Intl.message('Select Schedule',  name: 'selectSchedule');
  String get takeSeat => Intl.message('Take a Seat',  name: 'takeSeat');
  String get name => Intl.message('Name',  name: 'name');
  String get paid => Intl.message('Paid',  name: 'paid');
  String get ticketDetail => Intl.message('Ticket Detail',  name: 'ticketDetail');
  String get noTicketMessage => Intl.message('No ticket available',  name: 'noTicketMessage');
  String get active => Intl.message('Active',  name: 'active');
  String get history => Intl.message('History',  name: 'history');
  String get amount => Intl.message('Amount',  name: 'amount');
  String get chooseByTemplate => Intl.message('Choose by Template',  name: 'chooseByTemplate');
  String get topUp => Intl.message('Top Up',  name: 'topUp');
  String get cardHolder => Intl.message('Card Holder',  name: 'cardHolder');
  String get cardId => Intl.message('Card ID',  name: 'cardId');
  String get recentTransaction => Intl.message('Recent Transaction',  name: 'recentTransaction');
  String get promoCode => Intl.message('Promo Code',  name: 'promoCode');
  String get getVoucher => Intl.message('Get Voucher',  name: 'getVoucher');
  String get voucherNotFoundMessage => Intl.message('Voucher not found, try another',  name: 'voucherNotFoundMessage');
  String get voucherCode => Intl.message('Voucher code',  name: 'voucherCode');
  String get isAlreadyAcquired => Intl.message('is already acquired',  name: 'isAlreadyAcquired');
  String get successfullyAcquired => Intl.message('successfully acquired',  name: 'successfullyAcquired');
  String get expiredAcquired => Intl.message('is expired to be acquired',  name: 'expiredAcquired');
  String get activePromo => Intl.message('Active Promo',  name: 'activePromo');

  String get signOutConfirmMessage => Intl.message('Are you sure want to sign out?',  name: 'signOutConfirmMessage');
  String get signOutSubtitleMessage => Intl.message('Your personal preferences will be kept.',  name: 'signOutSubtitleMessage');

  String get remove => Intl.message('Remove',  name: 'remove');
  String get removeFavoriteMessage => Intl.message('removed from your favorite list',  name: 'removeFavoriteMessage');
  String get noFavoriteMessage => Intl.message('No favorite available',  name: 'noFavoriteMessage');

  String get nowPlaying => Intl.message('Now Playing',  name: 'nowPlaying');
  String get browseMovie => Intl.message('Browse Movie',  name: 'browseMovie');
  String get comingSoon => Intl.message('Coming Soon',  name: 'comingSoon');
  String get promotion => Intl.message('Promotion',  name: 'promotion');

  String get userId => Intl.message('User ID',  name: 'userId');
  String get changePassword => Intl.message('Change Password',  name: 'changePassword');
  String get updateMyProfile => Intl.message('Update My Profile',  name: 'updateMyProfile');
  String get updateProfileMessage => Intl.message('Profile successfully updated',  name: 'updateProfileMessage');

}