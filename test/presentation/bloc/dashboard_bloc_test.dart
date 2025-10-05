import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet/domain/entities/eth_balance_entity.dart';
import 'package:web3_wallet/domain/usecases/wallet_address_usecase.dart';
import 'package:web3_wallet/domain/usecases/wallet_overview_usecase.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_bloc.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_event.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_state.dart';

import '../../domain/entities/wallet_overview_entity_mock.dart';

class MockWalletOverviewUsecase extends Mock implements WalletOverviewUsecase {}

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

    group('Initial State', () {
      test('should have initial state as DashboardInitial', () {
        expect(dashboardBloc.state, isA<DashboardInitial>());
      });
    });

    group('GetEthBalanceEvent', () {
      const testAddress = '0x1234567890abcdef1234567890abcdef12345678';
      const testBalance = '0x1bc16d674ec80000';

      blocTest(
        'should emit [DashboardLoading, DashboardLoaded] when successful',
        build: () => dashboardBloc,
        act: (bloc) async {
          when(
            () => mockWalletAddressUsecase.getWalletAddress(),
          ).thenAnswer((_) async => testAddress);
          when(
            () => mockWalletOverviewUsecase.getETHBalance(testAddress),
          ).thenAnswer(
            (_) async => EthBalanceEntity(
              balance: testBalance,
              lastUpdated: DateTime.now(),
              isFromRemote: true,
            ),
          );
          bloc.add(const GetEthBalanceEvent());
        },
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
                (state) => state.walletOverview.convertToUSD,
                'convertToUSD',
                walletOverviewEntityMock.convertToUSD,
              )
              .having(
                (state) => state.walletOverview.totalValue,
                'totalValue',
                walletOverviewEntityMock.totalValue,
              )
              .having(
                (state) => state.walletOverview.totalToken,
                'totalToken',
                walletOverviewEntityMock.totalToken,
              )
              .having((state) => state.isFromCache, 'isFromCache', false),
        ],
        verify: (_) {
          verify(() => mockWalletAddressUsecase.getWalletAddress()).called(1);
          verify(
            () => mockWalletOverviewUsecase.getETHBalance(testAddress),
          ).called(1);
        },
      );

      blocTest(
        'should emit [DashboardLoading, DashboardLoaded] with cached data',
        build: () {
          when(
            () => mockWalletAddressUsecase.getWalletAddress(),
          ).thenAnswer((_) async => testAddress);
          when(
            () => mockWalletOverviewUsecase.getETHBalance(testAddress),
          ).thenAnswer(
            (_) async => EthBalanceEntity(
              balance: testBalance,
              lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
              isFromRemote: false,
            ),
          );
          return dashboardBloc;
        },
        act: (bloc) => bloc.add(const GetEthBalanceEvent()),
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
                (state) => state.walletOverview.convertToUSD,
                'convertToUSD',
                walletOverviewEntityMock.convertToUSD,
              )
              .having(
                (state) => state.walletOverview.totalValue,
                'totalValue',
                walletOverviewEntityMock.totalValue,
              )
              .having(
                (state) => state.walletOverview.totalToken,
                'totalToken',
                walletOverviewEntityMock.totalToken,
              )
              .having((state) => state.isFromCache, 'isFromCache', true),
        ],
      );

      blocTest(
        'should emit [DashboardLoading, DashboardError] when got exception',
        build: () {
          when(
            () => mockWalletAddressUsecase.getWalletAddress(),
          ).thenAnswer((_) async => testAddress);
          when(
            () => mockWalletOverviewUsecase.getETHBalance(testAddress),
          ).thenThrow(Exception('Exception'));
          return dashboardBloc;
        },
        act: (bloc) => bloc.add(const GetEthBalanceEvent()),
        expect: () => [
          isA<DashboardLoading>(),
          isA<DashboardError>().having(
            (state) => state.message,
            'message',
            'Exception: Exception',
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
