class DepositCoin {
  final String name;
  final String symbol;
  final List<DepositNetwork> networks;

  const DepositCoin({
    required this.name,
    required this.symbol,
    required this.networks,
  });
}

class DepositNetwork {
  final String name;
  final String address;

  const DepositNetwork({required this.name, required this.address});
}
