class DashboardConstant {
  static const String totalValue = 'Total Value (USD)';
  static const String eth = 'ETH:';
  static const String totalTokens = 'Total Tokens:';
  static const String walletOverview = 'Wallet Overview';
  static const String lastSync = 'Last sync:';
  static const String refresh = 'Refresh';
  static const String sepoliaTestnet = 'Sepolia Testnet';
  static const String walletDashboard = 'Wallet Dashboard';
  static const String address = 'Address';

  static String getUSDValue(double value) {
    return '≈\$${value.toStringAsFixed(2)}';
  }
}
