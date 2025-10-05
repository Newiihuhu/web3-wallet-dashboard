import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet_dashboard/data/models/eth_balance_model.dart';
import 'package:web3_wallet_dashboard/data/repositories/wallet_overview_repository_impl.dart';
import 'package:web3_wallet_dashboard/domain/entities/eth_balance_entity.dart';

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

      test('should return cached data when available and fresh', () async {
        // Arrange
        when(() => mockLocalDatasource.hasBalanceData()).thenReturn(true);
        when(() => mockLocalDatasource.isBalanceDataFresh()).thenReturn(true);
        when(() => mockLocalDatasource.getETHBalance()).thenReturn(testBalance);

        // Act
        final result = await repository.getETHBalance(testAddress);

        // Assert
        expect(result, testBalance);
        expect(result.isFromRemote, false);
        verify(() => mockLocalDatasource.hasBalanceData()).called(1);
        verify(() => mockLocalDatasource.isBalanceDataFresh()).called(1);
        verify(() => mockLocalDatasource.getETHBalance()).called(1);
        verifyNever(() => mockRemoteDatasource.getETHBalance(any()));
      });

      test('should return cached data when available but not fresh', () async {
        // Arrange
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

        // Act
        final result = await repository.getETHBalance(testAddress);

        // Assert
        expect(result, remoteBalance);
        expect(result.isFromRemote, true);
        verify(() => mockLocalDatasource.hasBalanceData()).called(1);
        verify(() => mockLocalDatasource.isBalanceDataFresh()).called(1);
        verify(() => mockRemoteDatasource.getETHBalance(testAddress)).called(1);
        verify(
          () => mockLocalDatasource.saveETHBalance(remoteBalance),
        ).called(1);
      });

      test('should fetch from remote when no cached data exists', () async {
        // Arrange
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

        // Act
        final result = await repository.getETHBalance(testAddress);

        // Assert
        expect(result, remoteBalance);
        expect(result.isFromRemote, true);
        verify(() => mockLocalDatasource.hasBalanceData()).called(1);
        verifyNever(() => mockLocalDatasource.isBalanceDataFresh());
        verify(() => mockRemoteDatasource.getETHBalance(testAddress)).called(1);
        verify(
          () => mockLocalDatasource.saveETHBalance(remoteBalance),
        ).called(1);
      });

      test('should fetch from remote when cached data is null', () async {
        // Arrange
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

        // Act
        final result = await repository.getETHBalance(testAddress);

        // Assert
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
        // Arrange
        when(() => mockLocalDatasource.hasBalanceData()).thenReturn(false);
        when(
          () => mockRemoteDatasource.getETHBalance(testAddress),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => repository.getETHBalance(testAddress),
          throwsA(isA<Exception>()),
        );

        verify(() => mockLocalDatasource.hasBalanceData()).called(1);
        verify(() => mockRemoteDatasource.getETHBalance(testAddress)).called(1);
        verifyNever(() => mockLocalDatasource.saveETHBalance(any()));
      });

      test('should handle save failure gracefully', () async {
        // Arrange
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

        // Act
        final result = await repository.getETHBalance(testAddress);

        // Assert
        expect(result, remoteBalance);
        expect(result.isFromRemote, true);
        verify(
          () => mockLocalDatasource.saveETHBalance(remoteBalance),
        ).called(1);
      });
    });

    group('Integration scenarios', () {
      const testAddress = '0x1234567890abcdef';

      test(
        'should handle complete flow: no cache -> fetch -> save -> return',
        () async {
          // Arrange
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

          // Act
          final result = await repository.getETHBalance(testAddress);

          // Assert
          expect(result, remoteBalance);
          expect(result.isFromRemote, true);

          // Verify the complete flow
          verify(() => mockLocalDatasource.hasBalanceData()).called(1);
          verify(
            () => mockRemoteDatasource.getETHBalance(testAddress),
          ).called(1);
          verify(
            () => mockLocalDatasource.saveETHBalance(remoteBalance),
          ).called(1);
        },
      );

      test(
        'should handle complete flow: fresh cache -> return cached data',
        () async {
          // Arrange
          final cachedBalance = EthBalanceEntity(
            balance: '0x1234567890abcdef',
            lastUpdated: DateTime.now(),
            isFromRemote: false,
          );

          when(() => mockLocalDatasource.hasBalanceData()).thenReturn(true);
          when(() => mockLocalDatasource.isBalanceDataFresh()).thenReturn(true);
          when(
            () => mockLocalDatasource.getETHBalance(),
          ).thenReturn(cachedBalance);

          // Act
          final result = await repository.getETHBalance(testAddress);

          // Assert
          expect(result, cachedBalance);
          expect(result.isFromRemote, false);

          // Verify the complete flow
          verify(() => mockLocalDatasource.hasBalanceData()).called(1);
          verify(() => mockLocalDatasource.isBalanceDataFresh()).called(1);
          verify(() => mockLocalDatasource.getETHBalance()).called(1);
          verifyNever(() => mockRemoteDatasource.getETHBalance(any()));
          verifyNever(() => mockLocalDatasource.saveETHBalance(any()));
        },
      );
    });
  });
}
