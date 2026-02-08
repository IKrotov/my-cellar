import 'dart:async';
import 'package:flutter/material.dart';
import 'auth_state.dart';
import 'auth_service.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/ingredients/presentation/pages/ingredients_page.dart';

/// Виджет-обертка, который показывает нужный экран в зависимости от состояния аутентификации
class AuthWrapper extends StatefulWidget {
  final AuthService authService;

  const AuthWrapper({
    super.key,
    required this.authService,
  });

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();

    _authSubscription = widget.authService.stateStream.listen((state) {
      setState(() {});
    });

    // Сначала отрисовываем первый кадр, затем с задержкой читаем Keychain —
    // на iOS при холодном старте Keychain может быть ещё недоступен.
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

  @override
  Widget build(BuildContext context) {
    final state = widget.authService.currentState;

    return switch (state) {
      AuthLoadingState() => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      UnauthenticatedState() => LoginPage(authService: widget.authService),
      AuthenticatedState() => IngredientsPage(authService: widget.authService),
    };
  }
}
