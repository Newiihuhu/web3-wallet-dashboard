import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/token_entity.dart';
import 'package:web3_wallet/presentation/widgets/token_card_widget.dart';

void main() {
  group('TokenCardWidget', () {
    testWidgets('should display token card with correct elements', (
      WidgetTester tester,
    ) async {
      // Given
      final token = TokenEntity(
        symbol: 'ETH',
        name: 'Ethereum',
        balance: '2.5',
        usdValue: 11304.425,
      );
      final widget = TokenCardWidget(token: token);

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(find.byType(TokenCardWidget), findsOneWidget);
      expect(find.text('ETH'), findsOneWidget);
      expect(find.text('Ethereum'), findsOneWidget);
      expect(find.text('2.5'), findsOneWidget);
      expect(find.textContaining('11304'), findsOneWidget);
      expect(find.text('Balance'), findsOneWidget);
      expect(find.text('USD Value'), findsOneWidget);
    });

    testWidgets('should display token icon with first letter', (
      WidgetTester tester,
    ) async {
      // Given
      final token = TokenEntity(
        symbol: 'USDC',
        name: 'USD Coin',
        balance: '1000.0',
        usdValue: 1000.0,
      );
      final widget = TokenCardWidget(token: token);

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(find.text('U'), findsOneWidget);
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('should format USD value correctly', (
      WidgetTester tester,
    ) async {
      // Given
      final token = TokenEntity(
        symbol: 'DAI',
        name: 'Dai Stablecoin',
        balance: '250.0',
        usdValue: 250.123456,
      );
      final widget = TokenCardWidget(token: token);

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(find.textContaining('250.12'), findsOneWidget);
    });

    testWidgets('should handle zero balance', (WidgetTester tester) async {
      // Given
      final token = TokenEntity(
        symbol: 'LINK',
        name: 'Chainlink',
        balance: '0.0',
        usdValue: 0.0,
      );
      final widget = TokenCardWidget(token: token);

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(find.text('0.0'), findsOneWidget);
      expect(find.textContaining('0.00'), findsOneWidget);
    });

    testWidgets('should handle large balance', (WidgetTester tester) async {
      // Given
      final token = TokenEntity(
        symbol: 'MKR',
        name: 'Maker',
        balance: '999999999.999999999',
        usdValue: 999999999.99,
      );
      final widget = TokenCardWidget(token: token);

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(find.text('999999999.999999999'), findsOneWidget);
      expect(find.textContaining('\$999999999.99'), findsOneWidget);
    });

    testWidgets('should have correct layout structure', (
      WidgetTester tester,
    ) async {
      // Given
      final token = TokenEntity(
        symbol: 'UNI',
        name: 'Uniswap',
        balance: '25.0',
        usdValue: 375.0,
      );
      final widget = TokenCardWidget(token: token);

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(find.byType(Container), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(Row), findsAtLeastNWidgets(1));
    });
    testWidgets('should be accessible', (WidgetTester tester) async {
      // Given
      final token = TokenEntity(
        symbol: 'COMP',
        name: 'Compound',
        balance: '5.0',
        usdValue: 300.0,
      );
      final widget = TokenCardWidget(token: token);

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(tester.takeException(), isNull);
      expect(find.byType(TokenCardWidget), findsOneWidget);
    });

    testWidgets('should handle theme changes', (WidgetTester tester) async {
      // Given
      final token = TokenEntity(
        symbol: 'SNX',
        name: 'Synthetix',
        balance: '100.0',
        usdValue: 200.0,
      );
      final widget = TokenCardWidget(token: token);

      // When
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(body: widget),
        ),
      );

      // Then
      expect(find.byType(TokenCardWidget), findsOneWidget);
      expect(find.text('SNX'), findsOneWidget);
      expect(find.text('Synthetix'), findsOneWidget);
    });

    testWidgets('should handle different token symbols', (
      WidgetTester tester,
    ) async {
      // Given
      final tokens = [
        TokenEntity(
          symbol: 'A',
          name: 'Token A',
          balance: '1.0',
          usdValue: 100.0,
        ),
        TokenEntity(
          symbol: 'BTC',
          name: 'Bitcoin',
          balance: '0.5',
          usdValue: 20000.0,
        ),
        TokenEntity(
          symbol: 'XYZ123',
          name: 'XYZ Token',
          balance: '1000.0',
          usdValue: 50.0,
        ),
      ];

      for (final token in tokens) {
        // When
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: TokenCardWidget(token: token)),
          ),
        );

        // Then
        expect(find.text(token.symbol), findsAtLeastNWidgets(1));
        expect(find.text(token.name), findsOneWidget);
        expect(find.text(token.balance), findsOneWidget);
        expect(
          find.textContaining(token.usdValue.toStringAsFixed(2)),
          findsOneWidget,
        );
      }
    });
  });
}
