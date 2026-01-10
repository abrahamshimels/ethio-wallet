import '../service/auth_service.dart';
import 'auth_api.dart';

class AuthRepository {
  final AuthService _authService;
  final AuthApi _authApi;

  AuthRepository(this._authService, this._authApi);

  Future<void> loginAndExchangeToken() async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User not logged in");

    final firebaseToken = await user.getIdToken();

    final response = await _authApi.exchangeToken(firebaseToken);

    final backendToken = response["token"];

    // TODO: store securely
    print("✅ Backend JWT: $backendToken");
  }
}
