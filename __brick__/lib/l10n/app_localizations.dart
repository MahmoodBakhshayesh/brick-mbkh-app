import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa')
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login Success'**
  String get loginSuccess;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @messaging.
  ///
  /// In en, this message translates to:
  /// **'Messaging'**
  String get messaging;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @prev.
  ///
  /// In en, this message translates to:
  /// **'Prev'**
  String get prev;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hour;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get minute;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'submit'**
  String get submit;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @coffees.
  ///
  /// In en, this message translates to:
  /// **'Coffees'**
  String get coffees;

  /// No description provided for @procedures.
  ///
  /// In en, this message translates to:
  /// **'Procedures'**
  String get procedures;

  /// No description provided for @recipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get recipes;

  /// No description provided for @tokenExpired.
  ///
  /// In en, this message translates to:
  /// **'Token Expired'**
  String get tokenExpired;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @welcomeToBrewLab.
  ///
  /// In en, this message translates to:
  /// **'Welcome to BrewLab'**
  String get welcomeToBrewLab;

  /// No description provided for @plzInsertPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Start by inserting your phone number'**
  String get plzInsertPhoneNumber;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phoneEg.
  ///
  /// In en, this message translates to:
  /// **'e.g. 09123456789'**
  String get phoneEg;

  /// No description provided for @checkPhone.
  ///
  /// In en, this message translates to:
  /// **'Check Phone'**
  String get checkPhone;

  /// No description provided for @sendActivationCode.
  ///
  /// In en, this message translates to:
  /// **'Send Activation Code'**
  String get sendActivationCode;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Activation Code'**
  String get code;

  /// No description provided for @insertActivationCode.
  ///
  /// In en, this message translates to:
  /// **'Insert Activation Code'**
  String get insertActivationCode;

  /// No description provided for @weSentActivationCodeInsertIt.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent you an activation code. please insert it'**
  String get weSentActivationCodeInsertIt;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Did not received code?'**
  String get didNotReceiveCode;

  /// No description provided for @changeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change phone number'**
  String get changeNumber;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'until'**
  String get to;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @completeProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get completeProfile;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @insertYourName.
  ///
  /// In en, this message translates to:
  /// **'Insert your name'**
  String get insertYourName;

  /// No description provided for @insertYourPass.
  ///
  /// In en, this message translates to:
  /// **'Insert your password'**
  String get insertYourPass;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterPasswordToEnter.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password to login'**
  String get enterPasswordToEnter;

  /// No description provided for @loginOrSignup.
  ///
  /// In en, this message translates to:
  /// **'Login or SignUp'**
  String get loginOrSignup;

  /// No description provided for @brewMethods.
  ///
  /// In en, this message translates to:
  /// **'Brew Methods'**
  String get brewMethods;

  /// No description provided for @brewMethodSteps.
  ///
  /// In en, this message translates to:
  /// **'Brew Method Steps'**
  String get brewMethodSteps;

  /// No description provided for @otpLogin.
  ///
  /// In en, this message translates to:
  /// **'Login with OTP'**
  String get otpLogin;

  /// No description provided for @roasters.
  ///
  /// In en, this message translates to:
  /// **'Roasters'**
  String get roasters;

  /// No description provided for @addRoaster.
  ///
  /// In en, this message translates to:
  /// **'Add Roaster'**
  String get addRoaster;

  /// No description provided for @addCoffee.
  ///
  /// In en, this message translates to:
  /// **'Add Coffee'**
  String get addCoffee;

  /// No description provided for @webUrl.
  ///
  /// In en, this message translates to:
  /// **'Add Coffee'**
  String get webUrl;

  /// No description provided for @instaUrl.
  ///
  /// In en, this message translates to:
  /// **'Add Coffee'**
  String get instaUrl;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Add Coffee'**
  String get description;

  /// No description provided for @roaster.
  ///
  /// In en, this message translates to:
  /// **'Roaster'**
  String get roaster;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// No description provided for @farm.
  ///
  /// In en, this message translates to:
  /// **'Farm'**
  String get farm;

  /// No description provided for @variety.
  ///
  /// In en, this message translates to:
  /// **'Variety'**
  String get variety;

  /// No description provided for @processMethod.
  ///
  /// In en, this message translates to:
  /// **'Process Method'**
  String get processMethod;

  /// No description provided for @roastLevel.
  ///
  /// In en, this message translates to:
  /// **'Roast Level'**
  String get roastLevel;

  /// No description provided for @roastDate.
  ///
  /// In en, this message translates to:
  /// **'Roast Date'**
  String get roastDate;

  /// No description provided for @harvestDate.
  ///
  /// In en, this message translates to:
  /// **'Harvest Date'**
  String get harvestDate;

  /// No description provided for @altitudeMin.
  ///
  /// In en, this message translates to:
  /// **'Altitude Min'**
  String get altitudeMin;

  /// No description provided for @altitudeMax.
  ///
  /// In en, this message translates to:
  /// **'Altitude Max'**
  String get altitudeMax;

  /// No description provided for @lot.
  ///
  /// In en, this message translates to:
  /// **'Lot'**
  String get lot;

  /// No description provided for @productUrl.
  ///
  /// In en, this message translates to:
  /// **'Product Url'**
  String get productUrl;

  /// No description provided for @packageSize.
  ///
  /// In en, this message translates to:
  /// **'Package Size'**
  String get packageSize;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @cuppingScore.
  ///
  /// In en, this message translates to:
  /// **'Cupping Score'**
  String get cuppingScore;

  /// No description provided for @flavorAttributes.
  ///
  /// In en, this message translates to:
  /// **'Flavor Attributes'**
  String get flavorAttributes;

  /// No description provided for @customFlavorNotes.
  ///
  /// In en, this message translates to:
  /// **'Custom Flavor Notes'**
  String get customFlavorNotes;

  /// No description provided for @recommendedBrewMethods.
  ///
  /// In en, this message translates to:
  /// **'Recommended Brew Methods'**
  String get recommendedBrewMethods;

  /// No description provided for @isBlend.
  ///
  /// In en, this message translates to:
  /// **'Is Blend'**
  String get isBlend;

  /// No description provided for @blendItems.
  ///
  /// In en, this message translates to:
  /// **'Blend Items'**
  String get blendItems;

  /// No description provided for @isPublic.
  ///
  /// In en, this message translates to:
  /// **'Is Public'**
  String get isPublic;

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'Percent'**
  String get percent;

  /// No description provided for @insertYourProfession.
  ///
  /// In en, this message translates to:
  /// **'Select Your Profession'**
  String get insertYourProfession;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @profession.
  ///
  /// In en, this message translates to:
  /// **'Profession'**
  String get profession;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @createRecipe.
  ///
  /// In en, this message translates to:
  /// **'Create Recipe'**
  String get createRecipe;

  /// No description provided for @coffeeAmount.
  ///
  /// In en, this message translates to:
  /// **'Coffee Amount'**
  String get coffeeAmount;

  /// No description provided for @waterAmount.
  ///
  /// In en, this message translates to:
  /// **'Water Amount'**
  String get waterAmount;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @grindSize.
  ///
  /// In en, this message translates to:
  /// **'Grind Size'**
  String get grindSize;

  /// No description provided for @coffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get coffee;

  /// No description provided for @addStep.
  ///
  /// In en, this message translates to:
  /// **'Add Step'**
  String get addStep;

  /// No description provided for @selectStep.
  ///
  /// In en, this message translates to:
  /// **'Select Step'**
  String get selectStep;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @recipeDetails.
  ///
  /// In en, this message translates to:
  /// **'Recipe Details'**
  String get recipeDetails;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @myRecipes.
  ///
  /// In en, this message translates to:
  /// **'My Recipe'**
  String get myRecipes;

  /// No description provided for @publicRecipes.
  ///
  /// In en, this message translates to:
  /// **'Public Recipe'**
  String get publicRecipes;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fa': return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
