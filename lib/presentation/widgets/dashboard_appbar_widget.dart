import 'package:flutter/material.dart';
import 'package:web3_wallet/core/theme/app_theme.dart';
import 'package:web3_wallet/presentation/dashboard_constant.dart';

class DashboardAppbarWidget extends StatelessWidget {
  const DashboardAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DashboardConstant.walletDashboard,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryText,
          ),
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
              DashboardConstant.sepoliaTestnet,
              style: TextStyle(fontSize: 16, color: AppTheme.secondaryText),
            ),
          ],
        ),
      ],
    );
  }
}
