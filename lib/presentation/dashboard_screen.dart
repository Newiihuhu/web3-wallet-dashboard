import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet_dashboard/common/injection/service_locator.dart';
import 'package:web3_wallet_dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:web3_wallet_dashboard/presentation/bloc/dashboard_event.dart';
import 'package:web3_wallet_dashboard/presentation/bloc/dashboard_state.dart';
import 'package:web3_wallet_dashboard/presentation/widgets/wallet_overview_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardBloc _dashboardBloc;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _dashboardBloc = getIt<DashboardBloc>();
    _dashboardBloc.add(const GetEthBalanceEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _dashboardBloc,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Wallet Dashboard', style: TextStyle(color: Colors.white)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors
                          .green, // You can change this based on network status
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Sepolia Testnet',
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Colors.grey[800],
        ),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardLoaded) {
              return Container(
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddress(state.address, _isVisible),
                    WalletOverviewWidget(
                      walletOverview: state.walletOverview,
                      onRefresh: () {
                        _dashboardBloc.add(const GetEthBalanceEvent());
                      },
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildAddress(String address, bool isVisible) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                isVisible ? address : shortenAddress(address),
                style: TextStyle(fontSize: 14, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                setState(() {
                  _isVisible = !_isVisible;
                });
              },
              icon: Icon(
                isVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey[400],
                size: 16,
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
