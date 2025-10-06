import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet/core/exception/app_exception.dart';
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
      test('should throw exception when save balance fails', () async {
        // Given
        final balance = EthBalanceEntity(balance: '0x1234567890abcdef');
        when(
          () => mockPrefs.setString('eth_balance', any()),
        ).thenThrow(Exception('Save balance failed'));

        // When & Then
        expect(
          () => datasource.saveETHBalance(balance),
          throwsA(isA<LocalStorageException>()),
        );
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
      test('should return empty balance when data is empty', () {
        // Given
        when(
          () => mockPrefs.getString('eth_balance'),
        ).thenReturn('{"balance":""}');

        // When
        final result = datasource.getETHBalance();

        // Then
        expect(result, isNotNull);
        expect(result!.balance, isEmpty);
      });

      test('should return null when no cached data exists', () {
        // Given
        when(() => mockPrefs.getString('eth_balance')).thenReturn(null);

        // When
        final result = datasource.getETHBalance();

        // Then
        expect(result, isNull);
      });
      test('should throw exception when get balance fails', () async {
        // Given
        when(
          () => mockPrefs.getString('eth_balance'),
        ).thenThrow(Exception('Get balance failed'));

        // When & Then
        expect(
          () => datasource.getETHBalance(),
          throwsA(isA<LocalStorageException>()),
        );
      });
    });
    group('hasBalanceData', () {
      test('should return true when data exists', () {
        // Given
        when(() => mockPrefs.containsKey(any())).thenReturn(true);

        // When
        final result = datasource.hasBalanceData();

        // Then
        expect(result, isTrue);
        verify(() => mockPrefs.containsKey(any())).called(1);
      });
      test('should return false when data does not exist', () {
        // Given
        when(() => mockPrefs.containsKey(any())).thenReturn(false);

        // When
        final result = datasource.hasBalanceData();

        // Then
        expect(result, isFalse);
        verify(() => mockPrefs.containsKey(any())).called(1);
      });
    });
  });
}
