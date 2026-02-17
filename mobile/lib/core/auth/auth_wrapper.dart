import 'dart:async';

import 'package:flutter/material.dart';

import '../network/cellars_api.dart';
import '../repository/cellar_repository.dart';
import '../storage/current_cellar_storage.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/cellars/presentation/widgets/create_cellar_dialog.dart';
import '../../features/ingredients/presentation/pages/ingredients_page.dart';
import '../../generated/l10n/app_localizations.dart';
import 'auth_service.dart';
import 'auth_state.dart';

/// Виджет-обертка, который показывает нужный экран в зависимости от состояния аутентификации.
/// После входа проверяет наличие текущего погреба: читает из памяти, при отсутствии запрашивает
/// список с бэкенда и берёт первый; если список пуст — показывает окно создания погреба.
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late StreamSubscription<AuthState> _authSubscription;
  final _cellarStorage = CurrentCellarStorage();

  CurrentCellar? _currentCellar;
  bool _cellarLoading = false;
  bool _showCreateCellarDialog = false;
  bool _cellarCheckStarted = false;
  bool _createDialogShown = false;
  /// Ошибка загрузки списка погребов (таймаут, сеть) — показываем экран с «Повторить» / «Создать погреб».
  String? _cellarError;

  @override
  void initState() {
    super.initState();
    _authSubscription = widget.authService.stateStream.listen((state) async {
      if (state is UnauthenticatedState) {
        await _cellarStorage.clear();
        _currentCellar = null;
        _cellarCheckStarted = false;
        _showCreateCellarDialog = false;
        _createDialogShown = false;
        _cellarError = null;
      }
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        widget.authService.initialize();
      });
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  Future<void> _ensureCurrentCellar() async {
    if (_cellarCheckStarted) return;
    _cellarCheckStarted = true;
    setState(() => _cellarLoading = true);

    try {
      var cellar = await _cellarStorage.read();
      if (cellar != null && mounted) {
        setState(() {
          _currentCellar = cellar;
          _cellarLoading = false;
        });
        return;
      }
      final dio = widget.authService.getApiClient().dio;
      final api = CellarsApi(dio);
      final list = await api.getList();
      if (!mounted) return;
      await CellarRepository().syncFromBackend(list);
      if (!mounted) return;
      if (list.isNotEmpty) {
        final first = list.first;
        cellar = CurrentCellar(id: first.id!, name: first.name);
        await _cellarStorage.save(cellar);
        setState(() {
          _currentCellar = cellar;
          _cellarLoading = false;
        });
      } else {
        setState(() {
          _showCreateCellarDialog = true;
          _cellarLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _cellarLoading = false;
          _cellarError = e.toString();
        });
      }
    }
  }

  void _retryLoadCellars() {
    setState(() {
      _cellarError = null;
      _cellarCheckStarted = false;
    });
    _ensureCurrentCellar();
  }

  void _onCellarCreated(CurrentCellar cellar) {
    setState(() {
      _currentCellar = cellar;
      _showCreateCellarDialog = false;
    });
  }

  void _onCellarChanged(CurrentCellar cellar) async {
    await _cellarStorage.save(cellar);
    setState(() => _currentCellar = cellar);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.authService.currentState;

    if (state is AuthLoadingState) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (state is UnauthenticatedState) {
      return LoginPage(authService: widget.authService);
    }
    // AuthenticatedState
    if (_currentCellar == null && !_cellarLoading && !_showCreateCellarDialog && _cellarError == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _ensureCurrentCellar());
    }
    if (_cellarError != null) {
      return _buildCellarErrorScreen();
    }
    if (_cellarLoading || (_currentCellar == null && !_showCreateCellarDialog)) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_showCreateCellarDialog) {
      if (!_createDialogShown) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _createDialogShown) return;
          _createDialogShown = true;
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => CreateCellarDialog(
              authService: widget.authService,
              cellarRepository: CellarRepository(),
              isFirstCellar: true,
              onCreated: _onCellarCreated,
            ),
          );
        });
      }
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return IngredientsPage(
      authService: widget.authService,
      currentCellar: _currentCellar!,
      onCellarChanged: _onCellarChanged,
    );
  }

  Widget _buildCellarErrorScreen() {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _cellarError!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _retryLoadCellars,
                child: Text(l10n.retry),
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () {
                  setState(() {
                    _cellarError = null;
                    _showCreateCellarDialog = true;
                  });
                },
                child: Text(l10n.newCellar),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
