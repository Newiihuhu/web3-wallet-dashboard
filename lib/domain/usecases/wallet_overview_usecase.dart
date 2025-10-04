import 'package:web3_wallet_dashboard/domain/entities/eth_balance_entity.dart';
import 'package:web3_wallet_dashboard/domain/repositories/wallet_overview_repository.dart';

class WalletOverviewUsecase {
  final WalletOverviewRepository _ethBalanceRepository;

  WalletOverviewUsecase(this._ethBalanceRepository);

  Future<EthBalanceEntity> getETHBalance(String address) async {
    return await _ethBalanceRepository.getETHBalance(address);
  }
}
