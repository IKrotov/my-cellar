import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/auth/auth_service.dart';
import 'core/auth/auth_wrapper.dart';
import 'core/l10n/locale_scope.dart';
import 'core/l10n/locale_storage.dart';
import 'generated/l10n/app_localizations.dart';

void main() {
  // Перехват необработанных ошибок — если падение в Dart, увидим в логах.
  FlutterError.onError = (details) {
    debugPrint('FlutterError: ${details.exception}');
    debugPrint(details.stack?.toString() ?? '');
    FlutterError.presentError(details);
  };
  runZonedGuarded(() {
    runApp(const MyCellarApp());
  }, (error, stack) {
    debugPrint('runZonedGuarded: $error');
    debugPrint(stack.toString());
  });
}

class MyCellarApp extends StatefulWidget {
  const MyCellarApp({super.key});

  @override
  State<MyCellarApp> createState() => _MyCellarAppState();
}

class _MyCellarAppState extends State<MyCellarApp> {
  final _authService = AuthService();
  final _localeStorage = LocaleStorage();
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    // Откладываем чтение SharedPreferences до после первого кадра — на iOS
    // снижает риск падения при холодном старте.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedLocale();
    });
  }

  Future<void> _loadSavedLocale() async {
    try {
      final code = await _localeStorage.getLocale();
      if (code == null || !mounted) return;
      setState(() => _locale = Locale(code));
    } catch (e, st) {
      debugPrint('LocaleStorage.getLocale error: $e');
      debugPrint(st.toString());
    }
  }

  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
    _localeStorage.saveLocale(locale.languageCode);
  }

  Locale _resolveLocale() {
    if (_locale != null) return _locale!;
    final platformLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final supported = AppLocalizations.supportedLocales;
    for (final l in supported) {
      if (l.languageCode == platformLocale.languageCode) return l;
    }
    return supported.first;
  }

  @override
  Widget build(BuildContext context) {
    final locale = _resolveLocale();

    return LocaleScope(
      locale: locale,
      setLocale: _setLocale,
      child: MaterialApp(
        title: 'My Cellar',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: AuthWrapper(authService: _authService),
      ),
    );
  }
}
