import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'My Cellar';

  @override
  String get settings => 'Настройки';

  @override
  String get user => 'Пользователь';

  @override
  String get theme => 'Тема';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeSubtitle => 'Светлая / тёмная тема';

  @override
  String get language => 'Язык';

  @override
  String get logout => 'Выйти';

  @override
  String get themeSwitchNotConnected => 'Переключение темы пока не подключено';

  @override
  String get languageSwitchNotConnected => 'Смена языка пока не подключена';

  @override
  String get ingredients => 'Ингредиенты';

  @override
  String get addIngredient => 'Добавить ингредиент';

  @override
  String get login => 'Войти';

  @override
  String get register => 'Регистрация';

  @override
  String get noIngredients => 'Нет ингредиентов';

  @override
  String get retry => 'Повторить';

  @override
  String get newIngredient => 'Новый ингредиент';

  @override
  String get name => 'Название';

  @override
  String get type => 'Тип';

  @override
  String get quantityOptional => 'Количество (опционально)';

  @override
  String get quantityOrStatusHint => 'Число или оставьте пустым';

  @override
  String get statusLabel => 'Статус наличия';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get statusNone => 'Нет';

  @override
  String get statusFew => 'Мало';

  @override
  String get statusMedium => 'Средне';

  @override
  String get statusHigh => 'Много';

  @override
  String get typeUnknown => 'Неизвестно';

  @override
  String get typeSpice => 'Специя';

  @override
  String get typeMeat => 'Мясо';

  @override
  String get typeVegetable => 'Овощ';

  @override
  String get typeFruit => 'Фрукт';

  @override
  String get quantity => 'Количество';

  @override
  String get quantityNumber => 'Количество (число)';

  @override
  String get ingredientDeleted => 'Ингредиент удалён';

  @override
  String get ingredientAdded => 'Ингредиент добавлен';

  @override
  String get dataUpdated => 'Данные обновлены';

  @override
  String get deleteIngredientConfirm => 'Удалить ингредиент?';

  @override
  String deleteIngredientMessage(String name) {
    return 'Ингредиент «$name» будет удалён. Это действие нельзя отменить.';
  }

  @override
  String get settingsTooltip => 'Настройки';

  @override
  String get addIngredientTooltip => 'Добавить ингредиент';

  @override
  String get nameRequired => 'Введите название';
}
