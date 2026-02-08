import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'My Cellar';

  @override
  String get settings => 'Einstellungen';

  @override
  String get user => 'Benutzer';

  @override
  String get theme => 'Design';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeSubtitle => 'Hell / dunkel';

  @override
  String get language => 'Sprache';

  @override
  String get logout => 'Abmelden';

  @override
  String get themeSwitchNotConnected => 'Designumschaltung noch nicht verbunden';

  @override
  String get languageSwitchNotConnected => 'Sprachumschaltung noch nicht verbunden';

  @override
  String get ingredients => 'Zutaten';

  @override
  String get addIngredient => 'Zutat hinzufügen';

  @override
  String get login => 'Anmelden';

  @override
  String get register => 'Registrieren';

  @override
  String get noIngredients => 'Keine Zutaten';

  @override
  String get retry => 'Wiederholen';

  @override
  String get newIngredient => 'Neue Zutat';

  @override
  String get name => 'Name';

  @override
  String get type => 'Typ';

  @override
  String get quantityOptional => 'Menge (optional)';

  @override
  String get quantityOrStatusHint => 'Zahl oder leer lassen';

  @override
  String get statusLabel => 'Bestandsstatus';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get statusNone => 'Keine';

  @override
  String get statusFew => 'Wenig';

  @override
  String get statusMedium => 'Mittel';

  @override
  String get statusHigh => 'Viel';

  @override
  String get typeUnknown => 'Unbekannt';

  @override
  String get typeSpice => 'Gewürz';

  @override
  String get typeMeat => 'Fleisch';

  @override
  String get typeVegetable => 'Gemüse';

  @override
  String get typeFruit => 'Obst';

  @override
  String get quantity => 'Menge';

  @override
  String get quantityNumber => 'Menge (Zahl)';

  @override
  String get ingredientDeleted => 'Zutat gelöscht';

  @override
  String get ingredientAdded => 'Zutat hinzugefügt';

  @override
  String get dataUpdated => 'Daten aktualisiert';

  @override
  String get deleteIngredientConfirm => 'Zutat löschen?';

  @override
  String deleteIngredientMessage(String name) {
    return 'Die Zutat «$name» wird gelöscht. Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get settingsTooltip => 'Einstellungen';

  @override
  String get addIngredientTooltip => 'Zutat hinzufügen';

  @override
  String get nameRequired => 'Bitte Namen eingeben';
}
