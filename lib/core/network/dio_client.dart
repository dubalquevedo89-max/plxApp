import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../storage/session_storage.dart';

part 'dio_client.g.dart';

@riverpod
Dio dioClient(Ref ref) {
  final baseUrl = kDebugMode
      ? (dotenv.env['API_BASE_URL_DEV'] ?? dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000')
      : (dotenv.env['API_BASE_URL'] ?? 'https://plxmap.com');

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
          final skipVp = options.extra['no_vp_scope'] == true;
          if (!skipVp &&
              profile.virtualProjectSlug != null &&
              options.headers['x-virtual-project-slug'] == null) {
            options.headers['x-virtual-project-slug'] =
                profile.virtualProjectSlug;
          }
        } else {
          options.headers['Host'] = key;
        }
      }

      // Stamp which profile key was used so the error handler refreshes
      // the correct profile even if activeHost changes between request and 401.
      options.extra.putIfAbsent('profileKey', () => key);
    }

    final sandbox = dotenv.env['SANDBOX_SLUG'] ?? '';
    if (sandbox.isNotEmpty && options.extra['no_sandbox_scope'] != true) {
      options.headers['x-sandbox-slug'] = sandbox;
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    // Don't retry if this request was already a retry — prevents infinite loops
    if (err.requestOptions.extra['retried'] == true) {
      handler.next(err);
      return;
    }

    // Use the profile key stamped at request time, not the current activeHost.
    // This prevents using the wrong profile's refresh token when multiple
    // profiles are active and activeHost has changed since the request was made.
    final key = err.requestOptions.extra['profileKey'] as String?
        ?? SessionStorage.activeHost;
    if (key == null) {
      handler.next(err);
      return;
    }

    // If a refresh is already running, wait for it then retry
    if (_refreshCompleter != null) {
      try {
        await _refreshCompleter!.future;
        final retried = await _retry(err.requestOptions, key);
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

      final retried = await _retry(err.requestOptions, key);
      handler.resolve(retried);
    } catch (e) {
      _refreshCompleter?.completeError(e);
      _refreshCompleter = null;
      await SessionStorage.clearProfile(key);
      handler.next(err);
    }
  }

  Future<Response> _retry(RequestOptions req, String profileKey) async {
    // Inject the fresh token for the correct profile directly — don't rely on
    // onRequest re-reading activeHost, which may point to a different profile.
    final freshJwt = await SessionStorage.getJwt(profileKey);
    final headers = Map<String, dynamic>.from(req.headers)
      ..remove('Authorization')
      ..remove('authorization');
    if (freshJwt != null) {
      headers['Authorization'] = 'Bearer $freshJwt';
    }
    return _dio.request(
      req.path,
      data: req.data,
      queryParameters: req.queryParameters,
      options: Options(
        method: req.method,
        headers: headers,
        contentType: req.contentType,
        responseType: req.responseType,
        extra: {...req.extra, 'retried': true},
      ),
    );
  }
}
