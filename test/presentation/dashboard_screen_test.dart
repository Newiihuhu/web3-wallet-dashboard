import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet/core/injection/service_locator.dart';
import 'package:web3_wallet/domain/entities/tokens_overview_entity.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_bloc.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_event.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_state.dart';
import 'package:web3_wallet/presentation/dashboard_screen.dart';
import 'package:web3_wallet/presentation/widgets/dashboard_appbar_widget.dart';
import 'package:web3_wallet/presentation/widgets/dashboard_error_widget.dart';
import 'package:web3_wallet/presentation/widgets/dashboard_loading_widget.dart';
import 'package:web3_wallet/presentation/widgets/tokens_list_widget.dart';
import 'package:web3_wallet/presentation/widgets/wallet_address_widget.dart';
import 'package:web3_wallet/presentation/widgets/wallet_overview_widget.dart';

import '../domain/entities/wallet_overview_entity_mock.dart';
import 'bloc/__mock__/dashboard_bloc_mock.dart';

void main() {
  group('DashboardScreen', () {
    late MockDashboardBloc mockDashboardBloc;

    setUp(() {
      mockDashboardBloc = MockDashboardBloc();
      if (getIt.isRegistered<DashboardBloc>()) {
        getIt.unregister<DashboardBloc>();
      }
      getIt.registerFactory<DashboardBloc>(() => mockDashboardBloc);
    });

    tearDown(() {
      mockDashboardBloc.close();
      if (getIt.isRegistered<DashboardBloc>()) {
        getIt.unregister<DashboardBloc>();
      }
    });

    Widget prepareWidget() {
      return MaterialApp(home: const DashboardScreen());
    }

    group('Initial State', () {
      testWidgets(
        'should dispatch GetWalletDataEvent on init and display scaffold with app bar',
        (WidgetTester tester) async {
          // Given
          when(
            () => mockDashboardBloc.state,
          ).thenReturn(const DashboardInitial());

          // When
          await tester.pumpWidget(prepareWidget());

          // Then
          expect(find.byType(Scaffold), findsOneWidget);
          expect(find.byType(AppBar), findsOneWidget);
          expect(find.byType(DashboardAppbarWidget), findsOneWidget);
          expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
          verify(
            () => mockDashboardBloc.add(const GetWalletDataEvent()),
          ).called(1);
        },
      );
    });

    group('Loading State', () {
      testWidgets(
        'should display loading widget when state is DashboardLoading',
        (WidgetTester tester) async {
          // Given
          when(
            () => mockDashboardBloc.state,
          ).thenReturn(const DashboardLoading());

          // When
          await tester.pumpWidget(prepareWidget());

          // Then
          expect(find.byType(DashboardLoadingWidget), findsOneWidget);
          expect(
            find.byType(BlocBuilder<DashboardBloc, DashboardState>),
            findsOneWidget,
          );
        },
      );
    });

    group('Error State', () {
      testWidgets('should display error widget when state is DashboardError', (
        WidgetTester tester,
      ) async {
        // Given
        const errorMessage = 'Something went wrong';
        when(
          () => mockDashboardBloc.state,
        ).thenReturn(const DashboardError(message: errorMessage));

        // When
        await tester.pumpWidget(prepareWidget());

        // Then
        expect(find.byType(DashboardErrorWidget), findsOneWidget);
        expect(
          find.byType(BlocBuilder<DashboardBloc, DashboardState>),
          findsOneWidget,
        );
      });
      testWidgets('should dispatch GetWalletDataEvent on refresh', (
        WidgetTester tester,
      ) async {
        // Given
        when(
          () => mockDashboardBloc.state,
        ).thenReturn(const DashboardError(message: 'Error'));

        // When
        await tester.pumpWidget(prepareWidget());
        await tester.tap(find.byType(ElevatedButton));

        // Then
        verify(
          () => mockDashboardBloc.add(const GetWalletDataEvent()),
        ).called(2);
      });
    });

    group('Loaded State', () {
      testWidgets('should display all widgets when state is DashboardLoaded', (
        WidgetTester tester,
      ) async {
        // Given
        const testAddress = '0x1234567890abcdef1234567890abcdef12345678';
        final testTokens = [
          TokensOverviewEntity(
            symbol: 'USDT',
            name: 'Tether USD',
            balance: 1000.0,
            usdValue: 1000.0,
          ),
          TokensOverviewEntity(
            symbol: 'USDC',
            name: 'USD Coin',
            balance: 500.0,
            usdValue: 500.0,
          ),
        ];

        when(() => mockDashboardBloc.state).thenReturn(
          DashboardLoaded(
            address: testAddress,
            walletOverview: walletOverviewEntityMock,
            tokens: testTokens,
          ),
        );

        // When
        await tester.pumpWidget(prepareWidget());

        // Then
        expect(find.byType(WalletAddressWidget), findsOneWidget);
        expect(find.byType(WalletOverviewWidget), findsOneWidget);
        expect(find.byType(TokensListWidget), findsOneWidget);
      });

      testWidgets('should display correct data in loaded state', (
        WidgetTester tester,
      ) async {
        // Given
        const testAddress = '0x1234567890abcdef1234567890abcdef12345678';
        final testTokens = [
          TokensOverviewEntity(
            symbol: 'USDT',
            name: 'Tether USD',
            balance: 1000.0,
            usdValue: 1000.0,
          ),
        ];

        when(() => mockDashboardBloc.state).thenReturn(
          DashboardLoaded(
            address: testAddress,
            walletOverview: walletOverviewEntityMock,
            tokens: testTokens,
          ),
        );

        // When
        await tester.pumpWidget(prepareWidget());

        // Then
        final walletAddressWidget = tester.widget<WalletAddressWidget>(
          find.byType(WalletAddressWidget),
        );
        final walletOverviewWidget = tester.widget<WalletOverviewWidget>(
          find.byType(WalletOverviewWidget),
        );
        final tokensListWidget = tester.widget<TokensListWidget>(
          find.byType(TokensListWidget),
        );

        expect(walletAddressWidget.address, testAddress);
        expect(walletOverviewWidget.walletOverview, walletOverviewEntityMock);
        expect(tokensListWidget.tokens, testTokens);
      });
    });
  });
}
