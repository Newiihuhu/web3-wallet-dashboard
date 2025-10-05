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
        final balance = EthBalanceEntity(
          balance: '0x1234567890abcdef',
          lastUpdated: DateTime.now(),
          isFromRemote: true,
        );

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
        verify(
          () => mockPrefs.setInt('eth_balance_last_updated', any()),
        ).called(1);
      });

      test('should return false when save fails', () async {
        // Given
        final balance = EthBalanceEntity(
          balance: '0x1234567890abcdef',
          lastUpdated: DateTime.now(),
          isFromRemote: true,
        );

        when(
          () => mockPrefs.setString(any(), any()),
        ).thenAnswer((_) async => false);

        // When
        final result = await datasource.saveETHBalance(balance);

        // Then
        expect(result, false);
        verify(() => mockPrefs.setString('eth_balance', any())).called(1);
        verifyNever(() => mockPrefs.setInt(any(), any()));
      });

      test('should handle exceptions gracefully', () async {
        // Given
        final balance = EthBalanceEntity(
          balance: '0x1234567890abcdef',
          lastUpdated: DateTime.now(),
          isFromRemote: true,
        );

        when(
          () => mockPrefs.setString(any(), any()),
        ).thenThrow(Exception('Storage error'));

        // When
        final result = await datasource.saveETHBalance(balance);

        // Then
        expect(result, false);
      });
    });

    group('getETHBalance', () {
      test('should return cached balance when data exists', () {
        // Given
        when(() => mockPrefs.getString('eth_balance')).thenReturn(
          '{"balance":"0x1234567890abcdef","lastUpdated":1234567890,"isFromRemote":false}',
        );

        // When
        final result = datasource.getETHBalance();

        // Then
        expect(result, isNotNull);
        expect(result!.balance, '0x1234567890abcdef');
        expect(result.isFromRemote, false);
        expect(result.lastUpdated, isNotNull);
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

    group('isBalanceDataFresh', () {
      test('should return true when data is fresh (less than 5 minutes)', () {
        // Given
        final now = DateTime.now().millisecondsSinceEpoch;
        final freshTimestamp = now - (2 * 60 * 1000);

        when(() => mockPrefs.getString('eth_balance')).thenReturn(
          '{"balance":"0x1234567890abcdef","lastUpdated":$freshTimestamp,"isFromRemote":false}',
        );

        // When
        final result = datasource.isBalanceDataFresh();

        // Then
        expect(result, true);
        verify(() => mockPrefs.getString('eth_balance')).called(1);
      });

      test('should return false when data is stale (more than 5 minutes)', () {
        // Given
        final now = DateTime.now().millisecondsSinceEpoch;
        final staleTimestamp = now - (10 * 60 * 1000);

        when(() => mockPrefs.getString('eth_balance')).thenReturn(
          '{"balance":"0x1234567890abcdef","lastUpdated":$staleTimestamp,"isFromRemote":false}',
        );

        // When
        final result = datasource.isBalanceDataFresh();

        // Then
        expect(result, false);
      });

      test('should return false when no timestamp exists', () {
        // Given
        final timestamp = 0;
        when(() => mockPrefs.getString('eth_balance')).thenReturn(
          '{"balance":"0x1234567890abcdef","lastUpdated": $timestamp,"isFromRemote":false}',
        );

        // When
        final result = datasource.isBalanceDataFresh();

        // Then
        expect(result, false);
      });
    });

    group('hasBalanceData', () {
      test('should return true when balance data exists', () {
        // Given
        when(() => mockPrefs.containsKey('eth_balance')).thenReturn(true);

        // When
        final result = datasource.hasBalanceData();

        // Then
        expect(result, true);
      });

      test('should return false when no balance data exists', () {
        // Given
        when(() => mockPrefs.containsKey('eth_balance')).thenReturn(false);

        // When
        final result = datasource.hasBalanceData();

        // Then
        expect(result, false);
      });
    });
  });
}
