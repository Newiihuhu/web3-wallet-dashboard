import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/wallet_overview_entity.dart';

void main() {
  group('WalletOverviewEntity', () {
    group('Constructor', () {
      test('should create instance with all required parameters', () {
        // Given
        const totalValue = 12345.67;
        const ethBalance = 2.5;
        const totalToken = 10;

        // When
        final entity = WalletOverviewEntity(
          totalValue: totalValue,
          ethBalance: ethBalance,
          totalToken: totalToken,
        );

        // Then
        expect(entity.totalValue, equals(totalValue));
        expect(entity.ethBalance, equals(ethBalance));
        expect(entity.totalToken, equals(totalToken));
      });

      test('should handle zero values', () {
        // Given
        const totalValue = 0.0;
        const ethBalance = 0.0;
        const totalToken = 0;

        // When
        final entity = WalletOverviewEntity(
          totalValue: totalValue,
          ethBalance: ethBalance,
          totalToken: totalToken,
        );

        // Then
        expect(entity.totalValue, equals(0.0));
        expect(entity.ethBalance, equals(0.0));
        expect(entity.totalToken, equals(0));
      });

      test('should handle negative values', () {
        // Given
        const totalValue = -100.0;
        const ethBalance = -1.5;
        const totalToken = -5;

        // When
        final entity = WalletOverviewEntity(
          totalValue: totalValue,
          ethBalance: ethBalance,
          totalToken: totalToken,
        );

        // Then
        expect(entity.totalValue, equals(-100.0));
        expect(entity.ethBalance, equals(-1.5));
        expect(entity.totalToken, equals(-5));
      });
    });

    group('Empty Token List Scenarios', () {
      test('should handle empty token list (totalToken = 0)', () {
        // Given
        const totalValue = 5000.0; // Only ETH value
        const ethBalance = 1.1;
        const totalToken = 0; // No tokens

        // When
        final entity = WalletOverviewEntity(
          totalValue: totalValue,
          ethBalance: ethBalance,
          totalToken: totalToken,
        );

        // Then
        expect(entity.totalToken, equals(0));
        expect(entity.totalValue, equals(5000.0));
        expect(entity.ethBalance, equals(1.1));
      });

      test('should handle missing token data (totalToken = 0)', () {
        // Given
        const totalValue = 2500.0; // Only ETH value when no tokens
        const ethBalance = 0.55;
        const totalToken = 0; // No tokens available

        // When
        final entity = WalletOverviewEntity(
          totalValue: totalValue,
          ethBalance: ethBalance,
          totalToken: totalToken,
        );

        // Then
        expect(entity.totalToken, equals(0));
        expect(entity.totalValue, equals(2500.0));
        expect(entity.ethBalance, equals(0.55));
      });
    });

    group('With Token List Scenarios', () {
      test('should handle single token', () {
        // Given
        const totalValue = 10000.0; // ETH + 1 token value
        const ethBalance = 2.0;
        const totalToken = 1;

        // When
        final entity = WalletOverviewEntity(
          totalValue: totalValue,
          ethBalance: ethBalance,
          totalToken: totalToken,
        );

        // Then
        expect(entity.totalToken, equals(1));
        expect(entity.totalValue, equals(10000.0));
        expect(entity.ethBalance, equals(2.0));
      });

      test('should handle multiple tokens', () {
        // Given
        const totalValue = 50000.0; // ETH + multiple tokens value
        const ethBalance = 5.0;
        const totalToken = 15;

        // When
        final entity = WalletOverviewEntity(
          totalValue: totalValue,
          ethBalance: ethBalance,
          totalToken: totalToken,
        );

        // Then
        expect(entity.totalToken, equals(15));
        expect(entity.totalValue, equals(50000.0));
        expect(entity.ethBalance, equals(5.0));
      });
    });

    group('Edge Cases', () {
      test('should handle very large values', () {
        // Given
        const totalValue = 999999999.99;
        const ethBalance = 1000000.0;
        const totalToken = 1000000;

        // When
        final entity = WalletOverviewEntity(
          totalValue: totalValue,
          ethBalance: ethBalance,
          totalToken: totalToken,
        );

        // Then
        expect(entity.totalValue, equals(999999999.99));
        expect(entity.ethBalance, equals(1000000.0));
        expect(entity.totalToken, equals(1000000));
      });

      test('should handle very small values', () {
        // Given
        const totalValue = 0.000001;
        const ethBalance = 0.0000001;
        const totalToken = 1;

        // When
        final entity = WalletOverviewEntity(
          totalValue: totalValue,
          ethBalance: ethBalance,
          totalToken: totalToken,
        );

        // Then
        expect(entity.totalValue, equals(0.000001));
        expect(entity.ethBalance, equals(0.0000001));
        expect(entity.totalToken, equals(1));
      });
    });
  });
}
