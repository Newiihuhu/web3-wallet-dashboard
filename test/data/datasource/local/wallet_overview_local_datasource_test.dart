import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet/data/datasources/local/wallet_overview_local_datasource.dart';
import 'package:web3_wallet/domain/entities/eth_balance_entity.dart';

import '__mock__/shared_preferences_mock.dart';

void main() {
  group('WalletOverviewLocalDatasource', () {
    late WalletOverviewLocalDatasource datasource;
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      datasource = WalletOverviewLocalDatasource(mockPrefs);
    });

    group('saveETHBalance', () {
      test('should save balance data successfully', () async {
        // Given
        final balance = EthBalanceEntity(balance: '0x1234567890abcdef');

        when(
          () => mockPrefs.setString(any(), any()),
        ).thenAnswer((_) async => true);
        when(
          () => mockPrefs.setInt(any(), any()),
        ).thenAnswer((_) async => true);

        // When
        final result = await datasource.saveETHBalance(balance);

        // Then
        expect(result, true);
        verify(() => mockPrefs.setString('eth_balance', any())).called(1);
      });
    });

    group('getETHBalance', () {
      test('should return cached balance when data exists', () {
        // Given
        when(
          () => mockPrefs.getString('eth_balance'),
        ).thenReturn('{"balance":"0x1234567890abcdef"}');

        // When
        final result = datasource.getETHBalance();

        // Then
        expect(result, isNotNull);
        expect(result!.balance, '0x1234567890abcdef');
      });
      test('should return empty when data is empty', () {
        // Given
        when(() => mockPrefs.getString('eth_balance')).thenReturn('{}');

        // When
        final result = datasource.getETHBalance();

        // Then
        expect(result, isEmpty);
      });

      test('should return null when no cached data exists', () {
        // Given
        when(() => mockPrefs.getString('eth_balance')).thenReturn(null);

        // When
        final result = datasource.getETHBalance();

        // Then
        expect(result, isNull);
      });
    });
  });
}
