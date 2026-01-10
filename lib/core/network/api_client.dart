import 'package:dio/dio.dart';
import 'auth_interceptor.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static String get _baseUrl {
    if (kIsWeb) {
      return "http://localhost:4000/api";
    }
    // Android emulator localhost
    return "http://10.0.2.2:4000/api";
  }

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {"Content-Type": "application/json"},
    ),
  )..interceptors.add(AuthInterceptor());
}
