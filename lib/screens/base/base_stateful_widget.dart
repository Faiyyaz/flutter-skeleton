import '../../enums/snack_bar_type.dart';
import '../../services/dialog_service.dart';
import '/services/local_storage_service.dart';

import '../../components/loader/custom_loader.dart';
import '/services/navigation_service.dart';
import 'package:flutter/material.dart';

import '../../enums/log_event.dart';
import '../../enums/navigation_type.dart';
import '../../services/service_locator.dart' as service_locator;
import '../../utilities/custom_logger.dart';

/// This is custom stateful widget class which will be extended by all stateful widget
abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({Key? key}) : super(key: key);
}

/// This is custom stateful widget state class for which we will create mixin.
/// If you don't know what mixin is please visit the below mentioned blog, it has a good explanation
/// https://medium.com/flutter-community/https-medium-com-shubhamhackzz-dart-for-flutter-mixins-in-dart-f8bb10a3d341#:~:text=%E2%80%9CIn%20object%2Doriented%20programming%20languages,from%20without%20extending%20the%20class.
abstract class BaseState<Page extends BaseStatefulWidget> extends State<Page> {
  final NavigationService _navigationService =
      service_locator.locator<NavigationService>();
  final LocalStorageService localStorageService =
      service_locator.locator<LocalStorageService>();
  final DialogService dialogService = service_locator.locator<DialogService>();
}

mixin BasicPage<Page extends BaseStatefulWidget> on BaseState<Page> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return onBackPress();
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: CustomLoaderWidget(
          showLoader: shouldShowLoader(),
          child: getBody(
            context,
          ),
        ),
      ),
    );
  }

  /// This method will be used to create the body of the page
  /// It has one properties
  /// context -> current context
  Widget getBody(BuildContext context);

  /// This method will decide whether we want to enable or disable back using the hardware key on android
  bool onBackPress();

  /// This method will decide whether to show loader or not
  bool shouldShowLoader();

  /// Use this method to setState since we call API in async function & if we clear stack & do setState().
  /// This method just check if the widget is visible or not
  void checkedMountedAndSetState(VoidCallback state) {
    if (mounted) {
      setState(state);
    }
  }

  /// Use this method to show snackbar using dialogService
  void showSnackBar({
    required BuildContext context,
    SnackBarType snackBarType = SnackBarType.error,
    required String message,
    Function? onActionClick,
  }) {
    dialogService.showSnackBar(
      context,
      snackBarType,
      message,
      onActionClick: onActionClick,
    );
  }

  Future<void>? navigate({
    required BuildContext context,
    required NavigationType navigationType,
    String? routeName,
    bool isFullScreenDialog = false,
    dynamic arguments,
  }) {
    try {
      /// The below line check if the context passed is of current screen
      if (ModalRoute.of(context)!.isCurrent) {
        NavigationType goBackType = NavigationType.goBack;
        NavigationType goBackWithDataType = NavigationType.goBackWithData;

        if (navigationType != goBackType &&
            navigationType != goBackWithDataType) {
          switch (navigationType) {
            case NavigationType.pushReplacement:
              return _navigationService.pushReplacementNamed(
                context: context,
                routeName: routeName!,
                arguments: arguments,
              );

            case NavigationType.push:
              return _navigationService.pushNamed(
                context: context,
                routeName: routeName!,
                arguments: arguments,
              );

            case NavigationType.pushClearStack:
              return _navigationService.pushNamedAndClearStack(
                context: context,
                routeName: routeName!,
                arguments: arguments,
              );
            case NavigationType.popAndPush:
              return _navigationService.popAndPushNamed(
                context: context,
                routeName: routeName!,
                arguments: arguments,
              );
            default:
              return null;
          }
        } else {
          switch (navigationType) {
            case NavigationType.goBack:
              _navigationService.goBack(
                context: context,
              );
              return null;
            case NavigationType.goBackWithData:
              _navigationService.goBackWithData(
                context: context,
                data: arguments,
              );
              return null;
            default:
              return null;
          }
        }
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
