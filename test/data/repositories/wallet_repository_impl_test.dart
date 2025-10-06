import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet/core/exception/app_exception.dart';
import 'package:web3_wallet/data/models/eth_balance_model.dart';
import 'package:web3_wallet/data/models/tokens_list_model.dart';
import 'package:web3_wallet/data/repositories/wallet_repository_impl.dart';
import 'package:web3_wallet/domain/entities/eth_balance_entity.dart';

import '../datasource/local/__mock__/tokens_local_datasource_mock.dart';
import '../datasource/local/__mock__/wallet_overview_local_datasource_mock.dart';
import '../datasource/remote/__mock__/wallet_remote_datasource_mock.dart';

class FakeEthBalanceEntity extends Fake implements EthBalanceEntity {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeEthBalanceEntity());
  });
  group('WalletOverviewRepositoryImpl', () {
    late WalletRepositoryImpl repository;
    late MockWalletRemoteDatasource mockRemoteDatasource;
    late MockWalletOverviewLocalDatasource mockLocalDatasource;
    late MockTokensLocalDatasource mockTokensLocalDatasource;

    setUp(() {
      mockRemoteDatasource = MockWalletRemoteDatasource();
      mockLocalDatasource = MockWalletOverviewLocalDatasource();
      mockTokensLocalDatasource = MockTokensLocalDatasource();
      repository = WalletRepositoryImpl(
        mockRemoteDatasource,
        mockLocalDatasource,
        mockTokensLocalDatasource,
      );
    });

    group('getETHBalance', () {
      const testAddress = '0x1234567890abcdef';
      final testBalance = EthBalanceEntity(balance: '0x1234567890abcdef');

      test('should return local balance when data is exists', () async {
        // Given
        when(() => mockLocalDatasource.hasBalanceData()).thenReturn(true);
        when(() => mockLocalDatasource.getETHBalance()).thenReturn(testBalance);

        // When
        final result = await repository.getETHBalance(testAddress);

        // Then
        expect(result, testBalance);
        verify(() => mockLocalDatasource.hasBalanceData()).called(1);
        verify(() => mockLocalDatasource.getETHBalance()).called(1);
        verifyNever(() => mockRemoteDatasource.getETHBalance(any()));
      });

      test('should fetch from remote when local balance is empty', () async {
        // Given
        final remoteBalance = EthBalanceModel(
          balance: '0x9876543210fedcba',
          jsonrpc: '2.0',
          id: 1,
        );

        when(() => mockLocalDatasource.hasBalanceData()).thenReturn(true);
        when(
          () => mockLocalDatasource.getETHBalance(),
        ).thenReturn(EthBalanceEntity(balance: ''));
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
        verify(() => mockLocalDatasource.hasBalanceData()).called(1);
        verify(() => mockLocalDatasource.getETHBalance()).called(1);
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
        );

        when(() => mockLocalDatasource.hasBalanceData()).thenReturn(true);
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
        verify(() => mockLocalDatasource.hasBalanceData()).called(1);
        verify(() => mockLocalDatasource.getETHBalance()).called(1);
        verify(() => mockRemoteDatasource.getETHBalance(testAddress)).called(1);
        verify(
          () => mockLocalDatasource.saveETHBalance(remoteBalance),
        ).called(1);
      });

      test(
        'should throw LocalStorageException when save balance fails',
        () async {
          // Given
          final remoteBalance = EthBalanceModel(
            balance: '0x9876543210fedcba',
            jsonrpc: '2.0',
            id: 1,
          );

          when(() => mockLocalDatasource.hasBalanceData()).thenReturn(false);
          when(
            () => mockRemoteDatasource.getETHBalance(testAddress),
          ).thenAnswer((_) async => remoteBalance);
          when(
            () => mockLocalDatasource.saveETHBalance(any()),
          ).thenThrow(LocalStorageException('Local storage error'));

          // When & Then
          expect(
            () => repository.getETHBalance(testAddress),
            throwsA(isA<LocalStorageException>()),
          );

          verify(() => mockLocalDatasource.hasBalanceData()).called(1);
          verify(
            () => mockRemoteDatasource.getETHBalance(testAddress),
          ).called(1);
          verifyNever(() => mockLocalDatasource.saveETHBalance(any()));
        },
      );
      test(
        'should throw LocalStorageException when get balance fails',
        () async {
          // Given
          when(() => mockLocalDatasource.hasBalanceData()).thenReturn(true);

          when(
            () => mockLocalDatasource.getETHBalance(),
          ).thenThrow(LocalStorageException('Local storage error'));

          // When & Then
          expect(
            () => repository.getETHBalance(testAddress),
            throwsA(isA<LocalStorageException>()),
          );

          verify(() => mockLocalDatasource.hasBalanceData()).called(1);
          verify(() => mockLocalDatasource.getETHBalance()).called(1);
        },
      );
    });

    group('getErc20Tokens', () {
      const testAddress = '0x1234567890abcdef';

      test(
        'should return empty list when no local data and no remote tokens',
        () async {
          // Given
          when(
            () => mockTokensLocalDatasource.hasTokensData(),
          ).thenReturn(false);
          when(
            () => mockRemoteDatasource.getTokenBalances(testAddress),
          ).thenAnswer(
            (_) async => TokensListModel(
              jsonrpc: '2.0',
              id: 1,
              result: TokensResultModel(
                address: testAddress,
                tokenBalances: [],
              ),
            ),
          );
          when(
            () => mockTokensLocalDatasource.saveTokens(any()),
          ).thenAnswer((_) async => true);

          // When
          final result = await repository.getErc20Tokens(testAddress);

          // Then
          expect(result, isEmpty);
          verify(() => mockTokensLocalDatasource.hasTokensData()).called(1);
          verify(
            () => mockRemoteDatasource.getTokenBalances(testAddress),
          ).called(1);
          verify(() => mockTokensLocalDatasource.saveTokens([])).called(1);
        },
      );

      test(
        'should return empty list when local data exists but is empty',
        () async {
          // Given
          when(
            () => mockTokensLocalDatasource.hasTokensData(),
          ).thenReturn(true);
          when(() => mockTokensLocalDatasource.getTokens()).thenReturn([]);
          when(
            () => mockRemoteDatasource.getTokenBalances(testAddress),
          ).thenAnswer(
            (_) async => TokensListModel(
              jsonrpc: '2.0',
              id: 1,
              result: TokensResultModel(
                address: testAddress,
                tokenBalances: [], // Empty token list
              ),
            ),
          );
          when(
            () => mockTokensLocalDatasource.saveTokens(any()),
          ).thenAnswer((_) async => true);

          // When
          final result = await repository.getErc20Tokens(testAddress);

          // Then
          expect(result, isEmpty);
          verify(() => mockTokensLocalDatasource.hasTokensData()).called(1);
          verify(() => mockTokensLocalDatasource.getTokens()).called(1);
          verify(
            () => mockRemoteDatasource.getTokenBalances(testAddress),
          ).called(1);
          verify(() => mockTokensLocalDatasource.saveTokens([])).called(1);
        },
      );

      test('should return empty list when local data is null', () async {
        // Given
        when(() => mockTokensLocalDatasource.hasTokensData()).thenReturn(true);
        when(() => mockTokensLocalDatasource.getTokens()).thenReturn(null);
        when(
          () => mockRemoteDatasource.getTokenBalances(testAddress),
        ).thenAnswer(
          (_) async => TokensListModel(
            jsonrpc: '2.0',
            id: 1,
            result: TokensResultModel(
              address: testAddress,
              tokenBalances: [], // Empty token list
            ),
          ),
        );
        when(
          () => mockTokensLocalDatasource.saveTokens(any()),
        ).thenAnswer((_) async => true);

        // When
        final result = await repository.getErc20Tokens(testAddress);

        // Then
        expect(result, isEmpty);
        verify(() => mockTokensLocalDatasource.hasTokensData()).called(1);
        verify(() => mockTokensLocalDatasource.getTokens()).called(1);
        verify(
          () => mockRemoteDatasource.getTokenBalances(testAddress),
        ).called(1);
        verify(() => mockTokensLocalDatasource.saveTokens([])).called(1);
      });

      test('should handle remote datasource exception', () async {
        // Given
        when(() => mockTokensLocalDatasource.hasTokensData()).thenReturn(false);
        when(
          () => mockRemoteDatasource.getTokenBalances(testAddress),
        ).thenThrow(Exception('Network error'));

        // When & Then
        expect(
          () => repository.getErc20Tokens(testAddress),
          throwsA(isA<Exception>()),
        );

        verify(() => mockTokensLocalDatasource.hasTokensData()).called(1);
        verify(
          () => mockRemoteDatasource.getTokenBalances(testAddress),
        ).called(1);
        verifyNever(() => mockTokensLocalDatasource.saveTokens(any()));
      });
    });
  });
}
