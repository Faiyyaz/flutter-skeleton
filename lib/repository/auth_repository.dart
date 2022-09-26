import 'package:flutter/widgets.dart';

import '../enums/auth_state.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../services/service_locator.dart' as service_locator;

class AuthRepository {
  final ValueNotifier<AuthState> _authState =
      ValueNotifier(AuthState.uninitialized);
  final APIService _apiService = service_locator.locator<APIService>();
  final LocalStorageService _localStorageService =
      service_locator.locator<LocalStorageService>();

  ValueNotifier<AuthState> get authState => _authState;

  AuthRepository() {
    Future.delayed(const Duration(seconds: 3), () async {
      Stream<String?> tokenStream = _localStorageService.getTokenStream();
      tokenStream.listen((token) {
        if (token != null) {
          authState.value = AuthState.authenticated;
        } else {
          authState.value = AuthState.unauthenticated;
        }
      });
    });
  }
}
