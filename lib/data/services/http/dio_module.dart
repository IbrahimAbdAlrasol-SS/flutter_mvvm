import 'dart:convert';

import 'package:app/data/providers/authentication_provider.dart';
import 'package:app/data/providers/settings_provider.dart';
import 'package:app/data/services/clients/_clients.dart';
import 'package:app/data/services/interceptors/authenticator.dart';
import 'package:app/logger/logger.dart';
import 'package:app/utils/constants/api_document.dart';
import 'package:app/utils/snackbar.dart';
import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:flutter/foundation.dart';

part 'dio_module.g.dart';

String _extractErrorMessage(DioException e) {
  final Object errObj = e.error ?? '';
  if (errObj is FormatException) {
    return errObj.toString().replaceRange(0, 54, '').replaceAll('^', '').replaceAll('\n', '');
  }
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    return (data['message'] ?? data['title'] ?? 'حدث خطأ ما').toString();
  }
  if (data is String && data.isNotEmpty) return data;
  return e.message ?? 'حدث خطأ ما';
}

String _successMessageForMethod(String method) {
  switch (method.toLowerCase()) {
    case 'post':
      return 'تمت الإضافة بنجاح';
    case 'put':
    case 'patch':
      return 'تم التعديل بنجاح';
    case 'delete':
      return 'تم الحذف بنجاح';
    default:
      return 'تمت العملية بنجاح';
  }
}

@riverpod
Dio dio(Ref ref) {
  final dio = Dio();
  dio
    ..options.baseUrl = ApiDocument.baseUrl
    ..options.connectTimeout = const Duration(seconds: 30)
    ..options.sendTimeout = const Duration(seconds: 60)
    ..options.contentType = 'application/json; charset=utf-8'
    ..options.headers = {
      'accept': 'text/plain',
      'Content-Type': 'application/json',
    }
    ..interceptors.add(Authenticator(ref.read(authenticationProvider.notifier)))
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final locale = ref.read(settingsProvider).locale?.languageCode ?? 'ar';
          options.headers['Accept-Language'] = locale;
          handler.next(options);
        },
        onResponse: (response, handler) {
          dynamic data = response.data;
          if (response.data is List<dynamic>) {
            data = {
              'data': response.data,
              'message': response.statusMessage,
              'statusCode': response.statusCode,
            };
          } else if (response.data is String) {
            data = {
              'data': {},
              'message': response.data,
              'statusCode': response.statusCode,
            };
          }

          final method = response.requestOptions.method.toLowerCase();
          final status = response.statusCode ?? 0;
          if (status >= 200 && status < 300 && ['post', 'put', 'patch', 'delete'].contains(method)) {
            Utils.showSuccessSnackBar(_successMessageForMethod(method));
          }

          return handler.next(
            Response(
              requestOptions: response.requestOptions,
              data: data,
              headers: response.headers,
              isRedirect: response.isRedirect,
              redirects: response.redirects,
              extra: response.extra,
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
            ),
          );
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            ref.read(authenticationProvider.notifier).logout();
          }

          switch (e.type) {
            case DioExceptionType.badCertificate:
              logger.e('Dio badCertificate');
              Utils.showErrorSnackBar('خطأ في شهادة الأمان');
              break;
            case DioExceptionType.badResponse:
              final message = _extractErrorMessage(e);
              logger.e('Dio badResponse', error: message, stackTrace: StackTrace.current);
              Utils.showErrorSnackBar(message);
              break;
            case DioExceptionType.cancel:
              debugPrint(e.message);
              break;
            case DioExceptionType.connectionError:
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.receiveTimeout:
            case DioExceptionType.sendTimeout:
              logger.e('Dio connection/timeout error', error: e.message, stackTrace: StackTrace.current);
              Utils.showErrorSnackBar('تعذّر الاتصال بالخادم، تحقق من اتصالك بالإنترنت');
              break;
            case DioExceptionType.unknown:
              String message = 'حدث خطأ ما';
              if (e.error is FormatException) {
                message = (e.error as FormatException).toString().replaceRange(0, 54, '').replaceAll('^', '');
              } else {
                final data = e.response?.data;
                if (data is Map<String, dynamic>) {
                  message = (data['message'] ?? message).toString();
                } else if (data is String) {
                  message = json.decode(json.encode(data)) as String? ?? message;
                }
              }
              logger.e('Dio unknown error', error: message, stackTrace: StackTrace.current);
              Utils.showErrorSnackBar(message);
              handler.reject(
                DioException(
                  requestOptions: e.requestOptions,
                  response: Response(
                    requestOptions: e.requestOptions,
                    data: {'data': {}, 'message': message, 'statusCode': 400},
                    statusMessage: e.message,
                  ),
                  error: message,
                  type: DioExceptionType.unknown,
                ),
              );
              return;
          }
          handler.next(e);
        },
      ),
    );

  if (kDebugMode) dio.interceptors.add(AwesomeDioInterceptor());

  return dio;
}

extension DioRefX on Ref {
  Dio get dio => read(dioProvider);
}