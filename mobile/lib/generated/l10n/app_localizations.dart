import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ru.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'My Cellar'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Light / dark theme'**
  String get themeSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @themeSwitchNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Theme switching is not connected yet'**
  String get themeSwitchNotConnected;

  /// No description provided for @languageSwitchNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Language switching is not connected yet'**
  String get languageSwitchNotConnected;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @addIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add ingredient'**
  String get addIngredient;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @noIngredients.
  ///
  /// In en, this message translates to:
  /// **'No ingredients'**
  String get noIngredients;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @newIngredient.
  ///
  /// In en, this message translates to:
  /// **'New ingredient'**
  String get newIngredient;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @quantityOptional.
  ///
  /// In en, this message translates to:
  /// **'Quantity (optional)'**
  String get quantityOptional;

  /// No description provided for @quantityOrStatusHint.
  ///
  /// In en, this message translates to:
  /// **'Number or leave empty'**
  String get quantityOrStatusHint;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock status'**
  String get statusLabel;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @statusNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get statusNone;

  /// No description provided for @statusFew.
  ///
  /// In en, this message translates to:
  /// **'Few'**
  String get statusFew;

  /// No description provided for @statusMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get statusMedium;

  /// No description provided for @statusHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get statusHigh;

  /// No description provided for @typeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get typeUnknown;

  /// No description provided for @typeSpice.
  ///
  /// In en, this message translates to:
  /// **'Spice'**
  String get typeSpice;

  /// No description provided for @typeMeat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get typeMeat;

  /// No description provided for @typeVegetable.
  ///
  /// In en, this message translates to:
  /// **'Vegetable'**
  String get typeVegetable;

  /// No description provided for @typeFruit.
  ///
  /// In en, this message translates to:
  /// **'Fruit'**
  String get typeFruit;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @quantityNumber.
  ///
  /// In en, this message translates to:
  /// **'Quantity (number)'**
  String get quantityNumber;

  /// No description provided for @ingredientDeleted.
  ///
  /// In en, this message translates to:
  /// **'Ingredient deleted'**
  String get ingredientDeleted;

  /// No description provided for @ingredientAdded.
  ///
  /// In en, this message translates to:
  /// **'Ingredient added'**
  String get ingredientAdded;

  /// No description provided for @dataUpdated.
  ///
  /// In en, this message translates to:
  /// **'Data updated'**
  String get dataUpdated;

  /// No description provided for @deleteIngredientConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete ingredient?'**
  String get deleteIngredientConfirm;

  /// No description provided for @deleteIngredientMessage.
  ///
  /// In en, this message translates to:
  /// **'Ingredient \"{name}\" will be deleted. This cannot be undone.'**
  String deleteIngredientMessage(String name);

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @addIngredientTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add ingredient'**
  String get addIngredientTooltip;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get nameRequired;

  /// No description provided for @newCellar.
  ///
  /// In en, this message translates to:
  /// **'New cellar'**
  String get newCellar;

  /// No description provided for @cellars.
  ///
  /// In en, this message translates to:
  /// **'Cellars'**
  String get cellars;

  /// No description provided for @noCellars.
  ///
  /// In en, this message translates to:
  /// **'No cellars'**
  String get noCellars;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
