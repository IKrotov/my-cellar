import 'package:flutter/material.dart';

import '../../domain/ingredient_item.dart';

/// Карточка ингредиента: иконка по типу, название, количество или статус.
class IngredientCard extends StatelessWidget {
  const IngredientCard({
    super.key,
    required this.item,
  });

  final IngredientItem item;

  static IconData _iconForType(IngredientType type) {
    switch (type) {
      case IngredientType.spice:
        return Icons.eco;
      case IngredientType.meat:
        return Icons.set_meal;
      case IngredientType.vegetable:
        return Icons.grass;
      case IngredientType.fruit:
        return Icons.apple;
      case IngredientType.unknown:
        return Icons.help_outline;
    }
  }

  static Color _colorForType(IngredientType type) {
    switch (type) {
      case IngredientType.spice:
        return Colors.brown;
      case IngredientType.meat:
        return Colors.deepOrange;
      case IngredientType.vegetable:
        return Colors.green;
      case IngredientType.fruit:
        return Colors.red;
      case IngredientType.unknown:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = _colorForType(item.type);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _iconForType(item.type),
                size: 28,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.quantityOrStatusLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
