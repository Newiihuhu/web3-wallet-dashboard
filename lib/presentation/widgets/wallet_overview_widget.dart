import 'package:flutter/material.dart';
import 'package:web3_wallet_dashboard/domain/entities/wallet_overview_entity.dart';
import 'package:web3_wallet_dashboard/presentation/dashboard_constant.dart';

class WalletOverviewWidget extends StatelessWidget {
  const WalletOverviewWidget({
    super.key,
    required this.walletOverview,
    required this.onRefresh,
  });
  final WalletOverviewEntity walletOverview;
  final Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _refreshButton(),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[700]!),
            color: Colors.grey[800],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DashboardConstant.walletOverview,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  // ignore: deprecated_member_use
                  color: Colors.grey[600]?.withOpacity(0.3),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          DashboardConstant.totalValue,
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DashboardConstant.getUSDValue(
                            walletOverview.totalValue,
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          DashboardConstant.eth,
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          walletOverview.ethBalance.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DashboardConstant.getUSDValue(
                            walletOverview.convertToUSD,
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[400],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          DashboardConstant.totalTokens,
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          walletOverview.totalToken.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _refreshButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          DashboardConstant.lastSync,
          style: TextStyle(fontSize: 10, color: Colors.grey[400]),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: onRefresh,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh, color: Colors.grey[600], size: 16),
              const SizedBox(width: 4),
              Text(
                DashboardConstant.refresh,
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
