import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  group('Golden Test Runner', () {
    testGoldens('Run All Golden Tests', (WidgetTester tester) async {
      await loadAppFonts();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Golden Test Runner', style: TextStyle(fontSize: 24)),
            ),
          ),
        ),
      );

      expect(find.text('Golden Test Runner'), findsOneWidget);
    });
  });
}
