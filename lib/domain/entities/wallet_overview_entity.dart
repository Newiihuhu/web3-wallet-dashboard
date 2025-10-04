class WalletOverviewEntity {
  final double totalValue;
  final double ethBalance;
  final double convertToUSD;
  final int totalToken;

  WalletOverviewEntity({
    required this.totalValue,
    required this.ethBalance,
    required this.convertToUSD,
    required this.totalToken,
  });
}
