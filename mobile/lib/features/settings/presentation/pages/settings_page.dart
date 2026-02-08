import 'package:flutter/material.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../core/auth/auth_state.dart';
import '../../../../core/l10n/locale_scope.dart';
import '../../../../generated/l10n/app_localizations.dart';

/// Язык приложения.
enum AppLanguage {
  ru('Русский', 'ru'),
  en('English', 'en'),
  es('Español', 'es'),
  de('Deutsch', 'de');

  const AppLanguage(this.label, this.languageCode);
  final String label;
  final String languageCode;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final localeScope = LocaleScope.of(context);
    final currentLanguageCode = localeScope.locale.languageCode;
    final state = widget.authService.currentState;
    final username = state is AuthenticatedState ? state.username : '—';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _sectionTitle(theme, l10n.user),
          const SizedBox(height: 8),
          Text(
            username,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 32),
          _sectionTitle(theme, l10n.theme),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _darkTheme,
            onChanged: (value) {
              setState(() => _darkTheme = value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.themeSwitchNotConnected)),
              );
            },
            title: Text(_darkTheme ? l10n.themeDark : l10n.themeLight),
            subtitle: Text(l10n.themeSubtitle),
          ),
          const SizedBox(height: 24),
          _sectionTitle(theme, l10n.language),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppLanguage.values.map((lang) {
              final isSelected = currentLanguageCode == lang.languageCode;
              return FilterChip(
                label: Text(lang.label),
                selected: isSelected,
                onSelected: (_) {
                  localeScope.setLocale(Locale(lang.languageCode));
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
            child: Text(l10n.logout),
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
