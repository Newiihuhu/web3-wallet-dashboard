import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet/domain/entities/tokens_overview_entity.dart';
import 'package:web3_wallet/domain/entities/wallet_overview_entity.dart';
import 'package:web3_wallet/domain/usecases/wallet_address_usecase.dart';
import 'package:web3_wallet/domain/usecases/wallet_usecase.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_event.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final WalletUsecase _walletUsecase;
  final WalletAddressUsecase _walletAddressUsecase;

  DashboardBloc(this._walletUsecase, this._walletAddressUsecase)
    : super(DashboardInitial()) {
    on<GetWalletDataEvent>(_onGetEthBalanceEvent);
  }

  void _onGetEthBalanceEvent(
    GetWalletDataEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final address = await _walletAddressUsecase.getWalletAddress();
      final balance = await _walletUsecase.getETHBalance(address);
      double convertWeiToETH = balance.convertWeiToETH();
      double convertToUSD = balance.convertToUSD();
      final tokens = await _walletUsecase.getErc20Tokens(address);

      final walletOverview = WalletOverviewEntity(
        totalValue: convertToUSD,
        ethBalance: convertWeiToETH,
        totalToken: tokens.length,
      );

      final tokensOverview = tokens
          .map(
            (token) => TokensOverviewEntity(
              symbol: token.symbol,
              name: token.name,
              balance: token.convertToAmount(),
              usdValue: token.convertToUSD(),
            ),
          )
          .toList();

      emit(
        DashboardLoaded(
          address: address,
          walletOverview: walletOverview,
          tokens: tokensOverview,
        ),
      );
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }
}
