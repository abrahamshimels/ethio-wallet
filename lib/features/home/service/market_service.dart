import '../../../core/network/api_client.dart';
import '../models/market_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MarketService {
  Future<MarketResponse> getMarketData() async {
    try {
      final response = await ApiClient.dio.get('/market');
      return MarketResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Error fetching market data: ${e.message}');
      }
      rethrow;
    }
  }
}
