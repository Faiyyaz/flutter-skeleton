import 'package:flutter/material.dart';

import '../repository/theme_mode_repository.dart';

class ThemeModeProvider with ChangeNotifier {
  final ThemeModeRepository _themeModeRepository = ThemeModeRepository();

  ThemeMode? _currentThemeMode;

  ThemeMode? get currentThemeMode => _currentThemeMode;

  ThemeModeProvider() {
    _currentThemeMode = _themeModeRepository.currentTheme.value;

    //Add Auth Listener
    _themeModeRepository.currentTheme.addListener(() {
      _currentThemeMode = _themeModeRepository.currentTheme.value;
      notifyListeners();
    });

    notifyListeners();
  }

  Future<void> setThemeMode({
    required ThemeMode? theme,
  }) async {
    _themeModeRepository.setThemeMode(
      theme: theme,
    );
  }
}
