import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3_wallet/core/theme/app_theme.dart';
import 'package:web3_wallet/core/utils/formatter.dart';
import 'package:web3_wallet/presentation/dashboard_constant.dart';

class WalletAddressWidget extends StatelessWidget {
  const WalletAddressWidget({super.key, required this.address});
  final String address;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          DashboardConstant.address,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(shortenAddress(address)),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: address));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  DashboardConstant.copiedToClipboard,
                  style: TextStyle(color: AppTheme.primaryText, fontSize: 14),
                ),
                backgroundColor: AppTheme.cardBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: AppTheme.borderColor),
                ),
              ),
            );
          },
          icon: Icon(Icons.copy, color: AppTheme.primaryText, size: 16),
        ),
      ],
    );
  }
}
