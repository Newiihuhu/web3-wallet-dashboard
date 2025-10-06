import 'package:flutter/material.dart';
import 'package:web3_wallet/core/theme/app_theme.dart';
import 'package:web3_wallet/domain/entities/tokens_overview_entity.dart';
import 'package:web3_wallet/presentation/dashboard_constant.dart';

class TokenCardWidget extends StatelessWidget {
  final TokensOverviewEntity token;

  const TokenCardWidget({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          _tokenInfo(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _tokenBalance()),
              const SizedBox(width: 16),
              Expanded(child: _tokenUsdValue()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tokenInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            token.symbol,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryText,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        Icon(Icons.circle, size: 8, color: AppTheme.secondaryText),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            token.name,
            style: TextStyle(fontSize: 12, color: AppTheme.secondaryText),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _tokenBalance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DashboardConstant.balance,
          style: TextStyle(fontSize: 12, color: AppTheme.secondaryText),
        ),
        Text(
          token.balance.toString(),
          style: const TextStyle(fontSize: 14, color: AppTheme.primaryText),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _tokenUsdValue() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          DashboardConstant.usdValue,
          style: TextStyle(fontSize: 12, color: AppTheme.secondaryText),
        ),
        Text(
          token.usdValue.toStringAsFixed(2),
          style: const TextStyle(fontSize: 14, color: AppTheme.primaryText),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
