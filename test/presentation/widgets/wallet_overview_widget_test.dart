import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/wallet_overview_entity.dart';
import 'package:web3_wallet/presentation/dashboard_constant.dart';
import 'package:web3_wallet/presentation/widgets/wallet_overview_widget.dart';

void main() {
  group('WalletOverviewWidget', () {
    late WalletOverviewEntity mockWalletOverview;

    setUp(() {
      mockWalletOverview = WalletOverviewEntity(
        ethBalance: 2.5,
        totalValue: 12361.875,
        totalToken: 3,
      );
    });

    testWidgets('should render wallet overview widget with correct elements', (
      WidgetTester tester,
    ) async {
      // Given
      final widget = WalletOverviewWidget(walletOverview: mockWalletOverview);

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(find.byType(WalletOverviewWidget), findsOneWidget);
      expect(find.text(DashboardConstant.walletOverview), findsOneWidget);
      expect(find.text(DashboardConstant.eth), findsOneWidget);
      expect(find.text(DashboardConstant.usdValue), findsOneWidget);
      expect(find.text(DashboardConstant.totalTokens), findsOneWidget);
      expect(find.text('2.5'), findsOneWidget);
      expect(find.text('12,361.88'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });
  });
}
