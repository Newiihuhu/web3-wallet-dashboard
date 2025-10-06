import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class GoldenTestHelper {
  static Future<void> loadAppFonts() async {
    await loadAppFonts();
  }

  static Widget createTestWrapper({
    required Widget child,
    ThemeData? theme,
    bool useMaterial3 = true,
  }) {
    return MaterialApp(
      theme:
          theme ??
          ThemeData(
            useMaterial3: useMaterial3,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
          ),
      home: Scaffold(body: child),
    );
  }

  static Widget createDarkTestWrapper({
    required Widget child,
    ThemeData? theme,
    bool useMaterial3 = true,
  }) {
    return MaterialApp(
      theme:
          theme ??
          ThemeData(
            useMaterial3: useMaterial3,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
          ),
      home: Scaffold(body: child),
    );
  }

  static Future<void> pumpAndSettleWithGolden(
    WidgetTester tester,
    Widget widget, {
    Duration? duration,
  }) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle(duration ?? const Duration(seconds: 1));
  }

  static Future<void> expectGoldenMatches(
    WidgetTester tester,
    String goldenFile, {
    Finder? finder,
  }) async {
    if (finder != null) {
      await expectLater(finder, matchesGoldenFile(goldenFile));
    } else {
      await expectLater(find.byType(Scaffold), matchesGoldenFile(goldenFile));
    }
  }

  static Widget createResponsiveWrapper({required Widget child, Size? size}) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: size?.width ?? 400,
            height: size?.height ?? 800,
            child: child,
          ),
        ),
      ),
    );
  }

  static Widget createScrollableWrapper({required Widget child}) {
    return MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );
  }
}
