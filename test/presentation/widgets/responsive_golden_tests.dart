import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/tokens_overview_entity.dart';
import 'package:web3_wallet/presentation/widgets/token_card_widget.dart';
import 'package:web3_wallet/presentation/widgets/tokens_list_widget.dart';
import 'package:web3_wallet/presentation/widgets/wallet_address_widget.dart';
import '../../helpers/golden_test_helper.dart';

void main() {
  group('Responsive Golden Tests', () {
    testWidgets('TokenCardWidget mobile portrait golden test', (
      WidgetTester tester,
    ) async {
      final token = TokensOverviewEntity(
        symbol: 'ETH',
        name: 'Ethereum',
        balance: 2.5,
        usdValue: 11361.875,
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(375, 667), // iPhone SE size
          child: TokenCardWidget(token: token),
        ),
      );

      await expectLater(
        find.byType(TokenCardWidget),
        matchesGoldenFile('golden/responsive/token_card_mobile_portrait.png'),
      );
    });

    testWidgets('TokenCardWidget mobile landscape golden test', (
      WidgetTester tester,
    ) async {
      final token = TokensOverviewEntity(
        symbol: 'ETH',
        name: 'Ethereum',
        balance: 2.5,
        usdValue: 11361.875,
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(667, 375), // iPhone SE landscape
          child: TokenCardWidget(token: token),
        ),
      );

      await expectLater(
        find.byType(TokenCardWidget),
        matchesGoldenFile('golden/responsive/token_card_mobile_landscape.png'),
      );
    });

    testWidgets('TokenCardWidget tablet golden test', (
      WidgetTester tester,
    ) async {
      final token = TokensOverviewEntity(
        symbol: 'ETH',
        name: 'Ethereum',
        balance: 2.5,
        usdValue: 11361.875,
      );

      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(768, 1024), // iPad size
          child: TokenCardWidget(token: token),
        ),
      );

      await expectLater(
        find.byType(TokenCardWidget),
        matchesGoldenFile('golden/responsive/token_card_tablet.png'),
      );
    });

    testWidgets('TokensListWidget mobile golden test', (
      WidgetTester tester,
    ) async {
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
        matchesGoldenFile('golden/responsive/tokens_list_mobile.png'),
      );
    });

    testWidgets('WalletAddressWidget different screen sizes golden test', (
      WidgetTester tester,
    ) async {
      const testAddress = '0x1234567890abcdef1234567890abcdef12345678';

      // Small screen
      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(320, 568), // iPhone 5 size
          child: WalletAddressWidget(address: testAddress),
        ),
      );

      await expectLater(
        find.byType(WalletAddressWidget),
        matchesGoldenFile('golden/responsive/wallet_address_small.png'),
      );

      // Medium screen
      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(414, 896), // iPhone 11 size
          child: WalletAddressWidget(address: testAddress),
        ),
      );

      await expectLater(
        find.byType(WalletAddressWidget),
        matchesGoldenFile('golden/responsive/wallet_address_medium.png'),
      );

      // Large screen
      await tester.pumpWidget(
        GoldenTestHelper.createResponsiveWrapper(
          size: const Size(1024, 768), // iPad landscape
          child: WalletAddressWidget(address: testAddress),
        ),
      );

      await expectLater(
        find.byType(WalletAddressWidget),
        matchesGoldenFile('golden/responsive/wallet_address_large.png'),
      );
    });

    testWidgets('TokenCardWidget with long text golden test', (
      WidgetTester tester,
    ) async {
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
        matchesGoldenFile('golden/responsive/token_card_long_text.png'),
      );
    });
  });
}
