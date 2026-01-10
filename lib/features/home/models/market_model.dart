class MarketResponse {
  final List<Coin> hot;
  final List<Coin> gainers;
  final List<Coin> losers;

  MarketResponse({
    required this.hot,
    required this.gainers,
    required this.losers,
  });

  factory MarketResponse.fromJson(Map<String, dynamic> json) {
    return MarketResponse(
      hot: (json['hot'] as List?)?.map((i) => Coin.fromJson(i)).toList() ?? [],
      gainers:
          (json['gainers'] as List?)?.map((i) => Coin.fromJson(i)).toList() ?? [],
      losers:
          (json['losers'] as List?)?.map((i) => Coin.fromJson(i)).toList() ?? [],
    );
  }
}

class Coin {
  final String name;
  final String symbol;
  final double lastPrice;
  final double change24h;
  final String image;

  Coin({
    required this.name,
    required this.symbol,
    required this.lastPrice,
    required this.change24h,
    required this.image,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      lastPrice: (json['last_price'] as num?)?.toDouble() ?? 0.0,
      change24h: (json['change_24h'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
    );
  }
}
