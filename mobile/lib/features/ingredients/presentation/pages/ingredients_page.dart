import 'package:flutter/material.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../core/network/dto/ingredient_dto.dart';
import '../../../../core/network/ingredients_api.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../widgets/add_ingredient_sheet.dart';
import '../widgets/ingredient_card.dart';
import '../../domain/ingredient_item.dart';

class IngredientsPage extends StatefulWidget {
  const IngredientsPage({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  @override
  State<IngredientsPage> createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  List<IngredientItem> _ingredients = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final dio = widget.authService.getApiClient().dio;
      final api = IngredientsApi(dio);
      final list = await api.getList();
      if (!mounted) return;
      setState(() {
        _ingredients = list.map(_ingredientItemFromDto).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = messageFromIngredientError(e);
        _loading = false;
      });
    }
  }

  void _openAddSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddIngredientSheet(
        authService: widget.authService,
        onSuccess: _loadIngredients,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ингредиенты'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => SettingsPage(authService: widget.authService),
                ),
              );
            },
            tooltip: 'Настройки',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSheet,
        tooltip: 'Добавить ингредиент',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  static IngredientItem _ingredientItemFromDto(IngredientResponseDto dto) {
    return IngredientItem(
      id: dto.id,
      name: dto.name,
      type: _parseType(dto.type),
      amount: dto.amount,
      status: _parseStatus(dto.status ?? 'NONE'),
    );
  }

  static IngredientType _parseType(String s) {
    final upper = s.toUpperCase();
    for (final e in IngredientType.values) {
      if (e.name.toUpperCase() == upper) return e;
    }
    return IngredientType.unknown;
  }

  static IngredientStockStatus _parseStatus(String s) {
    final upper = s.toUpperCase();
    for (final e in IngredientStockStatus.values) {
      if (e.name.toUpperCase() == upper) return e;
    }
    return IngredientStockStatus.none;
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: _loadIngredients,
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }
    if (_ingredients.isEmpty) {
      return Center(
        child: Text(
          'Нет ингредиентов',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: _ingredients.length,
      itemBuilder: (context, index) {
        return IngredientCard(item: _ingredients[index]);
      },
    );
  }
}
