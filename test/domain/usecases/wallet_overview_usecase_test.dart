import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet_dashboard/domain/entities/eth_balance_entity.dart';
import 'package:web3_wallet_dashboard/domain/usecases/wallet_overview_usecase.dart';

import '../../data/repositories/__mock__/wallet_overview_repository_mock.dart';

class FakeEthBalanceEntity extends Fake implements EthBalanceEntity {}

void main() {
  group('WalletOverviewUsecase', () {
    late WalletOverviewUsecase usecase;
    late MockWalletOverviewRepository mockRepository;

    setUpAll(() {
      registerFallbackValue(FakeEthBalanceEntity());
    });

    setUp(() {
      mockRepository = MockWalletOverviewRepository();
      usecase = WalletOverviewUsecase(mockRepository);
    });

    group('getETHBalance', () {
      test('should return ETH balance from repository', () async {
        // Given
        const address = '0x1234567890abcdef1234567890abcdef12345678';
        final expectedBalance = EthBalanceEntity(
          balance: '0x1234567890abcdef1234567890abcdef12345678',
          lastUpdated: DateTime.now(),
          isFromRemote: true,
        );

        when(
          () => mockRepository.getETHBalance(address),
        ).thenAnswer((_) async => expectedBalance);

        // When
        final result = await usecase.getETHBalance(address);

        // Then
        expect(result, expectedBalance);
        expect(result.balance, expectedBalance.balance);
        expect(result.isFromRemote, true);
        verify(() => mockRepository.getETHBalance(address)).called(1);
      });
    });
  });
}
