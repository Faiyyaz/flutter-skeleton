import 'package:encrypt/encrypt.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../enums/log_event.dart';
import '../utilities/constants.dart';
import '../utilities/custom_logger.dart';

const kTokenKey = 'token';

//TODO : Get encyrption key from backend or implement rsa or remove encrypt if not required
const kSecretKey = 'LT+4RyNBMDKKq50TY8OvbZE55eiyLuO7';

class LocalStorageService {
  final RxSharedPreferences _rxSharedPreferences = RxSharedPreferences(
    SharedPreferences.getInstance(),
  );

  Encrypter getEncryptor() {
    Key key = Key.fromUtf8(kSecretKey);
    Encrypter encrypter = Encrypter(
      AES(key),
    );
    return encrypter;
  }

  Encrypted encrypt(dynamic value) {
    Encrypter encrypter = getEncryptor();
    IV iv = IV.fromLength(16);
    return encrypter.encrypt(value, iv: iv);
  }

  String decrypt(String value) {
    Encrypter encrypter = getEncryptor();
    IV iv = IV.fromLength(16);
    final Encrypted encrypted = Encrypted.fromBase64(value);
    return encrypter.decrypt(encrypted, iv: iv);
  }

  Future<dynamic> getValue({
    required String key,
  }) async {
    /// String preference
    String? stringPreference = await _rxSharedPreferences.getString(
      key,
    );

    if (stringPreference != null) {
      return decrypt(stringPreference);
    } else {
      return null;
    }
  }

  Future<bool> setValue({
    required String key,
    required dynamic value,
  }) async {
    try {
      await _rxSharedPreferences.setString(
        key,
        encrypt(value).base64,
      );
      return true;
    } on Exception catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: 'Local Storage Clear Value:\t ${e.toString()}',
      );
      return false;
    }
  }

  Stream<String?> getTokenStream() {
    return _rxSharedPreferences.getStringStream(
      kTokenKey,
    );
  }

  Future<bool> clear() async {
    try {
      await _rxSharedPreferences.clear();
      Set<String> keys = await _rxSharedPreferences.getKeys();
      if (keys.isNotEmpty) {
        for (var key in keys) {
          if (key != kThemeMode) {
            await _rxSharedPreferences.remove(key);
          }
        }
      } else {
        await _rxSharedPreferences.clear();
      }

      return true;
    } on Exception catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: 'Local Storage Clear Value:\t ${e.toString()}',
      );
      return false;
    }
  }
}
