import '../controller/image_picker_provider.dart';

import '../controller/theme_mode_provider.dart';
import 'dialog_service.dart';
import 'image_picker_service.dart';

import '../controller/auth_provider.dart';

import 'navigation_service.dart';

import 'api_service.dart';

import 'permission_service.dart';
import 'package:get_it/get_it.dart';
import 'local_storage_service.dart';

GetIt locator = GetIt.instance;

/// Here we are setting up the services like navigation, api, etc
/// This method will be called once during app startup
void setupLocator(String baseUrl) {
  locator.registerLazySingleton(
    () => LocalStorageService(),
  );
  locator.registerLazySingleton(
    () => APIService(baseUrl: baseUrl),
  );
  locator.registerLazySingleton(
    () => NavigationService(),
  );
  locator.registerLazySingleton(
    () => DialogService(),
  );
  locator.registerLazySingleton(
    () => ImagePickerService(),
  );
  locator.registerLazySingleton(
    () => PermissionService(),
  );

  locator.registerLazySingleton(
    () => AuthProvider(),
  );
  locator.registerLazySingleton(
    () => ThemeModeProvider(),
  );
  locator.registerLazySingleton(
    () => ImagePickerProvider(),
  );
}
