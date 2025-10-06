import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:web3_wallet/domain/entities/tokens_overview_entity.dart';
import 'package:web3_wallet/presentation/widgets/dashboard_appbar_widget.dart';
import 'package:web3_wallet/domain/entities/wallet_overview_entity.dart';
import 'package:web3_wallet/presentation/widgets/dashboard_error_widget.dart';
import 'package:web3_wallet/presentation/widgets/dashboard_loading_widget.dart';
import 'package:web3_wallet/presentation/widgets/token_card_widget.dart';
import 'package:web3_wallet/presentation/widgets/tokens_list_widget.dart';
import 'package:web3_wallet/presentation/widgets/wallet_address_widget.dart';
import 'package:web3_wallet/presentation/widgets/wallet_overview_widget.dart';
import '../../helpers/golden_test_helper.dart';

void main() {
  group('Responsive Golden Tests', () {
    setUpAll(() async {
      await loadAppFonts();
    });
    testGoldens('TokenCardWidget mobile portrait golden test', (tester) async {
      final token = TokensOverviewEntity(
        symbol: 'ETH',
        name: 'Ethereum',
        balance: 2.5,
        usdValue: 11361.875,
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(375, 667),
          child: TokenCardWidget(token: token),
        ),
      );

      await expectLater(
        find.byType(TokenCardWidget),
        matchesGoldenFile('golden/responsive/token_card_iphone_se.png'),
      );
    });

    testGoldens('TokenCardWidget mobile landscape golden test', (tester) async {
      final token = TokensOverviewEntity(
        symbol: 'ETH',
        name: 'Ethereum',
        balance: 2.5,
        usdValue: 11361.875,
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(667, 375),
          child: TokenCardWidget(token: token),
        ),
      );

      await expectLater(
        find.byType(TokenCardWidget),
        matchesGoldenFile(
          'golden/responsive/token_card_iphone_se_landscape.png',
        ),
      );
    });

    testGoldens('TokenCardWidget tablet golden test', (tester) async {
      final token = TokensOverviewEntity(
        symbol: 'ETH',
        name: 'Ethereum',
        balance: 2.5,
        usdValue: 11361.875,
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(768, 1024),
          child: TokenCardWidget(token: token),
        ),
      );

      await expectLater(
        find.byType(TokenCardWidget),
        matchesGoldenFile('golden/responsive/token_card_ipad.png'),
      );
    });

    testGoldens('TokensListWidget mobile golden test', (tester) async {
      final tokens = List.generate(
        5,
        (index) => TokensOverviewEntity(
          symbol: 'TOKEN$index',
          name: 'Token $index',
          balance: (index + 1) * 100.0,
          usdValue: (index + 1) * 1000.0,
        ),
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(375, 667),
          child: Column(children: [TokensListWidget(tokens: tokens)]),
        ),
      );

      await expectLater(
        find.byType(TokensListWidget),
        matchesGoldenFile('golden/responsive/tokens_list_iphone_se.png'),
      );
    });

    testGoldens('WalletAddressWidget different screen sizes golden test', (
      tester,
    ) async {
      const testAddress = '0x1234567890abcdef1234567890abcdef12345678';

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(320, 568),
          child: WalletAddressWidget(address: testAddress),
        ),
      );

      await expectLater(
        find.byType(WalletAddressWidget),
        matchesGoldenFile('golden/responsive/wallet_address_iphone_5.png'),
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(414, 896),
          child: WalletAddressWidget(address: testAddress),
        ),
      );

      await expectLater(
        find.byType(WalletAddressWidget),
        matchesGoldenFile('golden/responsive/wallet_address_iphone_11.png'),
      );

      // Large screen
      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(1024, 768),
          child: WalletAddressWidget(address: testAddress),
        ),
      );

      await expectLater(
        find.byType(WalletAddressWidget),
        matchesGoldenFile('golden/responsive/wallet_address_ipad.png'),
      );
    });

    testGoldens('TokenCardWidget with long text golden test', (tester) async {
      final token = TokensOverviewEntity(
        symbol: 'VERYLONGSYMBOL',
        name: 'Very Long Token Name That Might Overflow',
        balance: 1234567.89,
        usdValue: 9876543.21,
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(375, 667),
          child: TokenCardWidget(token: token),
        ),
      );

      await expectLater(
        find.byType(TokenCardWidget),
        matchesGoldenFile(
          'golden/responsive/token_card_long_text_iphone_se.png',
        ),
      );
    });

    testGoldens('DashboardAppbarWidget responsive golden test', (tester) async {
      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(375, 667),
          child: DashboardAppbarWidget(),
        ),
      );

      await expectLater(
        find.byType(DashboardAppbarWidget),
        matchesGoldenFile('golden/responsive/dashboard_appbar_iphone_se.png'),
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(768, 1024),
          child: DashboardAppbarWidget(),
        ),
      );

      await expectLater(
        find.byType(DashboardAppbarWidget),
        matchesGoldenFile('golden/responsive/dashboard_appbar_ipad.png'),
      );
    });

    testGoldens('DashboardLoadingWidget responsive golden test', (
      tester,
    ) async {
      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(375, 667),
          child: DashboardLoadingWidget(),
        ),
      );

      await expectLater(
        find.byType(DashboardLoadingWidget),
        matchesGoldenFile('golden/responsive/dashboard_loading_iphone_se.png'),
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(768, 1024),
          child: DashboardLoadingWidget(),
        ),
      );

      await expectLater(
        find.byType(DashboardLoadingWidget),
        matchesGoldenFile('golden/responsive/dashboard_loading_ipad.png'),
      );
    });

    testGoldens('DashboardErrorWidget responsive golden test', (tester) async {
      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(375, 667),
          child: DashboardErrorWidget(onRefresh: () {}),
        ),
      );

      await expectLater(
        find.byType(DashboardErrorWidget),
        matchesGoldenFile('golden/responsive/dashboard_error_iphone_se.png'),
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(768, 1024),
          child: DashboardErrorWidget(onRefresh: () {}),
        ),
      );

      await expectLater(
        find.byType(DashboardErrorWidget),
        matchesGoldenFile('golden/responsive/dashboard_error_ipad.png'),
      );
    });

    testGoldens('WalletOverviewWidget responsive golden test', (tester) async {
      final mockWalletOverview = WalletOverviewEntity(
        ethBalance: 2.5,
        totalValue: 12361.875,
        totalToken: 2,
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(375, 667),
          child: WalletOverviewWidget(walletOverview: mockWalletOverview),
        ),
      );

      await expectLater(
        find.byType(WalletOverviewWidget),
        matchesGoldenFile('golden/responsive/wallet_overview_iphone_se.png'),
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(768, 1024),
          child: WalletOverviewWidget(walletOverview: mockWalletOverview),
        ),
      );

      await expectLater(
        find.byType(WalletOverviewWidget),
        matchesGoldenFile('golden/responsive/wallet_overview_ipad.png'),
      );
    });

    testGoldens('TokensListWidget tablet golden test', (tester) async {
      final tokens = List.generate(
        8,
        (index) => TokensOverviewEntity(
          symbol: 'TOKEN$index',
          name: 'Token $index',
          balance: (index + 1) * 100.0,
          usdValue: (index + 1) * 1000.0,
        ),
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(768, 1024),
          child: Column(children: [TokensListWidget(tokens: tokens)]),
        ),
      );

      await expectLater(
        find.byType(TokensListWidget),
        matchesGoldenFile('golden/responsive/tokens_list_ipad.png'),
      );
    });

    testGoldens('TokensListWidget empty state responsive golden test', (
      tester,
    ) async {
      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(375, 667),
          child: Column(children: [TokensListWidget(tokens: [])]),
        ),
      );

      await expectLater(
        find.byType(TokensListWidget),
        matchesGoldenFile('golden/responsive/tokens_list_empty_iphone_se.png'),
      );

      // Tablet size
      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(768, 1024),
          child: Column(children: [TokensListWidget(tokens: [])]),
        ),
      );

      await expectLater(
        find.byType(TokensListWidget),
        matchesGoldenFile('golden/responsive/tokens_list_empty_ipad.png'),
      );
    });

    testGoldens('TokenCardWidget extreme values responsive golden test', (
      tester,
    ) async {
      // Very small balance
      final smallToken = TokensOverviewEntity(
        symbol: 'WBTC',
        name: 'Wrapped Bitcoin',
        balance: 0.00000001,
        usdValue: 0.50,
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(375, 667),
          child: TokenCardWidget(token: smallToken),
        ),
      );

      await expectLater(
        find.byType(TokenCardWidget),
        matchesGoldenFile(
          'golden/responsive/token_card_small_balance_iphone_se.png',
        ),
      );

      // Very large balance
      final largeToken = TokensOverviewEntity(
        symbol: 'SHIB',
        name: 'Shiba Inu',
        balance: 1000000000.0,
        usdValue: 10000.0,
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(375, 667),
          child: TokenCardWidget(token: largeToken),
        ),
      );

      await expectLater(
        find.byType(TokenCardWidget),
        matchesGoldenFile(
          'golden/responsive/token_card_large_balance_iphone_se.png',
        ),
      );
    });
  });
}
