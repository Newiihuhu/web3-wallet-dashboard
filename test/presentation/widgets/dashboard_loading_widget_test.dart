import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/presentation/dashboard_constant.dart';
import 'package:web3_wallet/presentation/widgets/dashboard_loading_widget.dart';

void main() {
  group('DashboardLoadingWidget', () {
    testWidgets('should display loading widget with correct elements', (
      WidgetTester tester,
    ) async {
      // Given
      const widget = DashboardLoadingWidget();

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(find.byType(DashboardLoadingWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(DashboardConstant.loadingWalletData), findsOneWidget);
      expect(find.text(DashboardConstant.pleaseWaitAMoment), findsOneWidget);
    });
  });
}
