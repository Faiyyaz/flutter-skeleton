import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/navigation_service.dart';
import '../services/service_locator.dart' as service_locator;
import '../utilities/api_constants.dart';
import '../utilities/ui_constants.dart';
import 'controller/auth_provider.dart';
import 'controller/theme_mode_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/login_screen.dart';
import 'screens/onboarding/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  service_locator.setupLocator(kBaseUrl);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: kTransparent,
    ),
  );

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  final ThemeModeProvider _themeModeProvider =
      service_locator.locator<ThemeModeProvider>();
  final NavigationService _navigationService =
      service_locator.locator<NavigationService>();

  ///Calling this here to handle the navigation internally
  // ignore: unused_field
  final AuthProvider _authProvider = service_locator.locator<AuthProvider>();

  MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeModeProvider,
      builder: (BuildContext context, Widget? child) {
        if (_themeModeProvider.currentThemeMode != null) {
          return MaterialApp(
            navigatorKey: _navigationService.navigatorKey,
            themeMode: _themeModeProvider.currentThemeMode,
            title: 'Skeleton',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const SplashScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const HomeScreen(),
            },
          );
        } else {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
