import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet/core/injection/service_locator.dart';
import 'package:web3_wallet/core/theme/app_theme.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_bloc.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_event.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_state.dart';
import 'package:web3_wallet/presentation/widgets/dashboard_appbar_widget.dart';
import 'package:web3_wallet/presentation/widgets/dashboard_error_widget.dart';
import 'package:web3_wallet/presentation/widgets/dashboard_loading_widget.dart';
import 'package:web3_wallet/presentation/widgets/tokens_list_widget.dart';
import 'package:web3_wallet/presentation/widgets/wallet_address_widget.dart';
import 'package:web3_wallet/presentation/widgets/wallet_overview_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardBloc _dashboardBloc;

  @override
  void initState() {
    super.initState();
    _dashboardBloc = getIt<DashboardBloc>();
    _dashboardBloc.add(const GetWalletDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _dashboardBloc,
      child: Scaffold(
        backgroundColor: AppTheme.darkBackground,
        appBar: AppBar(
          title: DashboardAppbarWidget(),
          backgroundColor: AppTheme.cardBackground,
        ),
        body: SafeArea(
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return DashboardLoadingWidget();
              } else if (state is DashboardError) {
                return DashboardErrorWidget(
                  onRefresh: () {
                    _dashboardBloc.add(const GetWalletDataEvent());
                  },
                );
              } else if (state is DashboardLoaded) {
                return Container(
                  margin: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WalletAddressWidget(address: state.address),
                      WalletOverviewWidget(
                        walletOverview: state.walletOverview,
                      ),
                      const SizedBox(height: 16),
                      TokensListWidget(tokens: state.tokens),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
