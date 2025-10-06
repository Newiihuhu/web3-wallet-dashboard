import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/core/utils/formatter.dart';

void main() {
  group('Formatter', () {
    group('hexToBigInt', () {
      test('should convert hex string to BigInt', () {
        // Given
        final random = Random(42);
        for (int i = 0; i < 5; i++) {
          final value = BigInt.from(random.nextInt(1000000));
          final hex = '0x${value.toRadixString(16)}';
          final hexWithoutPrefix = value.toRadixString(16);

          // When
          final result = hexToBigInt(hex);

          // Then
          expect(result, BigInt.parse(hexWithoutPrefix, radix: 16));
        }
      });
      test('should handle large hex values', () {
        // Given
        final maxUint256 =
            '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';

        // When
        final result = hexToBigInt(maxUint256);

        // Then
        expect(() => hexToBigInt(maxUint256), returnsNormally);
        expect(result, greaterThan(BigInt.zero));
      });
    });

    group('bigIntToAmount', () {
      test('should convert BigInt to amount with decimals correctly', () {
        // Given
        final testCases = [
          {'raw': BigInt.one, 'decimals': 0, 'expected': 1.0},
          {'raw': BigInt.one, 'decimals': 1, 'expected': 0.1},
          {'raw': BigInt.one, 'decimals': 18, 'expected': 1e-18},
          {'raw': BigInt.from(1000000), 'decimals': 6, 'expected': 1.0},
        ];

        for (final case_ in testCases) {
          final result = bigIntToAmount(
            case_['raw'] as BigInt,
            case_['decimals'] as int,
          );

          expect(result, closeTo(case_['expected'] as double, 1e-15));
        }
      });
    });

    group('hexToAmount', () {
      test('should convert hex string to amount with decimals', () {
        // Given
        final random = Random(42);
        final value = BigInt.from(random.nextInt(1000000));
        final hex = '0x${value.toRadixString(16)}';
        final decimals = random.nextInt(18) + 1;

        // When
        final result = hexToAmount(hex, decimals);

        // Then
        expect(result, closeTo(bigIntToAmount(value, decimals), 1e-12));
      });
      test('should be consistent with hexToBigInt + bigIntToAmount', () {
        // Given
        final random = Random(42);

        for (int i = 0; i < 15; i++) {
          final value = BigInt.from(random.nextInt(1000000));
          final hex = '0x${value.toRadixString(16)}';
          final decimals = random.nextInt(18) + 1;

          // When
          final directResult = hexToAmount(hex, decimals);
          final stepByStepResult = bigIntToAmount(hexToBigInt(hex), decimals);

          // Then
          expect(directResult, closeTo(stepByStepResult, 1e-12));
        }
      });

      test('should handle zero consistently', () {
        // Given
        final zeroVariants = ['0x0', '0x00', '0x0000', '0'];
        final random = Random(42);

        for (final zero in zeroVariants) {
          final decimals = random.nextInt(18) + 1;

          // When
          final result = hexToAmount(zero, decimals);

          // Then
          expect(result, equals(0.0));
        }
      });
    });

    group('shortenAddress', () {
      test('should always include prefix and suffix', () {
        // Given
        final random = Random(42);

        for (int i = 0; i < 5; i++) {
          final length = random.nextInt(20) + 20;
          final address = '0x${'a' * (length - 2)}';

          // When
          final result = shortenAddress(address);

          // Then
          expect(result, contains('...'));
          expect(result.length, lessThan(address.length));
          expect(result, startsWith(address.substring(0, 4)));
          expect(result, endsWith(address.substring(address.length - 4)));
        }
      });

      test('should return original address when too short', () {
        // Given
        final shortAddresses = ['0x1234', '0x12345678', '1234567890'];

        for (final address in shortAddresses) {
          // When
          final result = shortenAddress(address);

          // Then
          expect(result, equals(address));
        }
      });
    });
  });
}
