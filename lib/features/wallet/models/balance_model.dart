class BalanceResponse {
  final bool success;
  final double totalBalance;
  final List<BalanceBreakdown> breakdown;

  BalanceResponse({
    required this.success,
    required this.totalBalance,
    required this.breakdown,
  });

  factory BalanceResponse.fromJson(Map<String, dynamic> json) {
    return BalanceResponse(
      success: json['success'] ?? false,
      totalBalance: (json['totalBalance'] as num?)?.toDouble() ?? 0.0,
      breakdown: (json['breakdown'] as List?)
              ?.map((item) => BalanceBreakdown.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class BalanceBreakdown {
  final String symbol;
  final double balance;
  final double balanceInUSDT;

  BalanceBreakdown({
    required this.symbol,
    required this.balance,
    required this.balanceInUSDT,
  });

  factory BalanceBreakdown.fromJson(Map<String, dynamic> json) {
    return BalanceBreakdown(
      symbol: json['symbol'] ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      balanceInUSDT: (json['balanceInUSDT'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
