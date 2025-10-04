class HoldingTokenEntity {
  final String tokenName;
  final String tokenSymbol;
  final String tokenAddress;
  final String tokenDecimals;
  final String tokenBalance;

  HoldingTokenEntity({
    required this.tokenName,
    required this.tokenSymbol,
    required this.tokenAddress,
    required this.tokenDecimals,
    required this.tokenBalance,
  });
}
