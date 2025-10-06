import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet/domain/entities/eth_balance_entity.dart';
import 'package:web3_wallet/domain/entities/tokens_entity.dart';
import 'package:web3_wallet/domain/usecases/wallet_usecase.dart';

import '../../data/repositories/__mock__/wallet_repository_mock.dart';

class FakeEthBalanceEntity extends Fake implements EthBalanceEntity {}

void main() {
  group('WalletUsecase', () {
    late WalletUsecase usecase;
    late MockWalletRepository mockRepository;

    setUpAll(() {
      registerFallbackValue(FakeEthBalanceEntity());
    });

    setUp(() {
      mockRepository = MockWalletRepository();
      usecase = WalletUsecase(mockRepository);
    });

    group('getETHBalance', () {
      test('should return ETH balance from repository', () async {
        // Given
        const address = '0x1234567890abcdef1234567890abcdef12345678';
        final expectedBalance = EthBalanceEntity(
          balance: '0x1234567890abcdef1234567890abcdef12345678',
        );

        when(
          () => mockRepository.getETHBalance(address),
        ).thenAnswer((_) async => expectedBalance);

        // When
        final result = await usecase.getETHBalance(address);

        // Then
        expect(result, expectedBalance);
        expect(result.balance, expectedBalance.balance);
        verify(() => mockRepository.getETHBalance(address)).called(1);
      });
    });

    group('getErc20Tokens', () {
      test('should return ERC20 tokens from repository', () async {
        // Given
        const address = '0x1234567890abcdef1234567890abcdef12345678';
        final expectedTokens = [
          TokensEntity(
            contractAddress: '0x1234567890abcdef1234567890abcdef12345678',
            symbol: 'ETH',
            name: 'Ethereum',
            balance: '0x1234567890abcdef1234567890abcdef12345678',
            decimals: 18,
          ),
        ];
        when(
          () => mockRepository.getErc20Tokens(address),
        ).thenAnswer((_) async => expectedTokens);

        // When
        final result = await usecase.getErc20Tokens(address);

        // Then
        expect(result, expectedTokens);
        verify(() => mockRepository.getErc20Tokens(address)).called(1);
      });
    });
  });
}
