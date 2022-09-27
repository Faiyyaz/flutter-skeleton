import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../enums/http_method.dart';
import '../enums/log_event.dart';
import '../models/error_response.dart';
import '../utilities/api_constants.dart';
import '../utilities/custom_logger.dart';
import 'local_storage_service.dart';
import 'service_locator.dart' as service_locator;

class APIService {
  final LocalStorageService _localStorageService =
      service_locator.locator<LocalStorageService>();
  final String baseUrl;

  APIService({
    required this.baseUrl,
  });

  Future<Map<String, dynamic>> callAPI({
    required CancelToken? cancelToken,
    required HttpMethod httpMethod,
    required String url,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    ///Configuring Base Options
    BaseOptions baseOptions = BaseOptions(
      connectTimeout: 3000,
      sendTimeout: 3000,
      receiveTimeout: 3000,
      baseUrl: kBaseUrl,
      contentType: Headers.jsonContentType,
    );

    if (headers != null && headers.isNotEmpty) {
      baseOptions.headers.addAll(headers);
    }

    Dio dio = Dio(
      baseOptions,
    );

    ///Adding Logger
    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        responseBody: true,
      ),
    );

    ///Adding Interceptor to handle refresh token
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await _localStorageService.getValue(
            key: kTokenKey,
          );

          ///Adding Auth token in headers
          if (token != null) {
            options.headers.addAll({'Authorization': 'Bearer $token'});
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            RequestOptions options = error.response!.requestOptions;
            String url = options.uri.toString();
            if (url.contains('refresh')) {
              return handler.next(error);
            } else {
              String? refreshToken = await _localStorageService.getValue(
                key: kRefreshToken,
              );

              if (refreshToken != null) {
                dio.post(
                  kRefreshTokenAPI,
                  data: {
                    refreshToken: refreshToken,
                  },
                ).then((response) async {
                  // TODO : Update token here
                  Map<String, dynamic> data = response.data;
                  String accessToken = data['accessToken'];
                  String refreshToken = data['refreshToken'];
                  await _localStorageService.setValue(
                    key: kRefreshToken,
                    value: refreshToken,
                  );
                  await _localStorageService.setValue(
                    key: kTokenKey,
                    value: accessToken,
                  );
                }).then((e) {
                  // Repeating last api here
                  dio.fetch(options).then(
                    (r) => handler.resolve(r),
                    onError: (e) {
                      handler.reject(e);
                    },
                  );
                });
              } else {
                await _localStorageService.clear();
                return handler.next(error);
              }
            }
          }
          return handler.next(error);
        },
      ),
    );

    ///Adding Retry
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: print, // specify log function (optional)
        retries: 3, // retry count (optional)
        retryDelays: const [
          // set delays between retries (optional)
          Duration(seconds: 1), // wait 1 sec before first retry
          Duration(seconds: 2), // wait 2 sec before second retry
          Duration(seconds: 3), // wait 3 sec before third retry
        ],
      ),
    );

    switch (httpMethod) {
      case HttpMethod.get:
        try {
          Response response = await dio.get(
            url,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
          );
          return {
            'success': true,
            'data': response.data,
          };
        } on DioError catch (e) {
          return await handleDioError(e);
        } on Error catch (_) {
          return {
            'success': false,
            'statusCode': 900,
            'message': kGeneralError,
          };
        }
      case HttpMethod.post:
        try {
          Response response = await dio.post(
            url,
            data: body,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
          );
          return {
            'success': true,
            'data': response.data,
          };
        } on DioError catch (e) {
          return await handleDioError(e);
        } on Error catch (_) {
          return {
            'success': false,
            'statusCode': 900,
            'message': kGeneralError,
          };
        }
      case HttpMethod.put:
        try {
          Response response = await dio.put(
            url,
            data: body,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
          );
          return {
            'success': true,
            'data': response.data,
          };
        } on DioError catch (e) {
          return await handleDioError(e);
        } on Error catch (_) {
          return {
            'success': false,
            'statusCode': 900,
            'message': kGeneralError,
          };
        }
      case HttpMethod.delete:
        try {
          Response response = await dio.delete(
            url,
            data: body,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
          );
          return {
            'success': true,
            'data': response.data,
          };
        } on DioError catch (e) {
          return await handleDioError(e);
        } on Error catch (_) {
          return {
            'success': false,
            'statusCode': 900,
            'message': kGeneralError,
          };
        }
      default:
        return {};
    }
  }

  void cancelCall(CancelToken? cancelToken) {
    try {
      cancelToken?.cancel();
    } catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: 'cancelCall ${e.toString()}',
      );
    }
  }

  Future<Map<String, dynamic>> handleDioError(
    DioError e,
  ) async {
    switch (e.type) {
      case DioErrorType.connectTimeout:
        return {
          'success': false,
          'statusCode': 900,
          'message': kInternetError,
        };
      case DioErrorType.sendTimeout:
        return {
          'success': false,
          'statusCode': 900,
          'message': kInternetError,
        };
      case DioErrorType.receiveTimeout:
        return {
          'success': false,
          'statusCode': 900,
          'message': kGeneralError,
        };
      case DioErrorType.response:
        var statusCode = e.response!.statusCode;
        var errorResponse = ErrorResponse.fromJson(
          e.response!.data,
        );
        if (statusCode == 403 || statusCode == 401) {
          return {
            'success': false,
            'statusCode': statusCode,
            'message': errorResponse.message,
          };
        } else {
          return {
            'success': false,
            'statusCode': statusCode,
            'message': errorResponse.message,
            'error': errorResponse.error,
          };
        }
      case DioErrorType.cancel:
        return {
          'success': false,
          'statusCode': 900,
          'message': null,
        };
      case DioErrorType.other:
        return {
          'success': false,
          'statusCode': 900,
          'message': null,
        };
    }
  }

  cancelAPI({
    required CancelToken cancelToken,
  }) {
    try {
      cancelToken.cancel();
    } catch (e) {
      CustomLogger.logEvent(
        logType: LogType.error,
        message: e.toString(),
      );
    }
  }
}
