import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/eth_balance_entity.dart';

void main() {
  group('EthBalanceEntity', () {
    group('Constructor', () {
      test('should create instance', () {
        // Given
        const balance = '0x1234567890abcdef1234567890abcdef12345678';
        final lastUpdated = DateTime.now();
        const isFromRemote = true;

        // When
        final entity = EthBalanceEntity(
          balance: balance,
          lastUpdated: lastUpdated,
          isFromRemote: isFromRemote,
        );

        // Then
        expect(entity.balance, balance);
        expect(entity.lastUpdated, lastUpdated);
        expect(entity.isFromRemote, isFromRemote);
      });
    });

    group('convertWeiToETH', () {
      test('should convert wei to ETH correctly', () {
        // Given
        const balance = '0x1bc16d674ec80000'; // 2 ETH in wei
        final entity = EthBalanceEntity(balance: balance);

        // When
        final result = entity.convertWeiToETH();

        // Then
        expect(result, 2.0);
      });

      test('should convert zero wei to zero ETH', () {
        // Given
        const balance = '0x0';
        final entity = EthBalanceEntity(balance: balance);

        // When
        final result = entity.convertWeiToETH();

        // Then
        expect(result, 0.0);
      });

      test('should convert balance without 0x prefix', () {
        // Given
        const balance = 'de0b6b3a7640000';
        final entity = EthBalanceEntity(balance: balance);

        // When
        final result = entity.convertWeiToETH();

        // Then
        expect(result, 1.0);
      });

      test('should convert very small amount correctly', () {
        // Given
        const balance = '0x1';
        final entity = EthBalanceEntity(balance: balance);

        // When
        final result = entity.convertWeiToETH();

        // Then
        expect(result, 0.000000000000000001);
      });

      test('should convert very large amount correctly', () {
        // Given
        const balance = '0x56bc75e2d630e0000';
        final entity = EthBalanceEntity(balance: balance);

        // When
        final result = entity.convertWeiToETH();

        // Then
        expect(result, 99.99999999999987);
      });
    });

    group('convertToUSD with rate 4544.75', () {
      test('should convert ETH to USD correctly', () {
        // Given
        const balance = '0xde0b6b3a7640000';
        final entity = EthBalanceEntity(balance: balance);

        // When
        final result = entity.convertToUSD();

        // Then
        expect(result, 4544.75);
      });

      test('should convert 2 ETH to USD correctly', () {
        // Given
        const balance = '0x1bc16d674ec80000';
        final entity = EthBalanceEntity(balance: balance);

        // When
        final result = entity.convertToUSD();

        // Then
        expect(result, 9089.5);
      });

      test('should convert zero ETH to zero USD', () {
        // Given
        const balance = '0x0';
        final entity = EthBalanceEntity(balance: balance);

        // When
        final result = entity.convertToUSD();

        // Then
        expect(result, 0.0);
      });
    });
  });
}
