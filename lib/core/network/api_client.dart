import 'package:app_common/config_core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'auth_session.dart';
import '../error/failures.dart';

/// Standard Enterprise API Client using Dio.
/// Supports interceptors, custom error handling, and robust logging.
class ApiClient {
  late final Dio _dio;
  final IAuthSession _authSession;

  ApiClient({required String pathUrl, required IAuthSession authSession, List<Interceptor>? additionalInterceptors}) : _authSession = authSession {
    _dio = Dio(
      BaseOptions(
        baseUrl: ConfigCore.apiBaseUrl + pathUrl,
        connectTimeout: Duration(seconds: ConfigCore.requestTimeout),
        receiveTimeout: Duration(seconds: ConfigCore.receiveTimeout),
        headers: {'Accept': 'application/json', 'X-Client-ID': ConfigCore.xClientID},
      ),
    );

    _setupInterceptors(additionalInterceptors);
  }

  void _setupInterceptors(List<Interceptor>? additionalInterceptors) {
    // 1. Auth Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _authSession.accessToken.value;
          final deviceId = _authSession.deviceId.value;

          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (deviceId.isNotEmpty) {
            options.headers['X-Device-ID'] = deviceId;
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Global Error Handling (e.g., 401 Unauthorized)
          if (e.response?.statusCode == 401) {
            await _authSession.clearSession();
            // Optional: Trigger logout event or navigate to login
          }
          return handler.next(e);
        },
      ),
    );

    // 2. Logging Interceptor
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true, responseHeader: false, error: true, compact: true, maxWidth: 90),
      );
    }

    // 3. Custom Interceptors
    if (additionalInterceptors != null) {
      _dio.interceptors.addAll(additionalInterceptors);
    }
  }

  // --- API Methods ---

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    try {
      return await _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    try {
      return await _dio.put<T>(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> delete<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    try {
      return await _dio.delete<T>(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Maps [DioException] to [Failure].
  Failure _handleDioError(DioException e) {
    String message = 'Terjadi kesalahan pada server';

    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        message = data['message'];
      } else if (data is Map && data.containsKey('error')) {
        message = data['error'];
      }

      return ServerFailure(message, e);
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure('Koneksi timeout, silakan coba lagi');
      case DioExceptionType.connectionError:
        return const ServerFailure('Tidak ada koneksi internet');
      case DioExceptionType.cancel:
        return const ServerFailure('Permintaan dibatalkan');
      default:
        return UnknownFailure(e.message ?? 'Kesalahan tidak diketahui', e);
    }
  }

  // Access to raw Dio instance if needed
  Dio get dio => _dio;
}
