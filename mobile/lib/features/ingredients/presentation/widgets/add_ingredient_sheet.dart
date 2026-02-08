import 'package:flutter/material.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../core/network/dto/ingredient_dto.dart';
import '../../../../core/network/ingredients_api.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../domain/ingredient_item.dart';

/// Нижняя панель с формой добавления ингредиента.
class AddIngredientSheet extends StatefulWidget {
  const AddIngredientSheet({
    super.key,
    required this.authService,
    this.onSuccess,
  });

  final AuthService authService;
  final VoidCallback? onSuccess;

  @override
  State<AddIngredientSheet> createState() => _AddIngredientSheetState();
}

class _AddIngredientSheetState extends State<AddIngredientSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  IngredientType _type = IngredientType.vegetable;
  IngredientStockStatus _status = IngredientStockStatus.none;
  bool _sending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _onAdd() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final amountText = _amountController.text.trim();
      final amount = amountText.isEmpty ? null : int.tryParse(amountText);

      final request = CreateIngredientRequestDto(
        name: _nameController.text.trim(),
        type: _type.name.toUpperCase(),
        status: _status.name.toUpperCase(),
        amount: amount,
      );

      final dio = widget.authService.getApiClient().dio;
      final api = IngredientsApi(dio);
      await api.create(request);

      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onSuccess?.call();
      messenger.showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.ingredientAdded)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      messenger.showSnackBar(
        SnackBar(content: Text(messageFromIngredientError(e))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    String typeLabel(IngredientType t) {
      switch (t) {
        case IngredientType.unknown:
          return l10n.typeUnknown;
        case IngredientType.spice:
          return l10n.typeSpice;
        case IngredientType.meat:
          return l10n.typeMeat;
        case IngredientType.vegetable:
          return l10n.typeVegetable;
        case IngredientType.fruit:
          return l10n.typeFruit;
      }
    }

    String statusLabel(IngredientStockStatus s) {
      switch (s) {
        case IngredientStockStatus.none:
          return l10n.statusNone;
        case IngredientStockStatus.few:
          return l10n.statusFew;
        case IngredientStockStatus.medium:
          return l10n.statusMedium;
        case IngredientStockStatus.high:
          return l10n.statusHigh;
      }
    }

    final media = MediaQuery.of(context);
    final bottomPadding = 24.0 + media.padding.bottom + media.viewInsets.bottom;
    final maxHeight = media.size.height * 0.85 - media.viewInsets.bottom;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: bottomPadding,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.newIngredient,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.name,
                  hintText: 'Garlic',
                  border: const OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.nameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<IngredientType>(
                value: _type,
                decoration: InputDecoration(
                  labelText: l10n.type,
                  border: const OutlineInputBorder(),
                ),
                items: IngredientType.values
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(typeLabel(t)),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _type = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: l10n.quantityOptional,
                  hintText: l10n.quantityOrStatusHint,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.quantityOrStatusHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<IngredientStockStatus>(
                value: _status,
                decoration: InputDecoration(
                  labelText: l10n.statusLabel,
                  border: const OutlineInputBorder(),
                ),
                items: IngredientStockStatus.values
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(statusLabel(s)),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _sending ? null : () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _sending ? null : _onAdd,
                    child: _sending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.save),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
