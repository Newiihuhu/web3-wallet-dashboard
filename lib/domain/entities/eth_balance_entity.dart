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
    return balance.hexToTokenAmount(18);
  }

  double convertToUSD() {
    double ethAmount = convertWeiToETH();
    return ethAmount * 4521.77;
  }
}

extension StringHexConversion on String {
  double hexToTokenAmount(int decimals) {
    final cleaned = startsWith("0x") ? substring(2) : this;
    final raw = BigInt.parse(cleaned, radix: 16);

    return raw / BigInt.from(10).pow(decimals);
  }
}
