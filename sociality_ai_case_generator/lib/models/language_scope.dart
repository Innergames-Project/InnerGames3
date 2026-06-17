import 'package:flutter/material.dart';

import 'app_language.dart';

class LanguageScope extends InheritedNotifier<ValueNotifier<AppLanguage>> {
  const LanguageScope({
    super.key,
    required super.notifier,
    required super.child,
  });

  /// Use inside build() — registers a rebuild dependency.
  static AppLanguage of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<LanguageScope>()!
        .notifier!
        .value;
  }

  /// Use outside build() (callbacks, async methods) — no dependency registered.
  static AppLanguage read(BuildContext context) {
    return context
            .getInheritedWidgetOfExactType<LanguageScope>()
            ?.notifier
            ?.value ??
        AppLanguage.dutch;
  }

  static ValueNotifier<AppLanguage> notifierOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<LanguageScope>()!.notifier!;
  }
}
