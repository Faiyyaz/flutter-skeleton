import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../enums/auth_state.dart';
import '../enums/log_event.dart';
import '../repository/auth_repository.dart';
import '../services/navigation_service.dart';
import '../services/api_service.dart';
import '../services/service_locator.dart' as service_locator;
import '../utilities/custom_logger.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final NavigationService _navigationService =
      service_locator.locator<NavigationService>();
  final APIService _apiService = service_locator.locator<APIService>();

  AuthState? _authState;
  AuthState? _previousAuthState;

  AuthProvider() {
    _previousAuthState = _authState;
    _authState = _authRepository.authState.value;

    _handleAuthState();

    //Add Auth Listener
    _authRepository.authState.addListener(() {
      _previousAuthState = _authState;
      _authState = _authRepository.authState.value;
      _handleAuthState();
    });
  }

  _handleAuthState() {
    if (_authState != _previousAuthState) {
      switch (_authState) {
        case AuthState.authenticated:
          _navigationService.navigateWithoutBuildContext(
            routeName: '/home',
          );
          break;
        case AuthState.unauthenticated:
          _navigationService.navigateWithoutBuildContext(
            routeName: '/login',
          );
          break;
        default:
          CustomLogger.logEvent(
            logType: LogType.error,
            message: 'handleAuthState ${_authState.toString()}',
          );
      }
    }
  }

  cancelAPI({
    required CancelToken? cancelToken,
  }) {
    _apiService.cancelCall(cancelToken);
  }
}
