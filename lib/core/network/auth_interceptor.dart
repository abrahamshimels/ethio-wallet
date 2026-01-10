import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage = TokenStorage();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip token for auth exchange endpoint
    if (options.path.contains('/auth/exchange')) {
      return handler.next(options);
    }

    final token = await _tokenStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // TODO: Handle token expiration (logout or refresh)
      await _tokenStorage.deleteToken();
    }
    return handler.next(err);
  }
}
