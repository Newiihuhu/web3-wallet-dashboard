import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet_dashboard/domain/usecases/web3_wallet_usecase.dart';
import 'package:web3_wallet_dashboard/presentation/bloc/dashboard_event.dart';
import 'package:web3_wallet_dashboard/presentation/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final Web3WalletUsecase _web3WalletUsecase;

  DashboardBloc(this._web3WalletUsecase) : super(DashboardInitial()) {
    on<GetEthBalanceEvent>(_onGetEthBalanceEvent);
  }

  void _onGetEthBalanceEvent(
    GetEthBalanceEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    final ethBalance = await _web3WalletUsecase.getETHBalance(event.address);
    emit(DashboardLoaded(ethBalance: ethBalance));
  }
}
