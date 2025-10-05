import 'package:web3_wallet_dashboard/core/utils/formatter.dart';

class EthBalanceEntity {
  final String balance;
  final DateTime? lastUpdated;
  final bool isFromRemote;

  EthBalanceEntity({
    required this.balance,
    this.lastUpdated,
    this.isFromRemote = false,
  });

  double convertWeiToETH() {
    return hexToAmount(balance, 18);
  }

  double convertToUSD() {
    // rate is 4544.75
    double ethAmount = convertWeiToETH();
    return ethAmount * 4544.75;
  }
}
