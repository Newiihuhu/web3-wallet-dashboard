import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/core/utils/formatter.dart';

void main() {
  group('Formatter', () {
    group('hexToBigInt', () {
      test('should convert hex string with 0x prefix to BigInt', () {
        // Given
        const hex = '0x1234567890abcdef';

        // When
        final result = hexToBigInt(hex);

        // Then
        expect(result, BigInt.parse('1234567890abcdef', radix: 16));
      });

      test('should convert hex string without 0x prefix to BigInt', () {
        // Given
        const hex = '1234567890abcdef';

        // When
        final result = hexToBigInt(hex);

        // Then
        expect(result, BigInt.parse('1234567890abcdef', radix: 16));
      });

      test('should convert zero hex to BigInt.zero', () {
        // Given
        const hex = '0x0';

        // When
        final result = hexToBigInt(hex);

        // Then
        expect(result, BigInt.zero);
      });

      test('should handle large hex values', () {
        // Given
        const hex = '0xffffffffffffffffffffffffffffffffffffffff';

        // When
        final result = hexToBigInt(hex);

        // Then
        expect(
          result,
          BigInt.parse('ffffffffffffffffffffffffffffffffffffffff', radix: 16),
        );
      });
    });

    group('bigIntToAmount', () {
      test('should convert BigInt to amount with decimals', () {
        // Given
        final raw = BigInt.parse('1000000000000000000');
        const decimals = 18;

        // When
        final result = bigIntToAmount(raw, decimals);

        // Then
        expect(result, 1.0);
      });

      test('should return 0.0 when BigInt is zero', () {
        // Given
        final raw = BigInt.zero;
        const decimals = 18;

        // When
        final result = bigIntToAmount(raw, decimals);

        // Then
        expect(result, 0.0);
      });

      test('should handle very small amounts', () {
        // Given
        final raw = BigInt.parse('1');
        const decimals = 18;

        // When
        final result = bigIntToAmount(raw, decimals);

        // Then
        expect(result, 1e-18);
      });
    });

    group('hexToAmount', () {
      test('should convert hex string to amount with decimals', () {
        // Given
        const hex = '0xde0b6b3a7640000';
        const decimals = 18;

        // When
        final result = hexToAmount(hex, decimals);

        // Then
        expect(result, 1.0);
      });

      test('should return 0.0 when hex is zero', () {
        // Given
        const hex = '0x0';
        const decimals = 18;

        // When
        final result = hexToAmount(hex, decimals);

        // Then
        expect(result, 0.0);
      });
    });

    group('shortenAddress', () {
      test('should shorten long address with default prefix and suffix', () {
        // Given
        const address = '0x1234567890abcdef1234567890abcdef12345678';

        // When
        final result = shortenAddress(address);

        // Then
        expect(result, '0x1234...5678');
      });

      test('should shorten address with custom prefix and suffix', () {
        // Given
        const address = '0x1234567890abcdef1234567890abcdef12345678';
        const prefix = 4;
        const suffix = 6;

        // When
        final result = shortenAddress(address, prefix: prefix, suffix: suffix);

        // Then
        expect(result, '0x12...345678');
      });

      test('should return original address when too short', () {
        // Given
        const address = '0x12345678';

        // When
        final result = shortenAddress(address);

        // Then
        expect(result, '0x12345678');
      });

      test('should handle address without 0x prefix', () {
        // Given
        const address = '1234567890abcdef1234567890abcdef12345678';

        // When
        final result = shortenAddress(address);

        // Then
        expect(result, '123456...5678');
      });
    });
  });
}
