import 'package:web3_wallet/domain/entities/eth_balance_entity.dart';
import 'package:web3_wallet/domain/entities/tokens_entity.dart';
import 'package:web3_wallet/domain/repositories/wallet_repository.dart';

class WalletUsecase {
  final WalletRepository _walletRepository;

  WalletUsecase(this._walletRepository);

  Future<EthBalanceEntity> getETHBalance(String address) async {
    return await _walletRepository.getETHBalance(address);
  }

  Future<List<TokensEntity>> getErc20Tokens(String address) async {
    return await _walletRepository.getErc20Tokens(address);
  }
}
