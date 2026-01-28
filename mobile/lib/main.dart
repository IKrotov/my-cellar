import 'package:flutter/material.dart';
import 'core/auth/auth_service.dart';
import 'core/auth/auth_wrapper.dart';

void main() {
  runApp(const MyCellarApp());
}

class MyCellarApp extends StatelessWidget {
  const MyCellarApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Создаем единственный экземпляр AuthService для всего приложения
    final authService = AuthService();

    return MaterialApp(
      title: 'My Cellar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthWrapper(authService: authService),
    );
  }
}
