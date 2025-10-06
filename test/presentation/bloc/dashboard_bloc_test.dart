import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet/core/exception/app_exception.dart';
import 'package:web3_wallet/domain/entities/eth_balance_entity.dart';
import 'package:web3_wallet/domain/entities/tokens_entity.dart';
import 'package:web3_wallet/domain/usecases/wallet_address_usecase.dart';
import 'package:web3_wallet/domain/usecases/wallet_usecase.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_bloc.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_event.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_state.dart';

import '../../domain/entities/wallet_overview_entity_mock.dart';

class MockWalletOverviewUsecase extends Mock implements WalletUsecase {}

class MockWalletAddressUsecase extends Mock implements WalletAddressUsecase {}

class FakeEthBalanceEntity extends Fake implements EthBalanceEntity {}

void main() {
  group('DashboardBloc', () {
    late DashboardBloc dashboardBloc;
    late MockWalletOverviewUsecase mockWalletOverviewUsecase;
    late MockWalletAddressUsecase mockWalletAddressUsecase;

    setUpAll(() {
      registerFallbackValue(FakeEthBalanceEntity());
    });

    setUp(() {
      mockWalletOverviewUsecase = MockWalletOverviewUsecase();
      mockWalletAddressUsecase = MockWalletAddressUsecase();
      dashboardBloc = DashboardBloc(
        mockWalletOverviewUsecase,
        mockWalletAddressUsecase,
      );
    });

    tearDown(() {
      dashboardBloc.close();
    });

    group('GetWalletDataEvent', () {
      const testAddress = '0x1234567890abcdef1234567890abcdef12345678';
      const testBalance = '0x1bc16d674ec80000';
      final testTokens = [
        TokensEntity(
          contractAddress: '0x1234567890abcdef1234567890abcdef12345678',
          symbol: 'USDC',
          name: 'USD Coin',
          balance: '0x1dcd6500',
          decimals: 6,
        ),
        TokensEntity(
          contractAddress: '0x9876543210fedcba9876543210fedcba98765432',
          symbol: 'WBTC',
          name: 'Wrapped Bitcoin',
          balance: '0x989680',
          decimals: 8,
        ),
      ];

      blocTest(
        'should emit [DashboardLoading, DashboardLoaded] when successful',
        build: () {
          when(
            () => mockWalletAddressUsecase.getWalletAddress(),
          ).thenAnswer((_) async => testAddress);
          when(
            () => mockWalletOverviewUsecase.getETHBalance(testAddress),
          ).thenAnswer((_) async => EthBalanceEntity(balance: testBalance));
          when(
            () => mockWalletOverviewUsecase.getErc20Tokens(testAddress),
          ).thenAnswer((_) async => testTokens);
          return dashboardBloc;
        },
        act: (bloc) => bloc.add(const GetWalletDataEvent()),
        expect: () => [
          isA<DashboardLoading>(),
          isA<DashboardLoaded>()
              .having((state) => state.address, 'address', testAddress)
              .having(
                (state) => state.walletOverview.ethBalance,
                'ethBalance',
                walletOverviewEntityMock.ethBalance,
              )
              .having(
                (state) => state.walletOverview.totalValue,
                'totalValue',
                9089.5,
              )
              .having(
                (state) => state.tokens[0].balance,
                'firstTokenBalance',
                500.0,
              )
              .having(
                (state) => state.tokens[0].usdValue,
                'firstTokenUsdValue',
                500.0,
              )
              .having(
                (state) => state.tokens[1].symbol,
                'secondTokenSymbol',
                'WBTC',
              )
              .having(
                (state) => state.tokens[1].name,
                'secondTokenName',
                'Wrapped Bitcoin',
              )
              .having(
                (state) => state.tokens[1].balance,
                'secondTokenBalance',
                0.1,
              )
              .having(
                (state) => state.tokens[1].usdValue,
                'secondTokenUsdValue',
                9500.0,
              ),
        ],
        verify: (_) {
          verify(() => mockWalletAddressUsecase.getWalletAddress()).called(1);
          verify(
            () => mockWalletOverviewUsecase.getETHBalance(testAddress),
          ).called(1);
          verify(
            () => mockWalletOverviewUsecase.getErc20Tokens(testAddress),
          ).called(1);
        },
      );

      blocTest(
        'should emit [DashboardLoading, DashboardError] when got exception',
        build: () {
          when(
            () => mockWalletAddressUsecase.getWalletAddress(),
          ).thenAnswer((_) async => testAddress);
          when(
            () => mockWalletOverviewUsecase.getETHBalance(testAddress),
          ).thenThrow(LocalStorageException('Local storage error'));
          return dashboardBloc;
        },
        act: (bloc) => bloc.add(const GetWalletDataEvent()),
        expect: () => [
          isA<DashboardLoading>(),
          isA<DashboardError>().having(
            (state) => state.message,
            'message',
            'Local storage error',
          ),
        ],
        verify: (_) {
          verify(() => mockWalletAddressUsecase.getWalletAddress()).called(1);
          verify(
            () => mockWalletOverviewUsecase.getETHBalance(testAddress),
          ).called(1);
        },
      );

      blocTest(
        'should handle token fetch error correctly',
        build: () {
          when(
            () => mockWalletAddressUsecase.getWalletAddress(),
          ).thenAnswer((_) async => testAddress);
          when(
            () => mockWalletOverviewUsecase.getETHBalance(testAddress),
          ).thenAnswer((_) async => EthBalanceEntity(balance: testBalance));
          when(
            () => mockWalletOverviewUsecase.getErc20Tokens(testAddress),
          ).thenThrow(Exception('Failed to fetch tokens'));
          return dashboardBloc;
        },
        act: (bloc) => bloc.add(const GetWalletDataEvent()),
        expect: () => [
          isA<DashboardLoading>(),
          isA<DashboardError>().having(
            (state) => state.message,
            'message',
            'Exception: Failed to fetch tokens',
          ),
        ],
        verify: (_) {
          verify(() => mockWalletAddressUsecase.getWalletAddress()).called(1);
          verify(
            () => mockWalletOverviewUsecase.getETHBalance(testAddress),
          ).called(1);
          verify(
            () => mockWalletOverviewUsecase.getErc20Tokens(testAddress),
          ).called(1);
        },
      );

      blocTest(
        'should handle wallet address fetch error correctly',
        build: () {
          when(
            () => mockWalletAddressUsecase.getWalletAddress(),
          ).thenThrow(LocalStorageException('Failed to get wallet address'));
          return dashboardBloc;
        },
        act: (bloc) => bloc.add(const GetWalletDataEvent()),
        expect: () => [
          isA<DashboardLoading>(),
          isA<DashboardError>().having(
            (state) => state.message,
            'message',
            'Failed to get wallet address',
          ),
        ],
        verify: (_) {
          verify(() => mockWalletAddressUsecase.getWalletAddress()).called(1);
        },
      );

      blocTest(
        'should handle ETH balance fetch error correctly',
        build: () {
          when(
            () => mockWalletAddressUsecase.getWalletAddress(),
          ).thenAnswer((_) async => testAddress);
          when(
            () => mockWalletOverviewUsecase.getETHBalance(testAddress),
          ).thenThrow(LocalStorageException('Failed to fetch ETH balance'));
          return dashboardBloc;
        },
        act: (bloc) => bloc.add(const GetWalletDataEvent()),
        expect: () => [
          isA<DashboardLoading>(),
          isA<DashboardError>().having(
            (state) => state.message,
            'message',
            'Failed to fetch ETH balance',
          ),
        ],
        verify: (_) {
          verify(() => mockWalletAddressUsecase.getWalletAddress()).called(1);
          verify(
            () => mockWalletOverviewUsecase.getETHBalance(testAddress),
          ).called(1);
        },
      );
    });
  });
}
