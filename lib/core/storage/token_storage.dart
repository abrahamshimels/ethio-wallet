import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'auth_token';

  /// Save backend JWT token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// Retrieve backend JWT token
  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  /// Delete token (sign out)
  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }
}
