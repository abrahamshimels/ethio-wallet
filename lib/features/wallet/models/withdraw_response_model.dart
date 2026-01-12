class WithdrawResponse {
  final String message;
  final TatumResponse? tatumResponse;
  final WithdrawDetail? withdraw;
  
  // Error handling fields
  final int? statusCode;
  final String? errorCode;
  final String? dashboardLog;

  WithdrawResponse({
    required this.message,
    this.tatumResponse,
    this.withdraw,
    this.statusCode,
    this.errorCode,
    this.dashboardLog,
  });

  factory WithdrawResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawResponse(
      message: json['message'] ?? '',
      tatumResponse: json['tatumResponse'] != null
          ? TatumResponse.fromJson(json['tatumResponse'])
          : null,
      withdraw: json['withdraw'] != null
          ? WithdrawDetail.fromJson(json['withdraw'])
          : null,
      statusCode: json['statusCode'],
      errorCode: json['errorCode'],
      dashboardLog: json['dashboardLog'],
    );
  }
}

class TatumResponse {
  final String id;
  final String reference;

  TatumResponse({required this.id, required this.reference});

  factory TatumResponse.fromJson(Map<String, dynamic> json) {
    return TatumResponse(
      id: json['id'] ?? '',
      reference: json['reference'] ?? '',
    );
  }
}

class WithdrawDetail {
  final int id;
  final int userId;
  final String asset;
  final String toAddress;
  final String amountBase;
  final String feeBase;
  final String status;

  WithdrawDetail({
    required this.id,
    required this.userId,
    required this.asset,
    required this.toAddress,
    required this.amountBase,
    required this.feeBase,
    required this.status,
  });

  factory WithdrawDetail.fromJson(Map<String, dynamic> json) {
    return WithdrawDetail(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      asset: json['asset'] ?? '',
      toAddress: json['to_address'] ?? '',
      amountBase: json['amount_base']?.toString() ?? '0',
      feeBase: json['fee_base']?.toString() ?? '0',
      status: json['status'] ?? '',
    );
  }
}
