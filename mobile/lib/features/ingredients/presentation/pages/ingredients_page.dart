import 'package:flutter/material.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../core/database/entities/ingredient_entity.dart';
import '../../../../core/network/dto/ingredient_dto.dart';
import '../../../../core/network/ingredients_api.dart';
import '../../../../core/repository/cellar_repository.dart';
import '../../../../core/repository/ingredient_repository.dart';
import '../../../../core/storage/current_cellar_storage.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../cellars/presentation/widgets/cellars_drawer_content.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../domain/ingredient_item.dart';
import '../widgets/add_ingredient_sheet.dart';
import '../widgets/ingredient_card.dart';

class IngredientsPage extends StatefulWidget {
  const IngredientsPage({
    super.key,
    required this.authService,
    required this.currentCellar,
    required this.onCellarChanged,
  });

  final AuthService authService;
  final CurrentCellar currentCellar;
  final void Function(CurrentCellar cellar) onCellarChanged;

  @override
  State<IngredientsPage> createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  List<IngredientItem> _ingredients = [];
  bool _loading = true;
  String? _error;

  final IngredientRepository _ingredientRepository = IngredientRepository();

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  @override
  void didUpdateWidget(IngredientsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentCellar.id != widget.currentCellar.id) {
      _loadIngredients();
    }
  }

  Future<void> _loadIngredients() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final cellarId = widget.currentCellar.id;
    try {
      final local = await _ingredientRepository.getByCellarId(cellarId);
      final items = local.map((e) => _ingredientItemFromEntity(e)).toList();
      if (!mounted) return;
      setState(() {
        _ingredients = items;
        _loading = false;
      });
      _syncIngredientsFromBackend();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = messageFromIngredientError(e);
        _loading = false;
      });
    }
  }

  Future<void> _syncIngredientsFromBackend() async {
    final cellarId = widget.currentCellar.id;
    try {
      final dio = widget.authService.getApiClient().dio;
      final api = IngredientsApi(dio);
      final list = await api.getList(cellarId);
      await _ingredientRepository.syncFromBackend(list, cellarId);
      if (!mounted) return;
      final local = await _ingredientRepository.getByCellarId(cellarId);
      final items = local.map((e) => _ingredientItemFromEntity(e)).toList();
      if (!mounted) return;
      setState(() => _ingredients = items);
    } catch (_) {
      // Фоновый синк: ошибку не показываем, список уже из локальной БД
    }
  }

  Future<void> _syncNewIngredientInBackground(
    int localId,
    CreateIngredientRequestDto request,
  ) async {
    final cellarId = widget.currentCellar.id;
    try {
      final dio = widget.authService.getApiClient().dio;
      final api = IngredientsApi(dio);
      final created = await api.create(cellarId, request);
      await _ingredientRepository.update(
        localId,
        serverId: created.id,
        syncStatus: 'synced',
        updatedAt: created.updatedAt,
      );
      if (!mounted) return;
      final local = await _ingredientRepository.getByCellarId(cellarId);
      final items = local.map((e) => _ingredientItemFromEntity(e)).toList();
      setState(() => _ingredients = items);
    } catch (_) {
      // Запись остаётся pending
    }
  }

  void _openAddSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddIngredientSheet(
          authService: widget.authService,
          cellarId: widget.currentCellar.id,
          ingredientRepository: _ingredientRepository,
          onAdded: (localId, request) {
            _loadIngredients();
            _syncNewIngredientInBackground(localId, request);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ingredients),
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
            tooltip: l10n.settingsTooltip,
          ),
        ],
      ),
      drawer: Drawer(
        child: CellarsDrawerContent(
          authService: widget.authService,
          cellarRepository: CellarRepository(),
          currentCellar: widget.currentCellar,
          onCellarSelected: widget.onCellarChanged,
        ),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSheet,
        tooltip: l10n.addIngredientTooltip,
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

  static IngredientItem _ingredientItemFromEntity(IngredientEntity entity) {
    return IngredientItem(
      id: entity.serverId,
      name: entity.name,
      type: _parseType(entity.type),
      amount: entity.amount,
      status: _parseStatus(entity.status),
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

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }
    if (_ingredients.isEmpty) {
      return Center(
        child: Text(
          l10n.noIngredients,
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
        return IngredientCard(
          item: _ingredients[index],
          authService: widget.authService,
          cellarId: widget.currentCellar.id,
          onUpdated: _loadIngredients,
        );
      },
    );
  }
}
