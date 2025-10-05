import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet/data/models/eth_balance_model.dart';
import 'package:web3_wallet/data/repositories/wallet_overview_repository_impl.dart';
import 'package:web3_wallet/domain/entities/eth_balance_entity.dart';

import '../datasource/local/__mock__/wallet_overview_local_datasource_mock.dart';
import '../datasource/remote/__mock__/wallet_remote_datasource_mock.dart';

class FakeEthBalanceEntity extends Fake implements EthBalanceEntity {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeEthBalanceEntity());
  });
  group('WalletOverviewRepositoryImpl', () {
    late WalletOverviewRepositoryImpl repository;
    late MockWalletRemoteDatasource mockRemoteDatasource;
    late MockWalletOverviewLocalDatasource mockLocalDatasource;

    setUp(() {
      mockRemoteDatasource = MockWalletRemoteDatasource();
      mockLocalDatasource = MockWalletOverviewLocalDatasource();
      repository = WalletOverviewRepositoryImpl(
        mockRemoteDatasource,
        mockLocalDatasource,
      );
    });

    group('getETHBalance', () {
      const testAddress = '0x1234567890abcdef';
      final testBalance = EthBalanceEntity(
        balance: '0x1234567890abcdef',
        lastUpdated: DateTime.now(),
        isFromRemote: false,
      );

      test('should return local balance when available and fresh', () async {
        // Given
        when(() => mockLocalDatasource.hasBalanceData()).thenReturn(true);
        when(() => mockLocalDatasource.isBalanceDataFresh()).thenReturn(true);
        when(() => mockLocalDatasource.getETHBalance()).thenReturn(testBalance);

        // When
        final result = await repository.getETHBalance(testAddress);

        // Then
        expect(result, testBalance);
        expect(result.isFromRemote, false);
        verify(() => mockLocalDatasource.hasBalanceData()).called(1);
        verify(() => mockLocalDatasource.isBalanceDataFresh()).called(1);
        verify(() => mockLocalDatasource.getETHBalance()).called(1);
        verifyNever(() => mockRemoteDatasource.getETHBalance(any()));
      });

      test('should return local balance when available but not fresh', () async {
        // Given
        final remoteBalance = EthBalanceModel(
          balance: '0x9876543210fedcba',
          jsonrpc: '2.0',
          id: 1,
          isFromRemote: true,
        );

        when(() => mockLocalDatasource.hasBalanceData()).thenReturn(true);
        when(() => mockLocalDatasource.isBalanceDataFresh()).thenReturn(false);
        when(
          () => mockRemoteDatasource.getETHBalance(testAddress),
        ).thenAnswer((_) async => remoteBalance);
        when(
          () => mockLocalDatasource.saveETHBalance(any()),
        ).thenAnswer((_) async => true);

        // When
        final result = await repository.getETHBalance(testAddress);

        // Then
        expect(result, remoteBalance);
        expect(result.isFromRemote, true);
        verify(() => mockLocalDatasource.hasBalanceData()).called(1);
        verify(() => mockLocalDatasource.isBalanceDataFresh()).called(1);
        verify(() => mockRemoteDatasource.getETHBalance(testAddress)).called(1);
        verify(
          () => mockLocalDatasource.saveETHBalance(remoteBalance),
        ).called(1);
      });

      test('should fetch from remote when no local balance exists', () async {
        // Given
        final remoteBalance = EthBalanceModel(
          balance: '0x9876543210fedcba',
          jsonrpc: '2.0',
          id: 1,
          isFromRemote: true,
        );

        when(() => mockLocalDatasource.hasBalanceData()).thenReturn(false);
        when(
          () => mockRemoteDatasource.getETHBalance(testAddress),
        ).thenAnswer((_) async => remoteBalance);
        when(
          () => mockLocalDatasource.saveETHBalance(any()),
        ).thenAnswer((_) async => true);

        // When
        final result = await repository.getETHBalance(testAddress);

        // Then
        expect(result, remoteBalance);
        expect(result.isFromRemote, true);
        verify(() => mockLocalDatasource.hasBalanceData()).called(1);
        verifyNever(() => mockLocalDatasource.isBalanceDataFresh());
        verify(() => mockRemoteDatasource.getETHBalance(testAddress)).called(1);
        verify(
          () => mockLocalDatasource.saveETHBalance(remoteBalance),
        ).called(1);
      });

      test('should fetch from remote when local balance is null', () async {
        // Given
        final remoteBalance = EthBalanceModel(
          balance: '0x9876543210fedcba',
          jsonrpc: '2.0',
          id: 1,
          isFromRemote: true,
        );

        when(() => mockLocalDatasource.hasBalanceData()).thenReturn(true);
        when(() => mockLocalDatasource.isBalanceDataFresh()).thenReturn(true);
        when(() => mockLocalDatasource.getETHBalance()).thenReturn(null);
        when(
          () => mockRemoteDatasource.getETHBalance(testAddress),
        ).thenAnswer((_) async => remoteBalance);
        when(
          () => mockLocalDatasource.saveETHBalance(any()),
        ).thenAnswer((_) async => true);

        // When
        final result = await repository.getETHBalance(testAddress);

        // Then
        expect(result, remoteBalance);
        expect(result.isFromRemote, true);
        verify(() => mockLocalDatasource.hasBalanceData()).called(1);
        verify(() => mockLocalDatasource.isBalanceDataFresh()).called(1);
        verify(() => mockLocalDatasource.getETHBalance()).called(1);
        verify(() => mockRemoteDatasource.getETHBalance(testAddress)).called(1);
        verify(
          () => mockLocalDatasource.saveETHBalance(remoteBalance),
        ).called(1);
      });

      test('should propagate remote datasource exceptions', () async {
          // Given
        when(() => mockLocalDatasource.hasBalanceData()).thenReturn(false);
        when(
          () => mockRemoteDatasource.getETHBalance(testAddress),
        ).thenThrow(Exception('Network error'));

        // When & Then
        expect(
          () => repository.getETHBalance(testAddress),
          throwsA(isA<Exception>()),
        );

        verify(() => mockLocalDatasource.hasBalanceData()).called(1);
        verify(() => mockRemoteDatasource.getETHBalance(testAddress)).called(1);
        verifyNever(() => mockLocalDatasource.saveETHBalance(any()));
      });

      test('should handle save failure', () async {
        // Given
        final remoteBalance = EthBalanceModel(
          balance: '0x9876543210fedcba',
          jsonrpc: '2.0',
          id: 1,
          isFromRemote: true,
        );

        when(() => mockLocalDatasource.hasBalanceData()).thenReturn(false);
        when(
          () => mockRemoteDatasource.getETHBalance(testAddress),
        ).thenAnswer((_) async => remoteBalance);
        when(
          () => mockLocalDatasource.saveETHBalance(any()),
        ).thenAnswer((_) async => false);

        // When
        final result = await repository.getETHBalance(testAddress);

        // Then
        expect(result, remoteBalance);
        expect(result.isFromRemote, true);
        verify(
          () => mockLocalDatasource.saveETHBalance(remoteBalance),
        ).called(1);
      });
    });
  });
}
