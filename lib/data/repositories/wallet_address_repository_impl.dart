import 'package:web3_wallet_dashboard/data/datasources/local/wallet_address_local_datasource.dart';
import 'package:web3_wallet_dashboard/domain/repositories/wallet_address_repository.dart';

class WalletAddressRepositoryImpl implements WalletAddressRepository {
  final WalletAddressLocalDatasource _localStorageDatasource;

  WalletAddressRepositoryImpl(this._localStorageDatasource);

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
