import '../../enums/log_event.dart';
import 'package:flutter/material.dart';

import '../utilities/custom_logger.dart';

/// This class is used to perform page navigation
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  /// This method removes the current page and replaces with the page pushed in the navigation stack
  Future<void>? pushReplacement({
    required BuildContext context,
    required Widget widget,
    bool isFullScreenDialog = false,
  }) {
    try {
      /// The below line check if the context passed is of current screen
      if (ModalRoute.of(context)!.isCurrent) {
        return navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(
            builder: (_) => widget,
            fullscreenDialog: isFullScreenDialog,
          ),
        );
      } else {
        CustomLogger.logEvent(
          logType: LogType.info,
          message: 'The context is not for current route check your code',
        );
        return null;
      }
    } catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: e,
      );
      return null;
    }
  }

  /// This method adds the page to the current navigation stack
  Future<void>? push({
    required BuildContext context,
    required Widget widget,
    bool isFullScreenDialog = false,
  }) {
    try {
      /// The below line check if the context passed is of current screen
      if (ModalRoute.of(context)!.isCurrent) {
        return navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (_) => widget,
            fullscreenDialog: isFullScreenDialog,
          ),
        );
      } else {
        CustomLogger.logEvent(
          logType: LogType.info,
          message: 'The context is not for current route check your code',
        );
        return null;
      }
    } catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: e,
      );
      return null;
    }
  }

  /// This method adds the page after clearing the navigation stack
  Future<void>? pushAndClearStack({
    required BuildContext context,
    required Widget widget,
  }) {
    try {
      /// The below line check if the context passed is of current screen
      if (ModalRoute.of(context)!.isCurrent) {
        return navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (ctx) => widget,
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        CustomLogger.logEvent(
          logType: LogType.info,
          message: 'The context is not for current route check your code',
        );
        return null;
      }
    } catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: e,
      );
      return null;
    }
  }

  /// This method adds the page (using its name) to the current navigation stack
  Future<void>? pushNamed({
    required BuildContext context,
    required String routeName,
    dynamic arguments,
  }) {
    try {
      /// The below line check if the context passed is of current screen
      if (ModalRoute.of(context)!.isCurrent) {
        return navigatorKey.currentState!.pushNamed(
          routeName,
          arguments: arguments,
        );
      } else {
        CustomLogger.logEvent(
          logType: LogType.info,
          message: 'The context is not for current route check your code',
        );
        return null;
      }
    } catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: e,
      );
      return null;
    }
  }

  Future<void>? pushReplacementNamed({
    required BuildContext context,
    required String routeName,
    dynamic arguments,
  }) {
    try {
      /// The below line check if the context passed is of current screen
      if (ModalRoute.of(context)!.isCurrent) {
        return navigatorKey.currentState!.pushReplacementNamed(
          routeName,
          arguments: arguments,
        );
      } else {
        CustomLogger.logEvent(
          logType: LogType.info,
          message: 'The context is not for current route check your code',
        );
        return null;
      }
    } catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: e,
      );
      return null;
    }
  }

  /// This method adds the page (using its name) after clearing the navigation stack
  Future<void>? pushNamedAndClearStack({
    required BuildContext context,
    required String routeName,
    dynamic arguments,
  }) {
    try {
      /// The below line check if the context passed is of current screen
      if (ModalRoute.of(context)!.isCurrent) {
        return navigatorKey.currentState!.pushNamedAndRemoveUntil(
          routeName,
          (Route<dynamic> route) => false,
          arguments: arguments,
        );
      } else {
        CustomLogger.logEvent(
          logType: LogType.info,
          message: 'The context is not for current route check your code',
        );
        return null;
      }
    } catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: e,
      );
      return null;
    }
  }

  /// This method adds the page after popping current page
  Future<void>? popAndPush({
    required BuildContext context,
    required String routeName,
    dynamic arguments,
  }) {
    try {
      /// The below line check if the context passed is of current screen
      if (ModalRoute.of(context)!.isCurrent) {
        return navigatorKey.currentState!.popAndPushNamed(
          routeName,
          arguments: arguments,
        );
      } else {
        CustomLogger.logEvent(
          logType: LogType.info,
          message: 'The context is not for current route check your code',
        );
        return null;
      }
    } catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: e,
      );
      return null;
    }
  }

  /// This method check whether there is any page to go back or not
  bool canGoBack({
    required BuildContext context,
  }) {
    try {
      /// The below line check if the context passed is of current screen
      if (ModalRoute.of(context)!.isCurrent) {
        return navigatorKey.currentState!.canPop();
      } else {
        CustomLogger.logEvent(
          logType: LogType.info,
          message: 'The context is not for current route check your code',
        );
        return false;
      }
    } catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: e,
      );
      return false;
    }
  }

  /// This method pop the current page and go one page back
  void goBack({
    required BuildContext context,
  }) {
    try {
      /// The below line check if the context passed is of current screen
      if (ModalRoute.of(context)!.isCurrent) {
        if (navigatorKey.currentState!.canPop()) {
          navigatorKey.currentState!.pop();
        }
      } else {
        CustomLogger.logEvent(
          logType: LogType.info,
          message: 'The context is not for current route check your code',
        );
      }
    } catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: e,
      );
    }
  }

  /// This method pop the current page with some data
  void goBackWithData({
    required BuildContext context,
    required dynamic data,
  }) {
    try {
      /// The below line check if the context passed is of current screen
      if (ModalRoute.of(context)!.isCurrent) {
        if (navigatorKey.currentState!.canPop()) {
          navigatorKey.currentState!.pop(data);
        }
      } else {
        CustomLogger.logEvent(
          logType: LogType.info,
          message: 'The context is not for current route check your code',
        );
      }
    } catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: e,
      );
    }
  }

  /// This method adds the page (using its name) after clearing the navigation stack
  Future<void>? navigateWithoutBuildContext({
    required String routeName,
    dynamic arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  /// This method adds the page (using its name) after clearing the navigation stack
  Future<void>? popAndPushNamed({
    required BuildContext context,
    required String routeName,
    dynamic arguments,
  }) {
    try {
      /// The below line check if the context passed is of current screen
      if (ModalRoute.of(context)!.isCurrent) {
        return navigatorKey.currentState!.popAndPushNamed(
          routeName,
          arguments: arguments,
        );
      } else {
        CustomLogger.logEvent(
          logType: LogType.info,
          message: 'The context is not for current route check your code',
        );
        return null;
      }
    } catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: e,
      );
      return null;
    }
  }
}
