import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'l10n/messages_all.dart';

class AppLocalizations {
  AppLocalizations(this.localeName);

  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      return AppLocalizations(localeName);
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  final String localeName;

  String get welcomeToHive {
    return Intl.message(
      'Welcome to Hive',
      name: 'welcomeToHive',
      desc: 'A description onBoarding Title',
      locale: localeName,
    );
  }

  String get signInLabel {
    return Intl.message(
      'Sign in',
      name: 'signInLabel',
      desc: 'Sign In Label',
      locale: localeName,
    );
  }

  String get noHiveAccountYetLabel {
    return Intl.message(
      'Don\'t have a Hive account yet?',
      name: 'signInLabel',
      desc: 'Sign In Label',
      locale: localeName,
    );
  }

  String get registerLabel {
    return Intl.message(
      'Register hers',
      name: 'registerLabel',
      desc: 'Register Label',
      locale: localeName,
    );
  }

  String get welcomeToHiveMessage {
    return Intl.message(
      'Here you can connect to other communities and users near you',
      name: 'welcomeToHiveMessage',
      desc: 'A description onBoarding Description',
      locale: localeName,
    );
  }

  String get createHive {
    return Intl.message(
      'Let\'s create my own hive',
      name: 'createHive',
      desc: 'A description onBoarding main CTA',
      locale: localeName,
    );
  }

  String get alreadyHaveHive {
    return Intl.message(
      'I already have an account',
      name: 'alreadyHaveHive',
      desc: 'A description onBoarding link CTA',
      locale: localeName,
    );
  }

  String get verificationTitle {
    return Intl.message(
      'Verification',
      name: 'verificationTitle',
      desc: 'Verification title',
      locale: localeName,
    );
  }

  String get enterYourPhoneTitle {
    return Intl.message(
      'Enter your phone number',
      name: 'enterYourPhoneTitle',
      desc: 'Enter your phone number title',
      locale: localeName
    );
  }

  String get regionTitle {
    return Intl.message(
      'Region',
      name: 'regionTitle',
      desc: 'Region title',
      locale: localeName,
    );
  }

  String get sendButton {
    return Intl.message(
      'Send',
      name: 'sendButton',
      desc: 'Send button',
      locale: localeName,
    );
  }

  String get verifyTokenTitle {
    return Intl.message(
      'Verify token',
      name: 'verifyTokenTitle',
      desc: 'Verify token, title',
      locale: localeName,
    );
  }

  String get verifyTokenInstructionTitle {
    return Intl.message(
      'Please type the token you received',
      name: 'verifyTokenInstructionTitle',
      desc: 'Verify token instructions, title',
      locale: localeName,
    );
  }

  String get verificationCodeHint {
    return Intl.message(
      'Verification code',
      name: 'verificationCodeHint',
      desc: 'Verification code, hint',
      locale: localeName,
    );
  }

  String verifyTokenResendTitle(time) => Intl.message(
    'You can request a new verification token in $time seconds.',
    name: 'verifyTokenInstructionTitle',
    args:[time],
    desc: 'Verify token instructions, title',
    locale: localeName,
  );

  String get resendTokenButton {
    return Intl.message(
      'Resend token',
      name: 'resendTokenButton',
      desc: 'Resend token, button',
      locale: localeName,
    );
  }

  String get wrongTokenWarningSnackbar {
    return Intl.message(
      'The token is wrong, please try again',
      name: 'wrongTokenWarningSnackbar',
      desc: 'Wrong token warning snackbar',
      locale: localeName,
    );
  }

  String get generalWarningSnackbar {
    return Intl.message(
      'Some of the fields are not valid',
      name: 'generalWarningSnackbar',
      desc: 'General warning snackbar',
      locale: localeName,
    );
  }

  String get okContinueButton {
    return Intl.message(
      'Ok, continue',
      name: 'okContinueButton',
      desc: 'Ok, continue button',
      locale: localeName,
    );
  }

  String get backButton {
    return Intl.message(
      'Back',
      name: 'backButton',
      desc: 'Back button',
      locale: localeName,
    );
  }

  String get nextButton {
    return Intl.message(
      'Next',
      name: 'nextButton',
      desc: 'Next button',
      locale: localeName,
    );
  }

  String get createYourNewHiveTitle {
    return Intl.message(
      'Create your new hive',
      name: 'createYourNewHiveTitle',
      desc: 'Create your new hive title',
      locale: localeName,
    );
  }

  String get passwordLabel {
    return Intl.message(
      'Password',
      name: 'passwordLabel',
      desc: 'Password label',
      locale: localeName,
    );
  }

  String get passwordHint {
    return Intl.message(
      'Password (8 - 32 characters)',
      name: 'passwordHint',
      desc: 'Password hint',
      locale: localeName,
    );
  }

  String get confirmPasswordHint {
    return Intl.message(
      'Confirm password',
      name: 'confirmPasswordHint',
      desc: 'Confirm password hint',
      locale: localeName,
    );
  }

  String get passwordsMismatchHint {
    return Intl.message(
      'Passwords mismatch',
      name: 'passwordsMismatchHint',
      desc: 'Passwords mismatch hint',
      locale: localeName,
    );
  }

  String get confirmPasswordInstructions {
    return Intl.message(
      'Your password must be between 8 to 32 characters',
      name: 'confirmPasswordInstructions',
      desc: 'Confirm password instructions',
      locale: localeName,
    );
  }

