import 'package:web3_wallet/domain/entities/wallet_overview_entity.dart';
import 'package:web3_wallet/domain/entities/token_entity.dart';

class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final String address;
  final WalletOverviewEntity walletOverview;
  final List<TokenEntity> tokens;
  final bool isFromCache;
  const DashboardLoaded({
    required this.address,
    required this.walletOverview,
    required this.tokens,
    this.isFromCache = false,
  });
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError({required this.message});
}
