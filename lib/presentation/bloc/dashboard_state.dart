import 'package:web3_wallet_dashboard/domain/entities/wallet_overview_entity.dart';

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
  const DashboardLoaded({required this.address, required this.walletOverview});
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError({required this.message});
}
