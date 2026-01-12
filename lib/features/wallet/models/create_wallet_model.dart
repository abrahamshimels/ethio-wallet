class CreateWalletResponse {
  final String message;
  final WalletModel? wallet;
  final VirtualAccountModel? virtualAccount;
  final String? error;

  CreateWalletResponse({
    required this.message,
    this.wallet,
    this.virtualAccount,
    this.error,
  });

  factory CreateWalletResponse.fromJson(Map<String, dynamic> json) {
    return CreateWalletResponse(
      message: json['message'] ?? '',
      wallet: json['wallet'] != null ? WalletModel.fromJson(json['wallet']) : null,
      virtualAccount: json['virtualAccount'] != null
          ? VirtualAccountModel.fromJson(json['virtualAccount'])
          : null,
      error: json['error'],
    );
  }
}

class WalletModel {
  final int id;
  final String address;
  final String asset;
  final String balance;

  WalletModel({
    required this.id,
    required this.address,
    required this.asset,
    required this.balance,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] ?? 0,
      address: json['address'] ?? '',
      asset: json['asset'] ?? '',
      balance: json['balance']?.toString() ?? '0',
    );
  }
}

class VirtualAccountModel {
  final int id;
  final String tatumAccountId;
  final String tatumCustomerId;

  VirtualAccountModel({
    required this.id,
    required this.tatumAccountId,
    required this.tatumCustomerId,
  });

  factory VirtualAccountModel.fromJson(Map<String, dynamic> json) {
    return VirtualAccountModel(
      id: json['id'] ?? 0,
      tatumAccountId: json['tatumAccountId'] ?? '',
      tatumCustomerId: json['tatumCustomerId'] ?? '',
    );
  }
}
