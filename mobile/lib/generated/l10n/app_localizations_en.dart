import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Cellar';

  @override
  String get settings => 'Settings';

  @override
  String get user => 'User';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSubtitle => 'Light / dark theme';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Log out';

  @override
  String get themeSwitchNotConnected => 'Theme switching is not connected yet';

  @override
  String get languageSwitchNotConnected => 'Language switching is not connected yet';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get addIngredient => 'Add ingredient';

  @override
  String get login => 'Log in';

  @override
  String get register => 'Register';

  @override
  String get noIngredients => 'No ingredients';

  @override
  String get retry => 'Retry';

  @override
  String get newIngredient => 'New ingredient';

  @override
  String get name => 'Name';

  @override
  String get type => 'Type';

  @override
  String get quantityOptional => 'Quantity (optional)';

  @override
  String get quantityOrStatusHint => 'Number or leave empty';

  @override
  String get statusLabel => 'Stock status';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get statusNone => 'None';

  @override
  String get statusFew => 'Few';

  @override
  String get statusMedium => 'Medium';

  @override
  String get statusHigh => 'High';

  @override
  String get typeUnknown => 'Unknown';

  @override
  String get typeSpice => 'Spice';

  @override
  String get typeMeat => 'Meat';

  @override
  String get typeVegetable => 'Vegetable';

  @override
  String get typeFruit => 'Fruit';

  @override
  String get quantity => 'Quantity';

  @override
  String get quantityNumber => 'Quantity (number)';

  @override
  String get ingredientDeleted => 'Ingredient deleted';

  @override
  String get ingredientAdded => 'Ingredient added';

  @override
  String get dataUpdated => 'Data updated';

  @override
  String get deleteIngredientConfirm => 'Delete ingredient?';

  @override
  String deleteIngredientMessage(String name) {
    return 'Ingredient \"$name\" will be deleted. This cannot be undone.';
  }

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get addIngredientTooltip => 'Add ingredient';

  @override
  String get nameRequired => 'Please enter a name';

  @override
  String get newCellar => 'New cellar';

  @override
  String get cellars => 'Cellars';

  @override
  String get noCellars => 'No cellars';
}
