class TokenMetadataModel {
  final String jsonrpc;
  final int id;
  final TokenMetadataResultModel result;

  TokenMetadataModel({
    required this.jsonrpc,
    required this.id,
    required this.result,
  });

  factory TokenMetadataModel.fromJson(Map<String, dynamic> json) {
    return TokenMetadataModel(
      jsonrpc: json['jsonrpc'] as String,
      id: json['id'] as int,
      result: TokenMetadataResultModel.fromJson(
        json['result'] as Map<String, dynamic>,
      ),
    );
  }
}

class TokenMetadataResultModel {
  final int decimals;
  final String? logo;
  final String name;
  final String symbol;

  TokenMetadataResultModel({
    required this.decimals,
    this.logo,
    required this.name,
    required this.symbol,
  });

  factory TokenMetadataResultModel.fromJson(Map<String, dynamic> json) {
    return TokenMetadataResultModel(
      decimals: json['decimals'] as int,
      logo: json['logo'] as String?,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
    );
  }
}
