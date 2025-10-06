import 'package:web3_wallet/core/utils/formatter.dart';
import 'package:web3_wallet/core/utils/token_rates.dart';

class TokensEntity {
  final String contractAddress;
  final String symbol;
  final String name;
  final String balance;
  final int decimals;

  TokensEntity({
    required this.contractAddress,
    required this.symbol,
    required this.name,
    required this.balance,
    required this.decimals,
  });

  double convertToUSD() {
    double tokenAmount = hexToAmount(balance, decimals);
    double rate = TokenRates.getRate(symbol);
    return tokenAmount * rate;
  }

  double convertToAmount() {
    double tokenAmount = hexToAmount(balance, decimals);
    return tokenAmount;
  }
}
