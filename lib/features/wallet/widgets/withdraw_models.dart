class WithdrawCoin {
  final String name;
  final String symbol;
  final double balance;
  final List<WithdrawNetwork> networks;

  const WithdrawCoin({
    required this.name,
    required this.symbol,
    required this.balance,
    required this.networks,
  });
}

class WithdrawNetwork {
  final String name;
  final double fee;
  final double minAmount;

  const WithdrawNetwork({
    required this.name,
    required this.fee,
    required this.minAmount,
  });
}
