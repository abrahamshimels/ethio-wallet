import '../../../core/network/api_client.dart';
import '../models/balance_model.dart';
import '../models/create_wallet_model.dart';
import '../models/wallet_address_model.dart';
import '../models/withdraw_response_model.dart';
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

  Future<CreateWalletResponse> createWallet(String asset) async {
    try {
      final response = await ApiClient.dio.post(
        '/wallet/create',
        data: {'asset': asset},
      );
      return CreateWalletResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        return CreateWalletResponse.fromJson(e.response!.data);
      }
      if (kDebugMode) {
        print('Error creating wallet: ${e.message}');
      }
      rethrow;
    }
  }

  Future<WalletAddressResponse> getWalletAddress(String asset) async {
    try {
      final response = await ApiClient.dio.get(
        '/wallet/wallet/mnemonic',
        queryParameters: {'asset': asset},
      );
      return WalletAddressResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Error fetching wallet address: ${e.message}');
      }
      rethrow;
    }
  }

  Future<WithdrawResponse> withdraw(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.dio.post(
        '/withdraw/',
        data: data,
      );
      return WithdrawResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        return WithdrawResponse.fromJson(e.response!.data);
      }
      if (kDebugMode) {
        print('Error submitting withdrawal: ${e.message}');
      }
      rethrow;
    }
  }
}
