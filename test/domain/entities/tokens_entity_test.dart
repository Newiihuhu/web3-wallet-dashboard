import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/tokens_entity.dart';

void main() {
  group('TokensEntity', () {
    late TokensEntity tokensEntity;

    setUp(() {
      tokensEntity = TokensEntity(
        contractAddress: '0x1234567890abcdef1234567890abcdef12345678',
        symbol: 'ETH',
        name: 'Ethereum',
        balance: '0x8ac7230489e80000',
        decimals: 18,
      );
    });

    group('convertToAmount', () {
      test('should convert hex balance to decimal amount correctly', () {
        // Given
        const expectedAmount = 10.0;

        // When
        final amount = tokensEntity.convertToAmount();

        // Then
        expect(amount, equals(expectedAmount));
      });
    });

    group('convertToUSD', () {
      test('should convert token amount to USD using token rate', () {
        // Given
        const expectedUSD = 45447.5;

        // When
        final usdValue = tokensEntity.convertToUSD();

        // Then
        expect(usdValue, equals(expectedUSD));
      });
    });
  });
}
