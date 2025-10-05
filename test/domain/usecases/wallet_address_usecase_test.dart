import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet_dashboard/domain/usecases/wallet_address_usecase.dart';

import '../../data/repositories/__mock__/wallet_address_repository_mock.dart';

void main() {
  group('WalletAddressUsecase', () {
    late WalletAddressUsecase usecase;
    late MockWalletAddressRepository mockRepository;

    setUp(() {
      mockRepository = MockWalletAddressRepository();
      usecase = WalletAddressUsecase(mockRepository);
    });

    group('getWalletAddress', () {
      test('should return wallet address from repository', () async {
        // Given
        const expectedAddress = '0x1234567890abcdef1234567890abcdef12345678';

        when(
          () => mockRepository.getSavedWalletAddress(),
        ).thenAnswer((_) async => expectedAddress);

        // When
        final result = await usecase.getWalletAddress();

        // Then
        expect(result, expectedAddress);
        verify(() => mockRepository.getSavedWalletAddress()).called(1);
      });
    });
  });
}
