import 'package:flutter/material.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../core/database/entities/cellar_entity.dart';
import '../../../../core/network/cellars_api.dart';
import '../../../../core/network/dto/cellar_dto.dart';
import '../../../../core/repository/cellar_repository.dart';
import '../../../../core/storage/current_cellar_storage.dart';
import '../../../../generated/l10n/app_localizations.dart';
import 'create_cellar_dialog.dart';

/// Содержимое бокового меню: список погребов из локальной БД.
/// Сначала показываем данные из БД, в фоне запрашиваем бэкенд и обновляем БД (только если updated_at с бэка новее).
class CellarsDrawerContent extends StatefulWidget {
  const CellarsDrawerContent({
    super.key,
    required this.authService,
    required this.cellarRepository,
    required this.currentCellar,
    required this.onCellarSelected,
  });

  final AuthService authService;
  final CellarRepository cellarRepository;
  final CurrentCellar currentCellar;
  final void Function(CurrentCellar cellar) onCellarSelected;

  @override
  State<CellarsDrawerContent> createState() => _CellarsDrawerContentState();
}

class _CellarsDrawerContentState extends State<CellarsDrawerContent> {
  List<CellarEntity> _cellars = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCellars();
  }

  /// Сначала грузим из локальной БД и показываем; затем в фоне запрос к бэку и merge (по updated_at).
  Future<void> _loadCellars() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final local = await widget.cellarRepository.getAll();
      if (!mounted) return;
      setState(() {
        _cellars = local;
        _loading = false;
      });
      _syncFromBackend();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  /// Запрос к бэкенду и обновление локальной БД (только если updated_at с бэка новее локального).
  Future<void> _syncFromBackend() async {
    try {
      final dio = widget.authService.getApiClient().dio;
      final api = CellarsApi(dio);
      final list = await api.getList();
      await widget.cellarRepository.syncFromBackend(list);
      if (!mounted) return;
      final updated = await widget.cellarRepository.getAll();
      setState(() => _cellars = updated);
    } catch (_) {
      // Ошибку фонового запроса не показываем — уже отобразили локальные данные.
    }
  }

  void _selectCellar(CurrentCellar cellar) {
    CurrentCellarStorage().save(cellar);
    widget.onCellarSelected(cellar);
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _syncNewCellarInBackground(int localId, String name) async {
    try {
      final dio = widget.authService.getApiClient().dio;
      final api = CellarsApi(dio);
      final created = await api.create(CreateCellarRequestDto(name: name));
      await widget.cellarRepository.update(
        localId,
        serverId: created.id,
        syncStatus: 'synced',
        updatedAt: created.updatedAt,
      );
      if (!mounted) return;
      final updated = await widget.cellarRepository.getAll();
      setState(() => _cellars = updated);
    } catch (_) {
      // Ошибку фоновой синхронизации не показываем; запись остаётся pending
    }
  }

  void _openCreateCellar() {
    showDialog<void>(
      context: context,
      builder: (ctx) => CreateCellarDialog(
        authService: widget.authService,
        cellarRepository: widget.cellarRepository,
        isFirstCellar: false,
        onAddedPending: (localId, name) {
          _loadCellars();
          _syncNewCellarInBackground(localId, name);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                l10n.cellars,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.add),
              title: Text(l10n.newCellar),
              onTap: _openCreateCellar,
            ),
            const Divider(height: 1),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton.icon(
                                onPressed: _loadCellars,
                                icon: const Icon(Icons.refresh),
                                label: Text(l10n.retry),
                              ),
                            ],
                          ),
                        )
                      : _cellars.isEmpty
                          ? Center(
                              child: Text(
                                l10n.noCellars,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: _cellars.length,
                              itemBuilder: (context, index) {
                                final entity = _cellars[index];
                                final serverId = entity.serverId;
                                final isSelected = serverId != null && serverId == widget.currentCellar.id;
                                return ListTile(
                                  leading: Icon(
                                    isSelected ? Icons.check_circle : Icons.kitchen,
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : null,
                                  ),
                                  title: Text(entity.name),
                                  onTap: serverId != null
                                      ? () => _selectCellar(CurrentCellar(id: serverId, name: entity.name))
                                      : null,
                                );
                              },
                            ),
            ),
          ],
        ),
    );
  }
}
