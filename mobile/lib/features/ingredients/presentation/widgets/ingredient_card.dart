import 'package:flutter/material.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../core/network/dto/ingredient_dto.dart';
import '../../../../core/network/ingredients_api.dart';
import '../../domain/ingredient_item.dart';

/// Карточка ингредиента: по нажатию раскрывается с редактированием количества и статуса.
class IngredientCard extends StatefulWidget {
  const IngredientCard({
    super.key,
    required this.item,
    required this.authService,
    required this.onUpdated,
  });

  final IngredientItem item;
  final AuthService authService;
  final VoidCallback onUpdated;

  @override
  State<IngredientCard> createState() => _IngredientCardState();
}

class _IngredientCardState extends State<IngredientCard> {
  bool _expanded = false;
  late TextEditingController _amountController;
  late IngredientStockStatus _status;
  bool _saving = false;
  bool _deleting = false;

  static const _statusLabels = {
    IngredientStockStatus.none: 'Нет',
    IngredientStockStatus.few: 'Мало',
    IngredientStockStatus.medium: 'Средне',
    IngredientStockStatus.high: 'Много',
  };

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.item.amount?.toString() ?? '',
    );
    _status = widget.item.status;
  }

  @override
  void didUpdateWidget(IngredientCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item && !_expanded) {
      _amountController.text = widget.item.amount?.toString() ?? '';
      _status = widget.item.status;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveAmount() async {
    final id = widget.item.id;
    if (id == null) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final amountText = _amountController.text.trim();
      final amount = amountText.isEmpty ? null : int.tryParse(amountText);

      final request = UpdateIngredientRequestDto(
        name: widget.item.name,
        type: widget.item.type.name.toUpperCase(),
        status: _status.name.toUpperCase(),
        amount: amount,
      );

      final api = IngredientsApi(widget.authService.getApiClient().dio);
      await api.update(id, request);

      if (!mounted) return;
      setState(() {
        _saving = false;
        _expanded = false;
      });
      widget.onUpdated();
      messenger.showSnackBar(const SnackBar(content: Text('Данные обновлены')));
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
        SnackBar(content: Text(messageFromIngredientError(e))),
      );
    }
  }

  Future<void> _deleteIngredient() async {
    final id = widget.item.id;
    if (id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить ингредиент?'),
        content: Text(
          'Ингредиент «${widget.item.name}» будет удалён. Это действие нельзя отменить.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _deleting = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final api = IngredientsApi(widget.authService.getApiClient().dio);
      await api.delete(id);
      if (!mounted) return;
      widget.onUpdated();
      messenger.showSnackBar(const SnackBar(content: Text('Ингредиент удалён')));
    } catch (e) {
      if (!mounted) return;
      setState(() => _deleting = false);
      messenger.showSnackBar(
        SnackBar(content: Text(messageFromIngredientError(e))),
      );
    }
  }

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
    final item = widget.item;
    final iconColor = _colorForType(item.type);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () {
          if (widget.item.id != null) {
            setState(() => _expanded = !_expanded);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
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
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Text(
                  'Количество (число)',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    hintText: 'Число или оставьте пустым',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  enabled: !_saving && !_deleting,
                ),
                const SizedBox(height: 16),
                Text(
                  'Статус наличия',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<IngredientStockStatus>(
                  value: _status,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: IngredientStockStatus.values
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(_statusLabels[s]!),
                          ))
                      .toList(),
                  onChanged: (_saving || _deleting)
                      ? null
                      : (value) => setState(() => _status = value!),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: (_saving || _deleting)
                          ? null
                          : _deleteIngredient,
                      icon: Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: (_saving || _deleting)
                            ? theme.colorScheme.onSurface.withOpacity(0.38)
                            : theme.colorScheme.error,
                      ),
                      label: Text(
                        'Удалить',
                        style: TextStyle(
                          color: (_saving || _deleting)
                              ? theme.colorScheme.onSurface.withOpacity(0.38)
                              : theme.colorScheme.error,
                        ),
                      ),
                    ),
                    _saving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : FilledButton(
                            onPressed: _saveAmount,
                            child: const Text('Сохранить'),
                          ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
