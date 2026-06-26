import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../storage/session_storage.dart';

part 'dio_client.g.dart';

@riverpod
Dio dioClient(Ref ref) {
  final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://plxmap.com:8000';

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ));

  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    requestHeader: true,
    logPrint: (o) => debugPrint('[DIO] $o'),
  ));

  dio.interceptors.add(_AuthInterceptor(dio));

  return dio;
}

class _AuthInterceptor extends Interceptor {
  final Dio _dio;

  // Tracks an in-progress refresh so concurrent 401s share one refresh call
  static Completer<void>? _refreshCompleter;

  _AuthInterceptor(this._dio);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final key = SessionStorage.activeHost;
    if (key != null) {
      final profile = SessionStorage.activeProfile;
      final jwt = await SessionStorage.getJwt(key);

      if (jwt != null && options.headers['Authorization'] == null) {
        options.headers['Authorization'] = 'Bearer $jwt';
      }
      // Only inject Host/VP if not already set by the datasource
      if (options.headers['Host'] == null) {
        if (profile != null) {
          options.headers['Host'] = profile.host;
          if (profile.virtualProjectSlug != null &&
              options.headers['x-virtual-project-slug'] == null) {
            options.headers['x-virtual-project-slug'] =
                profile.virtualProjectSlug;
          }
        } else {
          options.headers['Host'] = key;
        }
      }
    }

    final sandbox = dotenv.env['SANDBOX_SLUG'] ?? '';
    if (sandbox.isNotEmpty) options.headers['x-sandbox-slug'] = sandbox;

    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final key = SessionStorage.activeHost;
    if (key == null) {
      handler.next(err);
      return;
    }

    // If a refresh is already running, wait for it then retry
    if (_refreshCompleter != null) {
      try {
        await _refreshCompleter!.future;
        final retried = await _retry(err.requestOptions);
        handler.resolve(retried);
      } catch (_) {
        handler.next(err);
      }
      return;
    }

    // This request is the one triggering the refresh
    _refreshCompleter = Completer<void>();

    try {
      final refreshToken = await SessionStorage.getRefreshToken(key);
      if (refreshToken == null) throw Exception('No refresh token');

      final res = await _dio.post(
        '/api/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {'Authorization': null}, // skip auth interceptor
        ),
      );

      final newAccess = res.data['access_token'] as String;
      final newRefresh = res.data['refresh_token'] as String? ?? refreshToken;
      await SessionStorage.saveTokens(key, newAccess, newRefresh);

      _refreshCompleter!.complete();
      _refreshCompleter = null;

      final retried = await _retry(err.requestOptions);
      handler.resolve(retried);
    } catch (e) {
      _refreshCompleter?.completeError(e);
      _refreshCompleter = null;
      await SessionStorage.clearProfile(key);
      handler.next(err);
    }
  }

  Future<Response> _retry(RequestOptions req) {
    return _dio.request(
      req.path,
      data: req.data,
      queryParameters: req.queryParameters,
      options: Options(
        method: req.method,
        headers: req.headers,
        contentType: req.contentType,
        responseType: req.responseType,
      ),
    );
  }
}
