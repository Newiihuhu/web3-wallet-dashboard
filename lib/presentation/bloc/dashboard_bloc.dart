import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet/domain/entities/wallet_overview_entity.dart';
import 'package:web3_wallet/domain/entities/token_entity.dart';
import 'package:web3_wallet/domain/usecases/wallet_address_usecase.dart';
import 'package:web3_wallet/domain/usecases/wallet_overview_usecase.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_event.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final WalletOverviewUsecase _web3WalletUsecase;
  final WalletAddressUsecase _walletAddressUsecase;

  DashboardBloc(this._web3WalletUsecase, this._walletAddressUsecase)
    : super(DashboardInitial()) {
    on<GetEthBalanceEvent>(_onGetEthBalanceEvent);
  }

  void _onGetEthBalanceEvent(
    GetEthBalanceEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final address = await _walletAddressUsecase.getWalletAddress();
      final balance = await _web3WalletUsecase.getETHBalance(address);
      double convertWeiToETH = balance.convertWeiToETH();
      double convertToUSD = balance.convertToUSD();

      final walletOverview = WalletOverviewEntity(
        totalValue: 12345.67,
        ethBalance: convertWeiToETH,
        convertToUSD: convertToUSD,
        totalToken: 10,
      );

      // สร้างข้อมูล tokens ตัวอย่าง
      final tokens = _createMockTokens();

      emit(
        DashboardLoaded(
          address: address,
          walletOverview: walletOverview,
          tokens: tokens,
          isFromCache: !balance.isFromRemote,
        ),
      );
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  List<TokenEntity> _createMockTokens() {
    return [
      TokenEntity(
        symbol: 'ETH',
        name: 'Ethereum',
        balance: '2.5',
        usdValue: 11304.425,
      ),
      TokenEntity(
        symbol: 'USDC',
        name: 'USD Coin',
        balance: '1000.0',
        usdValue: 1000.0,
      ),
      TokenEntity(
        symbol: 'USDT',
        name: 'Tether USD',
        balance: '500.0',
        usdValue: 500.0,
      ),
      TokenEntity(
        symbol: 'DAI',
        name: 'Dai Stablecoin',
        balance: '250.0',
        usdValue: 250.0,
      ),
      TokenEntity(
        symbol: 'LINK',
        name: 'Chainlink',
        balance: '50.0',
        usdValue: 750.0,
      ),
      TokenEntity(
        symbol: 'UNI',
        name: 'Uniswap',
        balance: '25.0',
        usdValue: 375.0,
      ),
      TokenEntity(
        symbol: 'AAVE',
        name: 'Aave Token',
        balance: '10.0',
        usdValue: 1200.0,
      ),
      TokenEntity(
        symbol: 'COMP',
        name: 'Compound',
        balance: '5.0',
        usdValue: 300.0,
      ),
      TokenEntity(
        symbol: 'MKR',
        name: 'Maker',
        balance: '2.0',
        usdValue: 4000.0,
      ),
      TokenEntity(
        symbol: 'SNX',
        name: 'Synthetix',
        balance: '100.0',
        usdValue: 200.0,
      ),
    ];
  }
}
