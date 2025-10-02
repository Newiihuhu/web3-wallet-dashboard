import 'package:web3_wallet_dashboard/data/datasources/remote/alchemy_remote_datasource.dart';
import 'package:web3_wallet_dashboard/domain/entities/eth_balance_entity.dart';
import 'package:web3_wallet_dashboard/domain/repositories/web3_wallet_repository.dart';

class Web3WalletRepositoryImpl implements Web3WalletRepository {
  final AlchemyRemoteDatasource _remoteDatasource;

  Web3WalletRepositoryImpl(this._remoteDatasource);

  @override
  Future<EthBalanceEntity> getETHBalance(String address) async {
    return await _remoteDatasource.getETHBalance(address);
  }
}
