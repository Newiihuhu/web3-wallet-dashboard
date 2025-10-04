import 'package:web3_wallet_dashboard/data/datasources/remote/alchemy_remote_datasource.dart';
import 'package:web3_wallet_dashboard/domain/entities/eth_balance_entity.dart';
import 'package:web3_wallet_dashboard/domain/repositories/wallet_overview_repository.dart';

class WalletOverviewRepositoryImpl implements WalletOverviewRepository {
  final AlchemyRemoteDatasource _remoteDatasource;

  WalletOverviewRepositoryImpl(this._remoteDatasource);

  @override
  Future<EthBalanceEntity> getETHBalance(String address) async {
    return await _remoteDatasource.getETHBalance(address);
  }
}
