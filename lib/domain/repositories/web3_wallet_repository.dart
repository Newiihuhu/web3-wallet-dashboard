import 'package:web3_wallet_dashboard/domain/entities/eth_balance_entity.dart';

abstract class Web3WalletRepository {
  Future<EthBalanceEntity> getETHBalance(String address);
  Future<String> getSavedWalletAddress();
  bool hasSavedWalletAddress();
  Future<bool> saveWalletAddress(String address);
}
