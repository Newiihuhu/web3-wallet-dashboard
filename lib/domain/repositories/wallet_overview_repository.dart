import 'package:web3_wallet_dashboard/domain/entities/eth_balance_entity.dart';

abstract class WalletOverviewRepository {
  Future<EthBalanceEntity> getETHBalance(String address);
}
