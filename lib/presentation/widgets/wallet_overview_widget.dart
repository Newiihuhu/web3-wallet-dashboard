import 'package:flutter/material.dart';
import 'package:web3_wallet/core/theme/app_theme.dart';
import 'package:web3_wallet/core/utils/formatter.dart';
import 'package:web3_wallet/domain/entities/wallet_overview_entity.dart';
import 'package:web3_wallet/presentation/dashboard_constant.dart';

class WalletOverviewWidget extends StatelessWidget {
  const WalletOverviewWidget({super.key, required this.walletOverview});
  final WalletOverviewEntity walletOverview;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
        color: AppTheme.cardBackground,
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
                  color: AppTheme.primaryText,
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
              color: AppTheme.surfaceBackground.withOpacity(0.3),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      DashboardConstant.eth,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      walletOverview.ethBalance.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.primaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      DashboardConstant.usdValue,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formatNumberWithCommas(walletOverview.totalValue),

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryText,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      DashboardConstant.totalTokens,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      walletOverview.totalToken.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.primaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
