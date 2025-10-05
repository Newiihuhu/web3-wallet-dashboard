import 'package:web3_wallet_dashboard/data/datasources/local/wallet_overview_local_datasource.dart';
import 'package:web3_wallet_dashboard/data/datasources/remote/wallet_remote_datasource.dart';
import 'package:web3_wallet_dashboard/domain/entities/eth_balance_entity.dart';
import 'package:web3_wallet_dashboard/domain/repositories/wallet_overview_repository.dart';

class WalletOverviewRepositoryImpl implements WalletOverviewRepository {
  final WalletRemoteDatasource _remoteDatasource;
  final WalletOverviewLocalDatasource _localDatasource;

  WalletOverviewRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<EthBalanceEntity> getETHBalance(String address) async {
    if (_localDatasource.hasBalanceData()) {
      if (_localDatasource.isBalanceDataFresh()) {
        final cachedBalance = _localDatasource.getETHBalance();
        if (cachedBalance != null) {
          return cachedBalance;
        }
      }
    }

    final remoteBalance = await _remoteDatasource.getETHBalance(address);
    await _localDatasource.saveETHBalance(remoteBalance);

    return remoteBalance;
  }
}
