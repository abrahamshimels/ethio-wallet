class P2POrder {
  final int id;
  final int userId;
  final String type;
  final String asset;
  final String cryptoAmount;
  final String birrAmount;
  final String ratePerUnit;
  final String status;
  final int? matchedUserId;
  final String? escrowTxHash;
  final String? chapaTxRef;
  final Map<String, dynamic> createdAt;

  P2POrder({
    required this.id,
    required this.userId,
    required this.type,
    required this.asset,
    required this.cryptoAmount,
    required this.birrAmount,
    required this.ratePerUnit,
    required this.status,
    this.matchedUserId,
    this.escrowTxHash,
    this.chapaTxRef,
    required this.createdAt,
  });

  factory P2POrder.fromJson(Map<String, dynamic> json) {
    return P2POrder(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      asset: json['asset'],
      cryptoAmount: json['cryptoAmount']?.toString() ?? '0',
      birrAmount: json['birrAmount']?.toString() ?? '0',
      ratePerUnit: json['ratePerUnit']?.toString() ?? '0',
      status: json['status'],
      matchedUserId: json['matchedUserId'],
      escrowTxHash: json['escrowTxHash'],
      chapaTxRef: json['chapaTxRef'],
      createdAt: json['createdAt'] ?? {},
    );
  }
}

class CreateP2PRequest {
  final String type;
  final String asset;
  final String cryptoAmount;
  final String birrAmount;
  final double ratePerUnit;

  CreateP2PRequest({
    required this.type,
    required this.asset,
    required this.cryptoAmount,
    required this.birrAmount,
    required this.ratePerUnit,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'asset': asset,
      'cryptoAmount': cryptoAmount,
      'birrAmount': birrAmount,
      'ratePerUnit': ratePerUnit,
    };
  }
}

class P2PBuyResponse {
  final String message;
  final String checkoutUrl;
  final P2PPayment payment;

  P2PBuyResponse({
    required this.message,
    required this.checkoutUrl,
    required this.payment,
  });

  factory P2PBuyResponse.fromJson(Map<String, dynamic> json) {
    return P2PBuyResponse(
      message: json['message'] ?? '',
      checkoutUrl: json['checkoutUrl'] ?? '',
      payment: P2PPayment.fromJson(json['payment'] ?? {}),
    );
  }
}

class P2PPayment {
  final int id;
  final String txRef;
  final String status;
  final String amount;
  final int orderId;
  final int buyerId;
  final int sellerId;
  final Map<String, dynamic> createdAt;

  P2PPayment({
    required this.id,
    required this.txRef,
    required this.status,
    required this.amount,
    required this.orderId,
    required this.buyerId,
    required this.sellerId,
    required this.createdAt,
  });

  factory P2PPayment.fromJson(Map<String, dynamic> json) {
    return P2PPayment(
      id: json['id'] ?? 0,
      txRef: json['txRef'] ?? '',
      status: json['status'] ?? '',
      amount: json['amount']?.toString() ?? '0',
      orderId: json['orderId'] ?? 0,
      buyerId: json['buyerId'] ?? 0,
      sellerId: json['sellerId'] ?? 0,
      createdAt: json['createdAt'] ?? {},
    );
  }
}
