import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet/core/injection/service_locator.dart';
import 'package:web3_wallet/core/theme/app_theme.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_bloc.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_event.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_state.dart';
import 'package:web3_wallet/presentation/widgets/dashboard_error_widget.dart';
import 'package:web3_wallet/presentation/widgets/dashboard_loading_widget.dart';
import 'package:web3_wallet/presentation/widgets/tokens_list_widget.dart';
import 'package:web3_wallet/presentation/widgets/wallet_overview_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardBloc _dashboardBloc;
  bool _isVisible = false;
  late final ValueNotifier<bool> _visibilityNotifier;

  @override
  void initState() {
    super.initState();
    _dashboardBloc = getIt<DashboardBloc>();
    _visibilityNotifier = ValueNotifier<bool>(_isVisible);
    _dashboardBloc.add(const GetEthBalanceEvent());
  }

  @override
  void dispose() {
    _visibilityNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _dashboardBloc,
      child: Scaffold(
        backgroundColor: AppTheme.darkBackground,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Wallet Dashboard',
                style: TextStyle(color: AppTheme.primaryText),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.successGreen,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Sepolia Testnet',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                    _dashboardBloc.add(const GetEthBalanceEvent());
                  },
                );
              } else if (state is DashboardLoaded) {
                return Container(
                  margin: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAddress(state.address),
                      WalletOverviewWidget(
                        walletOverview: state.walletOverview,
                        isFromCache: state.isFromCache,
                        onRefresh: () {
                          _dashboardBloc.add(const GetEthBalanceEvent());
                        },
                      ),
                      const SizedBox(height: 16),
                      Expanded(child: TokensListWidget(tokens: state.tokens)),
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

  Widget _buildAddress(String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.primaryText,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: _visibilityNotifier,
                builder: (context, isVisible, child) {
                  return Text(
                    isVisible ? address : shortenAddress(address),
                    style: TextStyle(fontSize: 14, color: AppTheme.primaryText),
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                _isVisible = !_isVisible;
                _visibilityNotifier.value = _isVisible;
              },
              icon: ValueListenableBuilder<bool>(
                valueListenable: _visibilityNotifier,
                builder: (context, isVisible, child) {
                  return Icon(
                    isVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppTheme.secondaryText,
                    size: 16,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

String shortenAddress(String address, {int prefix = 6, int suffix = 4}) {
  if (address.length <= prefix + suffix) return address;
  return '${address.substring(0, prefix)}...${address.substring(address.length - suffix)}';
}
