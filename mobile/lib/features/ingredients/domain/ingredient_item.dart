/// Тип ингредиента (совпадает с бэкендом).
enum IngredientType {
  unknown,
  spice,
  meat,
  vegetable,
  fruit,
}

/// Статус наличия (совпадает с бэкендом).
enum IngredientStockStatus {
  none,
  few,
  medium,
  high,
}

/// Элемент списка ингредиентов для карточки.
class IngredientItem {
  final int? id;
  final String name;
  final IngredientType type;
  final int? amount;
  final IngredientStockStatus status;

  const IngredientItem({
    this.id,
    required this.name,
    required this.type,
    this.amount,
    this.status = IngredientStockStatus.none,
  });

  /// Показать число, если задано количество, иначе — статус.
  String get quantityOrStatusLabel {
    if (amount != null) return amount.toString();
    switch (status) {
      case IngredientStockStatus.none:
        return 'Нет';
      case IngredientStockStatus.few:
        return 'Мало';
      case IngredientStockStatus.medium:
        return 'Средне';
      case IngredientStockStatus.high:
        return 'Много';
    }
  }
}
