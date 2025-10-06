import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet/data/models/eth_balance_model.dart';
import 'package:web3_wallet/data/models/token_metadata_model.dart';
import 'package:web3_wallet/data/models/tokens_list_model.dart';
import 'package:web3_wallet/data/repositories/wallet_repository_impl.dart';
import 'package:web3_wallet/domain/entities/eth_balance_entity.dart';
import 'package:web3_wallet/domain/entities/tokens_entity.dart';

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
        verify(() => mockRemoteDatasource.getETHBalance(testAddress)).called(1);
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
        verify(() => mockRemoteDatasource.getETHBalance(testAddress)).called(1);
      });
    });

    group('getErc20Tokens', () {
      const testAddress = '0x1234567890abcdef';
      final testTokens = [
        TokensEntity(
          contractAddress: '0x1234',
          symbol: 'ETH',
          name: 'Ethereum',
          balance: '0x8ac7230489e80000',
          decimals: 18,
        ),
      ];

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
          verify(
            () => mockRemoteDatasource.getTokenBalances(testAddress),
          ).called(1);
        },
      );

      test('should return local tokens when data is exists', () async {
        // Given
        when(() => mockTokensLocalDatasource.hasTokensData()).thenReturn(true);
        when(
          () => mockTokensLocalDatasource.getTokens(),
        ).thenReturn(testTokens);

        // When
        final result = await repository.getErc20Tokens(testAddress);

        // Then
        expect(result, testTokens);
        verify(() => mockTokensLocalDatasource.hasTokensData()).called(1);
        verify(() => mockTokensLocalDatasource.getTokens()).called(1);
        verifyNever(() => mockRemoteDatasource.getTokenBalances(testAddress));
        verifyNever(() => mockTokensLocalDatasource.saveTokens(any()));
      });

      test('should fetch from remote when local data is null', () async {
        // Given
        when(() => mockTokensLocalDatasource.hasTokensData()).thenReturn(false);
        when(() => mockTokensLocalDatasource.getTokens()).thenReturn(null);
        when(
          () => mockRemoteDatasource.getTokenBalances(testAddress),
        ).thenAnswer(
          (_) async => TokensListModel(
            jsonrpc: '2.0',
            id: 1,
            result: TokensResultModel(
              address: testAddress,
              tokenBalances: [
                TokenBalanceModel(
                  contractAddress: '0x0000000000000000000000000000000000000002',
                  tokenBalance: '0x1234567890abcdef',
                ),
              ],
            ),
          ),
        );
        when(() => mockRemoteDatasource.getTokenMetadata(any())).thenAnswer(
          (_) async => TokenMetadataModel(
            jsonrpc: '2.0',
            id: 1,
            result: TokenMetadataResultModel(
              symbol: 'TEST',
              name: 'Test Token',
              decimals: 18,
            ),
          ),
        );
        when(
          () => mockTokensLocalDatasource.saveTokens(any()),
        ).thenAnswer((_) async => true);

        // When
        final result = await repository.getErc20Tokens(testAddress);

        // Then
        expect(result, hasLength(1));
        expect(
          result.first.contractAddress,
          '0x0000000000000000000000000000000000000002',
        );
        expect(result.first.balance, '0x1234567890abcdef');
        verify(
          () => mockRemoteDatasource.getTokenBalances(testAddress),
        ).called(1);
      });

      test('should filter out tokens with zero balance', () async {
        // Given
        when(() => mockTokensLocalDatasource.hasTokensData()).thenReturn(false);
        when(
          () => mockRemoteDatasource.getTokenBalances(testAddress),
        ).thenAnswer(
          (_) async => TokensListModel(
            jsonrpc: '2.0',
            id: 1,
            result: TokensResultModel(
              address: testAddress,
              tokenBalances: [
                TokenBalanceModel(
                  contractAddress: '0x0000000000000000000000000000000000000001',
                  tokenBalance: '0x0',
                ),
                TokenBalanceModel(
                  contractAddress: '0x0000000000000000000000000000000000000002',
                  tokenBalance: '0x1234567890abcdef',
                ),
                TokenBalanceModel(
                  contractAddress: '0x0000000000000000000000000000000000000003',
                  tokenBalance: '0x0',
                ),
              ],
            ),
          ),
        );
        when(() => mockRemoteDatasource.getTokenMetadata(any())).thenAnswer(
          (_) async => TokenMetadataModel(
            jsonrpc: '2.0',
            id: 1,
            result: TokenMetadataResultModel(
              symbol: 'TEST',
              name: 'Test Token',
              decimals: 18,
            ),
          ),
        );
        when(
          () => mockTokensLocalDatasource.saveTokens(any()),
        ).thenAnswer((_) async => true);

        // When
        final result = await repository.getErc20Tokens(testAddress);

        // Then
        expect(result, hasLength(1));
        expect(
          result.first.contractAddress,
          '0x0000000000000000000000000000000000000002',
        );
        expect(result.first.balance, '0x1234567890abcdef');

        verify(() => mockTokensLocalDatasource.hasTokensData()).called(1);
        verify(
          () => mockRemoteDatasource.getTokenBalances(testAddress),
        ).called(1);
      });

      test(
        'should return empty list when all tokens have zero balance',
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
                tokenBalances: [
                  TokenBalanceModel(
                    contractAddress:
                        '0x0000000000000000000000000000000000000001',
                    tokenBalance: '0x0',
                  ),
                  TokenBalanceModel(
                    contractAddress:
                        '0x0000000000000000000000000000000000000002',
                    tokenBalance: '0x0',
                  ),
                ],
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
          verifyNever(() => mockRemoteDatasource.getTokenMetadata(any()));
          verify(() => mockTokensLocalDatasource.saveTokens([])).called(1);
        },
      );
    });
  });
}
