import 'package:flutter/material.dart';

import '../services/local_storage_service.dart';
import '../services/service_locator.dart' as service_locator;
import '../utilities/constants.dart';

class ThemeModeRepository {
  final LocalStorageService _localStorageService =
      service_locator.locator<LocalStorageService>();
  final String _themeDark = "THEME_DARK";
  final String _themeLight = "THEME_LIGHT";

  final ValueNotifier<ThemeMode?> currentTheme = ValueNotifier(null);

  ThemeModeRepository() {
    _getTheme();
  }

  _getTheme() async {
    String? theme = await _localStorageService.getValue(
      key: kThemeMode,
    );
    if (theme == null) {
      currentTheme.value = ThemeMode.system;
    } else {
      if (theme == _themeDark) {
        currentTheme.value = ThemeMode.dark;
      } else {
        currentTheme.value = ThemeMode.light;
      }
    }
  }

  Future<void> setThemeMode({
    required ThemeMode? theme,
  }) async {
    if (theme == ThemeMode.light) {
      await _localStorageService.setValue(
        key: kThemeMode,
        value: _themeLight,
      );
    } else if (theme == ThemeMode.dark) {
      await _localStorageService.setValue(
        key: kThemeMode,
        value: _themeDark,
      );
    }
    currentTheme.value = theme;
  }
}
