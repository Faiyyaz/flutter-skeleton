import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../enums/log_event.dart';

class CustomLogger {
  static void logEvent({
    required LogType logType,
    required dynamic message,
  }) {
    if (kDebugMode) {
      Logger logger = Logger();
      switch (logType) {
        case LogType.verbose:
          logger.v(message);
          break;
        case LogType.debug:
          logger.d(message);
          break;
        case LogType.info:
          logger.i(message);
          break;
        case LogType.warning:
          logger.w(message);
          break;
        case LogType.error:
          logger.e(message);
          break;
        case LogType.wtf:
          logger.wtf(message);
          break;
        default:
          print("Invalid LogType");
          break;
      }
    }
  }
}
