import '../../../core/network/api_client.dart';
import '../models/p2p_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class P2PService {
  Future<List<P2POrder>> getOrders() async {
    try {
      final response = await ApiClient.dio.get('/p2p/orders');
      if (response.data is List) {
        return (response.data as List)
            .map((json) => P2POrder.fromJson(json))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Error fetching P2P orders: ${e.message}');
      }
      rethrow;
    }
  }

  Future<P2POrder> createOrder(CreateP2PRequest request) async {
    try {
      final response = await ApiClient.dio.post(
        '/p2p/create',
        data: request.toJson(),
      );
      return P2POrder.fromJson(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Error creating P2P order: ${e.message}');
      }
      rethrow;
    }
  }

  Future<P2PBuyResponse> buyOrder(int orderId, double amount) async {
    try {
      final response = await ApiClient.dio.post(
        '/p2p/orders/$orderId/buy',
        data: {'cryptoAmountToBuy': amount},
      );
      return P2PBuyResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Error buying P2P order: ${e.message}');
      }
      rethrow;
    }
  }
}
