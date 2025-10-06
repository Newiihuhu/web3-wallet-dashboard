import 'package:web3_wallet/domain/entities/eth_balance_entity.dart';
import 'package:web3_wallet/domain/entities/tokens_entity.dart';

abstract class WalletRepository {
  Future<EthBalanceEntity> getETHBalance(String address);
  Future<List<TokensEntity>> getErc20Tokens(String address);
}
