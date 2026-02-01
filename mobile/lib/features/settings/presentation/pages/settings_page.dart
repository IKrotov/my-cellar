import 'package:flutter/material.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../core/auth/auth_state.dart';

/// Язык приложения (пока заглушка).
enum AppLanguage {
  ru('Русский'),
  en('English'),
  es('Español'),
  de('Deutsch');

  const AppLanguage(this.label);
  final String label;
}

/// Страница настроек: пользователь, тема, язык, выход.
class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /// Тёмная тема (пока только локальное состояние, не применяется).
  bool _darkTheme = false;

  /// Выбранный язык (пока только локальное состояние, не применяется).
  AppLanguage _language = AppLanguage.ru;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = widget.authService.currentState;
    final username = state is AuthenticatedState ? state.username : '—';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _sectionTitle(theme, 'Пользователь'),
          const SizedBox(height: 8),
          Text(
            username,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 32),
          _sectionTitle(theme, 'Тема'),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _darkTheme,
            onChanged: (value) {
              setState(() => _darkTheme = value);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Переключение темы пока не подключено')),
              );
            },
            title: Text(_darkTheme ? 'Тёмная' : 'Светлая'),
            subtitle: const Text('Светлая / тёмная тема'),
          ),
          const SizedBox(height: 24),
          _sectionTitle(theme, 'Язык'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppLanguage.values.map((lang) {
              final isSelected = _language == lang;
              return FilterChip(
                label: Text(lang.label),
                selected: isSelected,
                onSelected: (_) {
                  setState(() => _language = lang);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Смена языка пока не подключена')),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          FilledButton.tonal(
            onPressed: () async {
              if (!context.mounted) return;
              Navigator.of(context).pop();
              await widget.authService.logout();
            },
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(ThemeData theme, String text) {
    return Text(
      text,
      style: theme.textTheme.titleSmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
