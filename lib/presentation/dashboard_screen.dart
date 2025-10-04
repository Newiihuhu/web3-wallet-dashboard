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
              return _buildLoadingScreen();
            } else if (state is DashboardError) {
              return _buildErrorScreen(state.message);
            } else if (state is DashboardLoaded) {
              return Container(
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddress(state.address),
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

  Widget _buildLoadingScreen() {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.purple[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading Wallet data...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait a moment',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String message) {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _dashboardBloc.add(const GetEthBalanceEvent());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                ),
                child: const Text('Try again'),
              ),
            ],
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
            color: Colors.white,
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
                    style: TextStyle(fontSize: 14, color: Colors.white),
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
                    color: Colors.grey[400],
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
