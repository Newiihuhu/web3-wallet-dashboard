import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/token_entity.dart';
import 'package:web3_wallet/presentation/widgets/tokens_list_widget.dart';

void main() {
  group('TokensListWidget', () {
    testWidgets('should display tokens list with correct elements', (
      WidgetTester tester,
    ) async {
      // Given
      final tokens = [
        TokenEntity(
          symbol: 'ETH',
          name: 'Ethereum',
          balance: '2.5',
          usdValue: 11304.425,
        ),
        TokenEntity(
          symbol: 'USDC',
          name: 'USD Coin',
          balance: '1000.0',
          usdValue: 1000.0,
        ),
      ];
      final widget = TokensListWidget(tokens: tokens);

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(find.byType(TokensListWidget), findsOneWidget);
      expect(find.text('Tokens'), findsOneWidget);
      expect(find.text('ETH'), findsOneWidget);
      expect(find.text('Ethereum'), findsOneWidget);
      expect(find.text('USDC'), findsOneWidget);
      expect(find.text('USD Coin'), findsOneWidget);
    });

    testWidgets('should display empty state when no tokens', (
      WidgetTester tester,
    ) async {
      // Given
      final widget = TokensListWidget(tokens: []);

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(find.byType(TokensListWidget), findsOneWidget);
      expect(find.text('Tokens'), findsOneWidget);
      expect(find.text('No tokens found'), findsOneWidget);
      expect(find.text('Your tokens will appear here'), findsOneWidget);
      expect(find.byIcon(Icons.token_outlined), findsOneWidget);
    });

    testWidgets('should scroll through tokens list', (
      WidgetTester tester,
    ) async {
      // Given
      final tokens = List.generate(
        20,
        (index) => TokenEntity(
          symbol: 'TOKEN$index',
          name: 'Token $index',
          balance: '${index + 1}.0',
          usdValue: (index + 1) * 100.0,
        ),
      );
      final widget = TokensListWidget(tokens: tokens);

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('TOKEN0'), findsOneWidget);

      // Test that scrolling works by checking if we can scroll
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Verify that scrolling occurred (TOKEN0 should no longer be visible)
      expect(find.text('TOKEN0'), findsNothing);
    });

    testWidgets('should display correct token information', (
      WidgetTester tester,
    ) async {
      // Given
      final tokens = [
        TokenEntity(
          symbol: 'ETH',
          name: 'Ethereum',
          balance: '2.5',
          usdValue: 11304.425,
        ),
      ];
      final widget = TokensListWidget(tokens: tokens);

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(find.text('ETH'), findsOneWidget);
      expect(find.text('Ethereum'), findsOneWidget);
      expect(find.text('2.5'), findsOneWidget);
      expect(find.textContaining('11304'), findsOneWidget);
      expect(find.text('Balance'), findsOneWidget);
      expect(find.text('USD Value'), findsOneWidget);
    });

    testWidgets('should have correct layout structure', (
      WidgetTester tester,
    ) async {
      // Given
      final tokens = [
        TokenEntity(
          symbol: 'ETH',
          name: 'Ethereum',
          balance: '2.5',
          usdValue: 11304.425,
        ),
      ];
      final widget = TokensListWidget(tokens: tokens);

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(find.byType(Container), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should handle large number of tokens', (
      WidgetTester tester,
    ) async {
      // Given
      final tokens = List.generate(
        100,
        (index) => TokenEntity(
          symbol: 'TOKEN$index',
          name: 'Token $index',
          balance: '${index + 1}.0',
          usdValue: (index + 1) * 100.0,
        ),
      );
      final widget = TokensListWidget(tokens: tokens);

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('TOKEN0'), findsOneWidget);
      expect(find.text('TOKEN99'), findsNothing);
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      // Given
      final tokens = [
        TokenEntity(
          symbol: 'ETH',
          name: 'Ethereum',
          balance: '2.5',
          usdValue: 11304.425,
        ),
      ];
      final widget = TokensListWidget(tokens: tokens);

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(tester.takeException(), isNull);
      expect(find.byType(TokensListWidget), findsOneWidget);
    });

    testWidgets('should handle theme changes', (WidgetTester tester) async {
      // Given
      final tokens = [
        TokenEntity(
          symbol: 'ETH',
          name: 'Ethereum',
          balance: '2.5',
          usdValue: 11304.425,
        ),
      ];
      final widget = TokensListWidget(tokens: tokens);

      // When
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(body: widget),
        ),
      );

      // Then
      expect(find.byType(TokensListWidget), findsOneWidget);
      expect(find.text('Tokens'), findsOneWidget);
      expect(find.text('ETH'), findsOneWidget);
    });
  });
}
