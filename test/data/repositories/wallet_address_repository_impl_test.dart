import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet/data/datasources/local/constants/wallet_constants.dart';
import 'package:web3_wallet/core/exception/app_exception.dart';
import 'package:web3_wallet/data/repositories/wallet_address_repository_impl.dart';

import '../datasource/local/__mock__/wallet_address_local_datasource_mock.dart';

void main() {
  group('WalletAddressRepositoryImpl', () {
    late WalletAddressRepositoryImpl repository;
    late MockWalletAddressLocalDatasource mockLocalDatasource;

    setUp(() {
      mockLocalDatasource = MockWalletAddressLocalDatasource();
      repository = WalletAddressRepositoryImpl(mockLocalDatasource);
    });

    group('getSavedWalletAddress', () {
      const mockAddress = 'mock_address';

      test('should return saved address when wallet address exists', () async {
        // Given
        when(() => mockLocalDatasource.hasWalletAddress()).thenReturn(true);
        when(
          () => mockLocalDatasource.getWalletAddress(),
        ).thenReturn(mockAddress);

        // When
        final result = await repository.getSavedWalletAddress();

        // Then
        expect(result, mockAddress);
        verify(() => mockLocalDatasource.hasWalletAddress()).called(1);
        verify(() => mockLocalDatasource.getWalletAddress()).called(1);
        verifyNever(() => mockLocalDatasource.saveWalletAddress(any()));
      });

      test(
        'should save and return address when no wallet address exists',
        () async {
          // Given
          when(() => mockLocalDatasource.hasWalletAddress()).thenReturn(false);
          when(
            () => mockLocalDatasource.saveWalletAddress(
              WalletConstants.defaultWalletAddress,
            ),
          ).thenAnswer((_) async => true);
          when(
            () => mockLocalDatasource.getWalletAddress(),
          ).thenReturn(WalletConstants.defaultWalletAddress);

          // When
          final result = await repository.getSavedWalletAddress();

          // Then
          expect(result, WalletConstants.defaultWalletAddress);
          verify(() => mockLocalDatasource.hasWalletAddress()).called(1);
          verify(
            () => mockLocalDatasource.saveWalletAddress(
              WalletConstants.defaultWalletAddress,
            ),
          ).called(1);
          verify(() => mockLocalDatasource.getWalletAddress()).called(1);
        },
      );

      test('should throw exception when address is null', () async {
        // Given
        when(() => mockLocalDatasource.hasWalletAddress()).thenReturn(true);
        when(() => mockLocalDatasource.getWalletAddress()).thenReturn(null);

        // When & Then
        expect(
          () => repository.getSavedWalletAddress(),
          throwsA(isA<AddressNotFoundException>()),
        );
        verify(() => mockLocalDatasource.hasWalletAddress()).called(1);
        verify(() => mockLocalDatasource.getWalletAddress()).called(1);
      });

      test('should throw exception when address is empty', () async {
        // Given
        when(() => mockLocalDatasource.hasWalletAddress()).thenReturn(true);
        when(() => mockLocalDatasource.getWalletAddress()).thenReturn('');

        // When & Then
        expect(
          () => repository.getSavedWalletAddress(),
          throwsA(isA<AddressNotFoundException>()),
        );
        verify(() => mockLocalDatasource.hasWalletAddress()).called(1);
        verify(() => mockLocalDatasource.getWalletAddress()).called(1);
      });
    });
  });
}
