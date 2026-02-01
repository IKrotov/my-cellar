import 'package:flutter/material.dart';

import '../../domain/ingredient_item.dart';

/// Нижняя панель с формой добавления ингредиента.
class AddIngredientSheet extends StatefulWidget {
  const AddIngredientSheet({super.key});

  @override
  State<AddIngredientSheet> createState() => _AddIngredientSheetState();
}

class _AddIngredientSheetState extends State<AddIngredientSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  IngredientType _type = IngredientType.vegetable;
  IngredientStockStatus _status = IngredientStockStatus.none;

  static const _typeLabels = {
    IngredientType.unknown: 'Неизвестно',
    IngredientType.spice: 'Специя',
    IngredientType.meat: 'Мясо',
    IngredientType.vegetable: 'Овощ',
    IngredientType.fruit: 'Фрукт',
  };

  static const _statusLabels = {
    IngredientStockStatus.none: 'Нет',
    IngredientStockStatus.few: 'Мало',
    IngredientStockStatus.medium: 'Средне',
    IngredientStockStatus.high: 'Много',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onAdd() {
    if (!_formKey.currentState!.validate()) return;
    // Заглушка: API пока не вызываем
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      const SnackBar(content: Text('Добавление пока не подключено')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 24 + MediaQuery.of(context).padding.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Новый ингредиент',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Название',
                hintText: 'Например: Чеснок',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите название';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<IngredientType>(
              value: _type,
              decoration: const InputDecoration(
                labelText: 'Тип',
                border: OutlineInputBorder(),
              ),
              items: IngredientType.values
                  .map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(_typeLabels[t]!),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _type = value!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Количество (опционально)',
                hintText: 'Число',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            Text(
              'Если не указано — используется статус ниже',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<IngredientStockStatus>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Статус наличия',
                border: OutlineInputBorder(),
              ),
              items: IngredientStockStatus.values
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(_statusLabels[s]!),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _status = value!),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Отмена'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _onAdd,
                  child: const Text('Добавить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
