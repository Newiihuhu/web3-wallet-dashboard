import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/eth_balance_entity.dart';

void main() {
  group('EthBalanceEntity', () {
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
    });
  });
}
