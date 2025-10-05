import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/presentation/dashboard_constant.dart';
import 'package:web3_wallet/presentation/widgets/dashboard_error_widget.dart';

void main() {
  group('DashboardErrorWidget', () {
    testWidgets('should display error widget with correct elements', (
      WidgetTester tester,
    ) async {
      // Given
      final widget = DashboardErrorWidget(onRefresh: () {});

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Then
      expect(find.byType(DashboardErrorWidget), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text(DashboardConstant.somethingWentWrong), findsOneWidget);
      expect(find.text(DashboardConstant.tryAgain), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should call onRefresh when button is tapped', (
      WidgetTester tester,
    ) async {
      // Given
      bool refreshCalled = false;
      final widget = DashboardErrorWidget(
        onRefresh: () => refreshCalled = true,
      );

      // When
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
      await tester.tap(find.byType(ElevatedButton));

      // Then
      expect(refreshCalled, true);
    });
  });
}
