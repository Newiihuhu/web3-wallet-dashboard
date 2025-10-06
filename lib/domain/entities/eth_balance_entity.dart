import 'package:web3_wallet/core/utils/formatter.dart';
import 'package:web3_wallet/core/utils/token_rates.dart';

class EthBalanceEntity {
  final String balance;

  EthBalanceEntity({
    required this.balance,
  });

  double convertWeiToETH() {
    return hexToAmount(balance, 18);
  }

  double convertToUSD() {
    double ethAmount = convertWeiToETH();
    return ethAmount * TokenRates.getRate('ETH');
  }
}
