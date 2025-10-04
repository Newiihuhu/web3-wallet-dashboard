import 'package:web3_wallet_dashboard/data/datasources/local/local_storage_datasource.dart';
import 'package:web3_wallet_dashboard/data/datasources/remote/alchemy_remote_datasource.dart';
import 'package:web3_wallet_dashboard/domain/entities/eth_balance_entity.dart';
import 'package:web3_wallet_dashboard/domain/repositories/web3_wallet_repository.dart';

class Web3WalletRepositoryImpl implements Web3WalletRepository {
  final AlchemyRemoteDatasource _remoteDatasource;
  final LocalStorageDatasource _localStorageDatasource;

  Web3WalletRepositoryImpl(
    this._remoteDatasource,
    this._localStorageDatasource,
  );

  @override
  Future<EthBalanceEntity> getETHBalance(String address) async {
    return await _remoteDatasource.getETHBalance(address);
  }

  @override
  Future<String> getSavedWalletAddress() async {
    if (!hasSavedWalletAddress()) {
      await _localStorageDatasource.saveWalletAddress(
        '0x86bBF3f5B7fd6bB206f0070fAcF88556aB905088',
      );
    }
    final savedAddress = _localStorageDatasource.getWalletAddress();
    return savedAddress!;
  }

  @override
  bool hasSavedWalletAddress() {
    return _localStorageDatasource.hasWalletAddress();
  }

  @override
  Future<bool> saveWalletAddress(String address) async {
    return await _localStorageDatasource.saveWalletAddress(address);
  }
}