  String get addEmailHint {
    return Intl.message(
      'Add email',
      name: 'addEmailHint',
      desc: 'Add email hint',
      locale: localeName,
    );
  }

  String get emailLabel {
    return Intl.message(
      'Email',
      name: 'emailLabel',
      desc: 'Email',
      locale: localeName,
    );
  }

  String get invalidEmailWarning {
    return Intl.message(
      'Please enter a valid email',
      name: 'invalidEmailWarning',
      desc: 'Invalid email warning',
      locale: localeName,
    );
  }

  String get nameHint {
    return Intl.message(
      'Name (required)',
      name: 'nameHint',
      desc: 'Name hint',
      locale: localeName,
    );
  }

  String get fieldRequiredWarning {
    return Intl.message(
      'This field is required',
      name: 'fieldRequiredWarning',
      desc: 'Field required warning',
      locale: localeName,
    );
  }

  String get nameRuleHint {
    return Intl.message(
      'Name (3 - 22 characters)',
      name: 'nameRuleHint',
      desc: 'Name rule hint',
      locale: localeName,
    );
  }

  String get dobHint {
    return Intl.message(
      'Date of birth (required)',
      name: 'dobHint',
      desc: 'DOB hint',
      locale: localeName,
    );
  }

  String get genderHint {
    return Intl.message(
      'Gender (required)',
      name: 'genderHint',
      desc: 'Gender hint',
      locale: localeName,
    );
  }

  String get maleDropdownItem {
    return Intl.message(
      'Male',
      name: 'genderMaleDropdownItem',
      desc: 'Male drop down item',
      locale: localeName,
    );
  }

  String get femaleDropdownItem {
    return Intl.message(
      'Female',
      name: 'genderFemaleDropdownItem',
      desc: 'Female drop down item',
      locale: localeName,
    );
  }

  String get otherDropdownItem {
    return Intl.message(
      'Other',
      name: 'otherDropdownItem',
      desc: 'Other drop down item',
      locale: localeName,
    );
  }

  String get customGenderHint {
    return Intl.message(
      'Add your own gender description',
      name: 'customGenderHint',
      desc: 'Custom gender hint',
      locale: localeName,
    );
  }

  String get calendarDone {
    return Intl.message(
      'Done',
      name: 'calendarDone',
      desc: 'Calendar done',
      locale: localeName,
    );
  }

  String get syncContactsLabel {
    return Intl.message(
      'Sync contacts',
      name: 'syncContactsLabel',
      desc: 'Sync contacts label',
      locale: localeName,
    );
  }

  String get processingDataSnackBar {
    return Intl.message(
      'Processing data ...',
      name: 'processingDataSnackBar',
      desc: 'Processing data snack bar',
      locale: localeName,
    );
  }

  String get categoriesTitle {
    return Intl.message(
      'Categories',
      name: 'categoriesTitle',
      desc: 'Categories title',
      locale: localeName,
    );
  }

  String get categoriesSubTitle {
    return Intl.message(
      'Which topics would you like to converse about?',
      name: 'categoriesSubTitle',
      desc: 'Categories sub title',
      locale: localeName,
    );
  }

  String get categoriesDoneButton {
    return Intl.message(
      'That\'s it, we are good to start',
      name: 'categoriesDoneButton',
      desc: 'Categories Done Button',
      locale: localeName,
    );
  }

  String get categoriesKeyCooking {
    return Intl.message(
      'Cooking',
      name: 'categoriesKeyCooking',
      desc: 'Categories key cooking',
      locale: localeName,
    );
  }

  String get categoriesKeySports {
    return Intl.message(
      'Sports',
      name: 'categoriesKeySports',
      desc: 'Categories key sports',
      locale: localeName,
    );
  }

  String get categoriesKeyAnimals {
    return Intl.message(
      'Animals',
      name: 'categoriesKeyAnimals',
      desc: 'Categories key animals',
      locale: localeName,
    );
  }

  String get categoriesKeyParenting {
    return Intl.message(
      'Parenting',
      name: 'categoriesKeyParenting',
      desc: 'Categories key parenting',
      locale: localeName,
    );
  }

  String get categoriesKeyLoveAndDating {
    return Intl.message(
      'Love & Dating',
      name: 'categoriesKeyLoveAndDating',
      desc: 'Categories key love and dating',
      locale: localeName,
    );
  }

  String get categoriesKeyGaming {
    return Intl.message(
      'Gaming',
      name: 'categoriesKeyGaming',
      desc: 'Categories key gaming',
      locale: localeName,
    );
  }

  String get pleaseTryAgainWarningSnackbar {
    return Intl.message(
      'Please try again',
      name: 'pleaseTryAgainWarningSnackbar',
      desc: 'Please try again warning snackbar',
      locale: localeName,
    );
  }

  String get loginSuccessMessageSnackbar {
    return Intl.message(
      'Logged in ...',
      name: 'loginSuccessMessageSnackbar',
      desc: 'Login success message snackbar',
      locale: localeName,
    );
  }

  String get logoutButton {
    return Intl.message(
      'Log out',
      name: 'logoutButton',
      desc: 'Logout Button',
      locale: localeName,
    );
  }

  String get noOtherPeopleFoundMessage {
    return Intl.message(
      'No other people found',
      name: 'noOtherPeopleFoundMessage',
      desc: 'No other people found Message',
      locale: localeName,
    );
  }

  String get searchHereHint {
    return Intl.message(
      'Search here ....',
      name: 'searchHereHint',
      desc: 'Search here hint',
      locale: localeName,
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'he'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}