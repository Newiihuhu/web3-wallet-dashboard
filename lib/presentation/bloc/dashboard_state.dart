import 'package:web3_wallet_dashboard/domain/entities/eth_balance_entity.dart';

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
  final EthBalanceEntity ethBalance;
  const DashboardLoaded({required this.ethBalance});
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError({required this.message});
}