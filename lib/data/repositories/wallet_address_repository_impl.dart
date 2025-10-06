import 'package:web3_wallet/core/constants/wallet_constants.dart';
import 'package:web3_wallet/core/exception/app_exception.dart';
import 'package:web3_wallet/data/datasources/local/wallet_address_local_datasource.dart';
import 'package:web3_wallet/domain/repositories/wallet_address_repository.dart';

class WalletAddressRepositoryImpl implements WalletAddressRepository {
  final WalletAddressLocalDatasource _localStorageDatasource;

  WalletAddressRepositoryImpl(this._localStorageDatasource);

  @override
  Future<String> getSavedWalletAddress() async {
    if (!_localStorageDatasource.hasWalletAddress()) {
      await _localStorageDatasource.saveWalletAddress(
        WalletConstants.defaultWalletAddress,
      );
    }

    final savedAddress = _localStorageDatasource.getWalletAddress();

    if (savedAddress == null || savedAddress.isEmpty) {
      throw AddressNotFoundException(WalletConstants.addressNotFoundException);
    }

    return savedAddress;
  }
}
