import 'package:web3_wallet/domain/entities/eth_balance_entity.dart';

abstract class WalletOverviewRepository {
  Future<EthBalanceEntity> getETHBalance(String address);
}
