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
    
    // Подписываемся на изменения состояния
    _authSubscription = widget.authService.stateStream.listen((state) {
      setState(() {}); // Обновляем UI при изменении состояния
    });
    
    // Инициализируем проверку токена
    widget.authService.initialize();
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
      AuthenticatedState() => const IngredientsPage(),
    };
  }
}
