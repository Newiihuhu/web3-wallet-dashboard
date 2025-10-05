import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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

      test(
        'should return false when SharedPreferences fails to save',
        () async {
          // Arrange
          when(
            () =>
                mockSharedPreferences.setString(walletAddressKey, testAddress),
          ).thenAnswer((_) async => false);

          // Act
          final result = await datasource.saveWalletAddress(testAddress);

          // Assert
          expect(result, false);
          verify(
            () =>
                mockSharedPreferences.setString(walletAddressKey, testAddress),
          ).called(1);
        },
      );
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

      test('should return empty string when stored address is empty', () {
        // Arrange
        const emptyAddress = '';
        when(
          () => mockSharedPreferences.getString(walletAddressKey),
        ).thenReturn(emptyAddress);

        // Act
        final result = datasource.getWalletAddress();

        // Assert
        expect(result, emptyAddress);
        verify(
          () => mockSharedPreferences.getString(walletAddressKey),
        ).called(1);
      });
    });

    group('hasWalletAddress', () {
      const walletAddressKey = 'wallet_address';

      test(
        'should return true when wallet address key exists in SharedPreferences',
        () {
          // Arrange
          when(
            () => mockSharedPreferences.containsKey(walletAddressKey),
          ).thenReturn(true);

          // Act
          final result = datasource.hasWalletAddress();

          // Assert
          expect(result, true);
          verify(
            () => mockSharedPreferences.containsKey(walletAddressKey),
          ).called(1);
        },
      );

      test('should return false when wallet address key does not exist', () {
        // Arrange
        when(
          () => mockSharedPreferences.containsKey(walletAddressKey),
        ).thenReturn(false);

        // Act
        final result = datasource.hasWalletAddress();

        // Assert
        expect(result, false);
        verify(
          () => mockSharedPreferences.containsKey(walletAddressKey),
        ).called(1);
      });
    });
  });
}
