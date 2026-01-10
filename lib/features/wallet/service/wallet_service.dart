import '../../../core/network/api_client.dart';
import '../models/balance_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class WalletService {
  Future<BalanceResponse> getBalance() async {
    try {
      final response = await ApiClient.dio.get('/dashboard/balance');
      return BalanceResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Error fetching balance: ${e.message}');
      }
      rethrow;
    }
  }
}
