import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'My Cellar';

  @override
  String get settings => 'Ajustes';

  @override
  String get user => 'Usuario';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSubtitle => 'Tema claro / oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get themeSwitchNotConnected => 'Cambio de tema no conectado aún';

  @override
  String get languageSwitchNotConnected => 'Cambio de idioma no conectado aún';

  @override
  String get ingredients => 'Ingredientes';

  @override
  String get addIngredient => 'Añadir ingrediente';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get noIngredients => 'Sin ingredientes';

  @override
  String get retry => 'Reintentar';

  @override
  String get newIngredient => 'Nuevo ingrediente';

  @override
  String get name => 'Nombre';

  @override
  String get type => 'Tipo';

  @override
  String get quantityOptional => 'Cantidad (opcional)';

  @override
  String get quantityOrStatusHint => 'Número o dejar vacío';

  @override
  String get statusLabel => 'Estado de stock';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get statusNone => 'Ninguno';

  @override
  String get statusFew => 'Poco';

  @override
  String get statusMedium => 'Medio';

  @override
  String get statusHigh => 'Mucho';

  @override
  String get typeUnknown => 'Desconocido';

  @override
  String get typeSpice => 'Especia';

  @override
  String get typeMeat => 'Carne';

  @override
  String get typeVegetable => 'Verdura';

  @override
  String get typeFruit => 'Fruta';

  @override
  String get quantity => 'Cantidad';

  @override
  String get quantityNumber => 'Cantidad (número)';

  @override
  String get ingredientDeleted => 'Ingrediente eliminado';

  @override
  String get ingredientAdded => 'Ingrediente añadido';

  @override
  String get dataUpdated => 'Datos actualizados';

  @override
  String get deleteIngredientConfirm => '¿Eliminar ingrediente?';

  @override
  String deleteIngredientMessage(String name) {
    return 'El ingrediente «$name» se eliminará. Esta acción no se puede deshacer.';
  }

  @override
  String get settingsTooltip => 'Ajustes';

  @override
  String get addIngredientTooltip => 'Añadir ingrediente';

  @override
  String get nameRequired => 'Introduce un nombre';
}
