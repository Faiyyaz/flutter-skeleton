import 'package:flash/flash.dart';
import '../components/button/custom_text_button.dart';
import '../components/text/custom_text.dart';
import '../enums/log_event.dart';
import '../utilities/ui_constants.dart';
import 'package:flutter/material.dart';

import '../enums/snack_bar_type.dart';
import '../utilities/custom_logger.dart';

class DialogService {
  /// This method is used to show snackbar
  /// Here we are using 5 parameters
  /// context -> Context of calling page
  /// snackbarType -> To decide color
  /// message -> Text to be shown at snackbar
  /// actionLabel -> actionLabel if any
  /// onActionClick -> Callback on action click if required
  Future<void> showSnackBar(
    BuildContext context,
    SnackBarType snackBarType,
    String message, {
    String? actionLabel,
    Function? onActionClick,
  }) async {
    try {
      /// The below line check if the context passed is of current screen
      if (ModalRoute.of(context)!.isCurrent) {
        await showFlash(
          context: context,
          duration: const Duration(seconds: 3),
          builder: (context, controller) {
            return Flash(
              backgroundColor: snackBarType == SnackBarType.success
                  ? kGreenColor
                  : kRedColor,
              controller: controller,
              behavior: FlashBehavior.fixed,
              position: FlashPosition.bottom,
              child: FlashBar(
                content: CustomText(
                  text: message,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
                primaryAction: Visibility(
                  visible: onActionClick != null,
                  child: CustomTextButton(
                    onPressed: () {
                      controller.dismiss();
                    },
                    title: actionLabel ?? 'OK',
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ).whenComplete(() {
          if (onActionClick != null) {
            onActionClick();
          }
        });
      }
    } catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: e,
      );
    }
  }

  /// This method is used to show dialog
  /// Here we are using 4 parameters
  /// context -> Context of calling page
  /// title -> Title of dialog
  /// message -> Message of dialog
  /// onPositiveButtonClick -> Callback on Positive button click
  Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    String positiveButton = 'Ok',
    String negativeButton = 'Cancel',
    bool isSingleButton = false,
    required VoidCallback onPositiveButtonClick,
    VoidCallback? onNegativeButtonClick,
  }) async {
    try {
      /// The below line check if the context passed is of current screen
      if (ModalRoute.of(context)!.isCurrent) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: CustomText(
                text: title,
                fontWeight: FontWeight.bold,
              ),
              content: CustomText(
                text: message,
              ),
              actions: isSingleButton
                  ? [
                      CustomTextButton(
                        title: positiveButton,
                        onPressed: () {
                          Navigator.pop(context);
                          onPositiveButtonClick();
                        },
                      ),
                    ]
                  : [
                      CustomTextButton(
                        title: positiveButton,
                        onPressed: () {
                          Navigator.pop(context);
                          onPositiveButtonClick();
                        },
                      ),
                      CustomTextButton(
                        title: negativeButton,
                        onPressed: () {
                          Navigator.pop(context);
                          if (onNegativeButtonClick != null) {
                            onNegativeButtonClick();
                          }
                        },
                      ),
                    ],
            );
          },
        );
      }
    } catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: e,
      );
    }
  }
}
