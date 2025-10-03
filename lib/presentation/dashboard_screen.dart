import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet_dashboard/common/injection/service_locator.dart';
import 'package:web3_wallet_dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:web3_wallet_dashboard/presentation/bloc/dashboard_event.dart';
import 'package:web3_wallet_dashboard/presentation/bloc/dashboard_state.dart';

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
    _dashboardBloc.add(
      const GetEthBalanceEvent(
        address: '0x86bBF3f5B7fd6bB206f0070fAcF88556aB905088',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _dashboardBloc,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Wallet Dashboard'),
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
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Colors.grey[300],
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(8),
                      //   border: Border.all(color: Colors.blueGrey[200]!),
                      //   color: Colors.grey[50],
                      // ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                shortenAddress(
                                  '0x86bBF3f5B7fd6bB206f0070fAcF88556aB905088',
                                ),
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text:
                                          '0x86bBF3f5B7fd6bB206f0070fAcF88556aB905088',
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Address copied to clipboard',
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.copy,
                                  color: Colors.blueGrey[500],
                                  size: 16,
                                ),
                              ),
                              // Icon(
                              //   Icons.refresh,
                              //   color: Colors.blueGrey[500],
                              //   size: 16,
                              // ),
                              // const SizedBox(width: 4),
                              // Text(
                              //   'Refresh',
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //     color: Colors.blueGrey[500],
                              //   ),
                              // ),
                            ],
                          ),
                          // const SizedBox(height: 8),
                          // Row(
                          //   children: [
                          //     Text(
                          //       'Last sync: 10/01/2025 10:00:00',
                          //       style: TextStyle(
                          //         fontSize: 12,
                          //         color: Colors.grey[600],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                            color: Colors.grey[50],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Wallet Overview',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),
                              const Text(
                                'Balances',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'ETH:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(state.ethBalance.balanceETH),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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
}

String shortenAddress(String address, {int prefix = 6, int suffix = 4}) {
  if (address.length <= prefix + suffix) return address;
  return '${address.substring(0, prefix)}...${address.substring(address.length - suffix)}';
}
