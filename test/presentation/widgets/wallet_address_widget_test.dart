import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/presentation/widgets/wallet_address_widget.dart';

void main() {
  group('WalletAddressWidget', () {
    const testAddress = '0x1234567890abcdef1234567890abcdef12345678';
    const shortAddress = '0x1234...5678';

    Widget prepareWidget(String address) {
      return MaterialApp(
        home: Scaffold(body: WalletAddressWidget(address: address)),
      );
    }

    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(prepareWidget(testAddress));

      expect(find.text('Address'), findsOneWidget);
      expect(find.text(shortAddress), findsOneWidget);
      expect(find.byIcon(Icons.copy), findsOneWidget);
    });

    testWidgets('should shorten long address correctly', (
      WidgetTester tester,
    ) async {
      const longAddress = '0x1234567890abcdef1234567890abcdef12345678';
      const expectedShort = '0x1234...5678';

      await tester.pumpWidget(prepareWidget(longAddress));

      expect(find.text(expectedShort), findsOneWidget);
    });

    testWidgets('should copy address to clipboard when copy button is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(prepareWidget(testAddress));

      await tester.tap(find.byIcon(Icons.copy));
      await tester.pump();

      expect(find.byIcon(Icons.copy), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Address copied to clipboard'), findsOneWidget);
    });

    testWidgets('should handle empty address', (WidgetTester tester) async {
      await tester.pumpWidget(prepareWidget(''));

      expect(find.text('Address'), findsOneWidget);
      expect(find.byIcon(Icons.copy), findsOneWidget);
    });

    testWidgets('should not shorten short address', (
      WidgetTester tester,
    ) async {
      const shortAddress = '0x1234';

      await tester.pumpWidget(prepareWidget(shortAddress));

      expect(find.text(shortAddress), findsOneWidget);
    });
  });
}
