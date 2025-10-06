import 'package:flutter/material.dart';
import 'package:web3_wallet/core/theme/app_theme.dart';
import 'package:web3_wallet/domain/entities/token_entity.dart';
import 'package:web3_wallet/presentation/widgets/token_card_widget.dart';

class TokensListWidget extends StatelessWidget {
  final List<TokenEntity> tokens;

  const TokensListWidget({super.key, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tokens (ERC-20)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: tokens.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    itemCount: tokens.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return TokenCardWidget(token: tokens[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.token_outlined, size: 48, color: AppTheme.secondaryText),
          const SizedBox(height: 16),
          Text(
            'No tokens found',
            style: TextStyle(fontSize: 16, color: AppTheme.secondaryText),
          ),
          const SizedBox(height: 8),
          Text(
            'Your tokens will appear here',
            style: TextStyle(fontSize: 14, color: AppTheme.mutedText),
          ),
        ],
      ),
    );
  }
}
