import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet/core/exception/app_exception.dart';
import 'package:web3_wallet/data/datasources/local/wallet_address_local_datasource.dart';

import '__mock__/shared_preferences_mock.dart';

void main() {
  group('WalletAddressLocalDatasource', () {
    late WalletAddressLocalDatasource datasource;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      datasource = WalletAddressLocalDatasource(mockSharedPreferences);
    });

    group('saveWalletAddress', () {
      const testAddress = '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6';
      const walletAddressKey = 'wallet_address';

      test(
        'should return true when SharedPreferences saves successfully',
        () async {
          // Arrange
          when(
            () =>
                mockSharedPreferences.setString(walletAddressKey, testAddress),
          ).thenAnswer((_) async => true);

          // Act
          final result = await datasource.saveWalletAddress(testAddress);

          // Assert
          expect(result, true);
          verify(
            () =>
                mockSharedPreferences.setString(walletAddressKey, testAddress),
          ).called(1);
        },
      );
      test('should throw exception when save wallet address fails', () async {
        // Given
        when(
          () => mockSharedPreferences.setString(walletAddressKey, any()),
        ).thenThrow(Exception('Save wallet address failed'));

        // When & Then
        expect(
          () => datasource.saveWalletAddress(testAddress),
          throwsA(isA<LocalStorageException>()),
        );
      });
    });

    group('getWalletAddress', () {
      const testAddress = '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6';
      const walletAddressKey = 'wallet_address';

      test(
        'should return wallet address when it exists in SharedPreferences',
        () {
          // Arrange
          when(
            () => mockSharedPreferences.getString(walletAddressKey),
          ).thenReturn(testAddress);

          // Act
          final result = datasource.getWalletAddress();

          // Assert
          expect(result, testAddress);
          verify(
            () => mockSharedPreferences.getString(walletAddressKey),
          ).called(1);
        },
      );
      test('should throw exception when get wallet address fails', () async {
        // Given
        when(
          () => mockSharedPreferences.getString(walletAddressKey),
        ).thenThrow(Exception('Get wallet address failed'));

        // When & Then
        expect(
          () => datasource.getWalletAddress(),
          throwsA(isA<LocalStorageException>()),
        );
      });
    });
    group('hasWalletAddress', () {
      test('should return true when data exists', () {
        // Given
        when(() => mockSharedPreferences.containsKey(any())).thenReturn(true);

        // When
        final result = datasource.hasWalletAddress();

        // Then
        expect(result, isTrue);
        verify(() => mockSharedPreferences.containsKey(any())).called(1);
      });
      test('should return false when data does not exist', () {
        // Given
        when(() => mockSharedPreferences.containsKey(any())).thenReturn(false);

        // When
        final result = datasource.hasWalletAddress();

        // Then
        expect(result, isFalse);
        verify(() => mockSharedPreferences.containsKey(any())).called(1);
      });
    });
  });
}
