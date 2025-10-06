import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/tokens_overview_entity.dart';
import 'package:web3_wallet/presentation/dashboard_constant.dart';
import 'package:web3_wallet/presentation/widgets/token_card_widget.dart';
import 'package:web3_wallet/presentation/widgets/tokens_list_widget.dart';

void main() {
  group('TokensListWidget', () {
    Widget prepareWidget(List<TokensOverviewEntity> tokens) {
      return MaterialApp(
        home: Scaffold(
          body: Column(children: [TokensListWidget(tokens: tokens)]),
        ),
      );
    }

    testWidgets('should render tokens card with correct elements', (
      WidgetTester tester,
    ) async {
      // Given
      final tokens = [
        TokensOverviewEntity(
          symbol: 'ETH',
          name: 'Ethereum',
          balance: 2.5,
          usdValue: 11304.425,
        ),
        TokensOverviewEntity(
          symbol: 'USDC',
          name: 'USD Coin',
          balance: 1000.0,
          usdValue: 1000.0,
        ),
      ];

      // When
      await tester.pumpWidget(prepareWidget(tokens));

      // Then
      expect(find.byType(TokenCardWidget), findsNWidgets(tokens.length));
    });

    testWidgets('should render empty state when no tokens', (
      WidgetTester tester,
    ) async {
      // When
      await tester.pumpWidget(prepareWidget([]));

      // Then
      expect(find.byType(TokensListWidget), findsOneWidget);
      expect(find.text(DashboardConstant.tokens), findsOneWidget);
      expect(find.text(DashboardConstant.noTokensFound), findsOneWidget);
      expect(
        find.text(DashboardConstant.yourTokensWillAppearHere),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.token_outlined), findsOneWidget);
    });

    testWidgets('should scroll through tokens cards', (
      WidgetTester tester,
    ) async {
      // Given
      final tokens = List.generate(
        20,
        (index) => TokensOverviewEntity(
          symbol: 'TOKEN$index',
          name: 'Token $index',
          balance: index + 1.0,
          usdValue: (index + 1) * 100.0,
        ),
      );

      // When
      await tester.pumpWidget(prepareWidget(tokens));

      // Then
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text(tokens[0].symbol), findsOneWidget);

      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      expect(find.text(tokens[0].symbol), findsNothing);
    });
  });
}
