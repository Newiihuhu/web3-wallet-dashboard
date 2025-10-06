import 'package:flutter/material.dart';
import 'package:web3_wallet/core/theme/app_theme.dart';
import 'package:web3_wallet/domain/entities/token_entity.dart';

class TokenCardWidget extends StatelessWidget {
  final TokenEntity token;

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
        Text(
          token.symbol,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(width: 12),
        Icon(Icons.circle, size: 8, color: AppTheme.secondaryText),
        const SizedBox(width: 12),
        Text(
          token.name,
          style: TextStyle(fontSize: 12, color: AppTheme.secondaryText),
        ),
      ],
    );
  }

  Widget _tokenBalance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Balance',
          style: TextStyle(fontSize: 12, color: AppTheme.secondaryText),
        ),
        Text(
          token.balance,
          style: const TextStyle(fontSize: 14, color: AppTheme.primaryText),
        ),
      ],
    );
  }

  Widget _tokenUsdValue() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'USD Value',
          style: TextStyle(fontSize: 12, color: AppTheme.secondaryText),
        ),
        Text(
          '\$${token.usdValue.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 14, color: AppTheme.primaryText),
        ),
      ],
    );
  }
}
