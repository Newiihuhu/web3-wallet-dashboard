import 'package:web3_wallet_dashboard/domain/repositories/wallet_address_repository.dart';

class WalletAddressUsecase {
  final WalletAddressRepository _web3WalletRepository;

  WalletAddressUsecase(this._web3WalletRepository);

  Future<String> getWalletAddress() async {
    return _web3WalletRepository.getSavedWalletAddress();
  }
}