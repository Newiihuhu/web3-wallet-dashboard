import 'package:web3_wallet_dashboard/domain/entities/eth_balance_entity.dart';
import 'package:web3_wallet_dashboard/domain/repositories/web3_wallet_repository.dart';

class Web3WalletUsecase {
  final Web3WalletRepository _ethBalanceRepository;

  Web3WalletUsecase(this._ethBalanceRepository);

  Future<EthBalanceEntity> getETHBalance(String address) async {
    return await _ethBalanceRepository.getETHBalance(address);
  }

  Future<String> getWalletAddress() async {
    return _ethBalanceRepository.getSavedWalletAddress();
  }
}
