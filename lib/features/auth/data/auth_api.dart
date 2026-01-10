import '../../../core/network/api_client.dart';

class AuthApi {
  Future<Map<String, dynamic>> exchangeToken(String firebaseToken) async {
    final response = await ApiClient.dio.post(
      "/auth/exchange",
      data: {"firebaseToken": firebaseToken},
    );
    return response.data;
  }
}
