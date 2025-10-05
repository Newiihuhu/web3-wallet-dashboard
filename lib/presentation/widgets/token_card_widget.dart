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
          Row(
            children: [
              _tokenIcon(),
              const SizedBox(width: 12),
              Expanded(child: _tokenInfo()),
            ],
          ),
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

  Widget _tokenIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTheme.accentGradient,
      ),
      child: Center(
        child: Text(
          token.symbol.substring(0, 1),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryText,
          ),
        ),
      ),
    );
  }

  Widget _tokenInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          token.symbol,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryText,
          ),
        ),
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
