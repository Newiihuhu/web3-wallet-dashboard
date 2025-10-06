import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/tokens_overview_entity.dart';
import 'package:web3_wallet/presentation/dashboard_constant.dart';
import 'package:web3_wallet/presentation/widgets/token_card_widget.dart';

void main() {
  group('TokenCardWidget', () {
    testWidgets('should render token card with correct elements', (
      WidgetTester tester,
    ) async {
      // Given
      final token = TokensOverviewEntity(
        symbol: 'USDC',
        name: 'USD Coin',
        balance: 1000.0,
        usdValue: 1000.0,
      );
      final widget = TokenCardWidget(token: token);

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(find.byType(TokenCardWidget), findsOneWidget);
      expect(find.text(token.symbol), findsOneWidget);
      expect(find.text(token.name), findsOneWidget);
      expect(find.text(token.balance.toString()), findsOneWidget);
      expect(
        find.textContaining(token.usdValue.toStringAsFixed(2)),
        findsOneWidget,
      );
      expect(find.text(DashboardConstant.balance), findsOneWidget);
      expect(find.text(DashboardConstant.usdValue), findsOneWidget);
    });
  });
}
