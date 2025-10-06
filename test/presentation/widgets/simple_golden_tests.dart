import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/tokens_overview_entity.dart';
import 'package:web3_wallet/presentation/widgets/dashboard_loading_widget.dart';
import 'package:web3_wallet/presentation/widgets/dashboard_error_widget.dart';
import 'package:web3_wallet/presentation/widgets/token_card_widget.dart';
import 'package:web3_wallet/presentation/widgets/tokens_list_widget.dart';
import 'package:web3_wallet/presentation/widgets/wallet_address_widget.dart';

void main() {
  group('Simple Golden Tests', () {
    testWidgets('DashboardLoadingWidget golden test', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DashboardLoadingWidget())),
      );

      await expectLater(
        find.byType(DashboardLoadingWidget),
        matchesGoldenFile('golden/simple/dashboard_loading_widget.png'),
      );
    });

    testWidgets('DashboardErrorWidget golden test', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: DashboardErrorWidget(onRefresh: () {})),
        ),
      );

      await expectLater(
        find.byType(DashboardErrorWidget),
        matchesGoldenFile('golden/simple/dashboard_error_widget.png'),
      );
    });

    testWidgets('WalletAddressWidget golden test', (WidgetTester tester) async {
      const testAddress = '0x1234567890abcdef1234567890abcdef12345678';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(child: WalletAddressWidget(address: testAddress)),
          ),
        ),
      );

      await expectLater(
        find.byType(WalletAddressWidget),
        matchesGoldenFile('golden/simple/wallet_address_widget.png'),
      );
    });

    testWidgets('TokenCardWidget golden test', (WidgetTester tester) async {
      final token = TokensOverviewEntity(
        symbol: 'ETH',
        name: 'Ethereum',
        balance: 2.5,
        usdValue: 11361.875,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(width: 400, child: TokenCardWidget(token: token)),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(TokenCardWidget),
        matchesGoldenFile('golden/simple/token_card_widget.png'),
      );
    });

    testWidgets('TokensListWidget with tokens golden test', (
      WidgetTester tester,
    ) async {
      final tokens = [
        TokensOverviewEntity(
          symbol: 'ETH',
          name: 'Ethereum',
          balance: 2.5,
          usdValue: 11361.875,
        ),
        TokensOverviewEntity(
          symbol: 'USDC',
          name: 'USD Coin',
          balance: 1000.0,
          usdValue: 1000.0,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(children: [TokensListWidget(tokens: tokens)]),
          ),
        ),
      );

      await expectLater(
        find.byType(TokensListWidget),
        matchesGoldenFile('golden/simple/tokens_list_widget_with_tokens.png'),
      );
    });

    testWidgets('TokensListWidget empty state golden test', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(children: [TokensListWidget(tokens: [])]),
          ),
        ),
      );

      await expectLater(
        find.byType(TokensListWidget),
        matchesGoldenFile('golden/simple/tokens_list_widget_empty.png'),
      );
    });

    testWidgets('TokenCardWidget with large balance golden test', (
      WidgetTester tester,
    ) async {
      final token = TokensOverviewEntity(
        symbol: 'SHIB',
        name: 'Shiba Inu',
        balance: 1000000.0,
        usdValue: 10.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(width: 400, child: TokenCardWidget(token: token)),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(TokenCardWidget),
        matchesGoldenFile('golden/simple/token_card_widget_large_balance.png'),
      );
    });

    testWidgets('TokenCardWidget with small balance golden test', (
      WidgetTester tester,
    ) async {
      final token = TokensOverviewEntity(
        symbol: 'WBTC',
        name: 'Wrapped Bitcoin',
        balance: 0.0001,
        usdValue: 9.5,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(width: 400, child: TokenCardWidget(token: token)),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(TokenCardWidget),
        matchesGoldenFile('golden/simple/token_card_widget_small_balance.png'),
      );
    });
  });
}
