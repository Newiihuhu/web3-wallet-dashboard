import 'package:web3_wallet/core/utils/formatter.dart';

class TokenBalanceModel {
  final String contractAddress;
  final String tokenBalance;

  TokenBalanceModel({
    required this.contractAddress,
    required this.tokenBalance,
  });

  factory TokenBalanceModel.fromJson(Map<String, dynamic> json) {
    return TokenBalanceModel(
      contractAddress: json['contractAddress'] as String,
      tokenBalance: json['tokenBalance'] as String,
    );
  }
}

class TokensResultModel {
  final String address;
  final List<TokenBalanceModel> tokenBalances;

  TokensResultModel({required this.address, required this.tokenBalances});

  factory TokensResultModel.fromJson(Map<String, dynamic> json) {
    return TokensResultModel(
      address: json['address'] as String,
      tokenBalances: (json['tokenBalances'] as List<dynamic>)
          .map(
            (item) => TokenBalanceModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class TokensListModel {
  final String jsonrpc;
  final int id;
  final TokensResultModel result;

  TokensListModel({
    required this.jsonrpc,
    required this.id,
    required this.result,
  });

  factory TokensListModel.fromJson(Map<String, dynamic> json) {
    return TokensListModel(
      jsonrpc: json['jsonrpc'] as String,
      id: json['id'] as int,
      result: TokensResultModel.fromJson(
        json['result'] as Map<String, dynamic>,
      ),
    );
  }

  List<TokenBalanceModel> filterTokens() {
    return result.tokenBalances
        .where((token) => hexToBigInt(token.tokenBalance) != BigInt.zero)
        .toList();
  }
}
