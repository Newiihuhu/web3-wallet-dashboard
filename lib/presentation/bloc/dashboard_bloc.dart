import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet_dashboard/domain/entities/wallet_overview_entity.dart';
import 'package:web3_wallet_dashboard/domain/usecases/wallet_address_usecase.dart';
import 'package:web3_wallet_dashboard/domain/usecases/wallet_overview_usecase.dart';
import 'package:web3_wallet_dashboard/presentation/bloc/dashboard_event.dart';
import 'package:web3_wallet_dashboard/presentation/bloc/dashboard_state.dart';

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

      emit(DashboardLoaded(address: address, walletOverview: walletOverview));
    } catch (e) {
      emit(DashboardError(message: 'เกิดข้อผิดพลาด: ${e.toString()}'));
    }
  }
}
