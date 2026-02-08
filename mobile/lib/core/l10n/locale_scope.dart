import 'package:flutter/material.dart';

/// Провайдер выбранной локали для всего приложения.
class LocaleScope extends InheritedWidget {
  const LocaleScope({
    super.key,
    required this.locale,
    required this.setLocale,
    required super.child,
  });

  final Locale locale;
  final void Function(Locale) setLocale;

  static LocaleScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'LocaleScope not found');
    return scope!;
  }

  @override
  bool updateShouldNotify(LocaleScope oldWidget) =>
      oldWidget.locale != locale;
}
