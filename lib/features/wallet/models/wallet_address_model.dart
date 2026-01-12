class WalletAddressResponse {
  final String mnemonic;
  final String address;
  final String xpub;
  final String asset;

  WalletAddressResponse({
    required this.mnemonic,
    required this.address,
    required this.xpub,
    required this.asset,
  });

  factory WalletAddressResponse.fromJson(Map<String, dynamic> json) {
    return WalletAddressResponse(
      mnemonic: json['mnemonic'] ?? '',
      address: json['address'] ?? '',
      xpub: json['xpub'] ?? '',
      asset: json['asset'] ?? '',
    );
  }
}
