import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet/core/exception/app_exception.dart';
import 'package:web3_wallet/data/datasources/remote/wallet_remote_datasource.dart';
import 'package:web3_wallet/data/models/eth_balance_model.dart';
import 'package:web3_wallet/data/models/token_metadata_model.dart';
import 'package:web3_wallet/data/models/tokens_list_model.dart';

import '../../model/__mock__/eth_balance_data_mock.dart';
import '../../model/__mock__/token_metadata_mock.dart';
import '../../model/__mock__/tokens_list_model_mock.dart';
import '__mock__/app_config_mock.dart';
import '__mock__/dio_mock.dart';

void main() {
  late MockDio dio;
  late WalletRemoteDatasource walletRemoteDatasource;
  late MockAppConfig appConfig;
  const expectedUrl = 'https://eth-sepolia.g.alchemy.com/v2/FAKE_KEY';
  const mockAddress = '0x1234567890abcdef';

  setUp(() {
    dio = MockDio();
    appConfig = MockAppConfig();
    walletRemoteDatasource = WalletRemoteDatasource(
      dio: dio,
      appConfig: appConfig,
    );
  });
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: expectedUrl));
  });

  group('getETHBalance', () {
    test('should call [POST] to get ETH balance successfully', () async {
      when(() => appConfig.alchemyBaseUrl).thenReturn(expectedUrl);

      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: expectedUrl),
          data: ethBalanceDataMock,
          statusCode: 200,
        ),
      );

      final result = await walletRemoteDatasource.getETHBalance(mockAddress);

      expect(result, isA<EthBalanceModel>());
      expect(result.balance, equals('0x4b36a37aa9e304c'));
      expect(result.jsonrpc, equals('2.0'));
      expect(result.id, equals(1));

      verify(
        () => dio.post(
          appConfig.alchemyBaseUrl,
          data: {
            'jsonrpc': '2.0',
            'method': 'eth_getBalance',
            'params': [mockAddress, 'latest'],
            'id': 1,
          },
        ),
      ).called(1);
    });
    test('should throw RemoteException when got error response', () async {
      when(() => appConfig.alchemyBaseUrl).thenReturn(expectedUrl);
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: expectedUrl),
          data: {
            'error': {'message': 'Invalid params'},
          },
          statusCode: 200,
        ),
      );
      expect(
        () => walletRemoteDatasource.getETHBalance(mockAddress),
        throwsA(isA<RemoteException>()),
      );
    });

    test('should throw RemoteException when got exception', () async {
      when(() => appConfig.alchemyBaseUrl).thenReturn(expectedUrl);

      when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: expectedUrl),
          response: Response(
            requestOptions: RequestOptions(path: expectedUrl),
            statusCode: 401,
          ),
        ),
      );

      expect(
        () => walletRemoteDatasource.getETHBalance(mockAddress),
        throwsA(isA<RemoteException>()),
      );
    });
  });
  group('getTokenBalances', () {
    test('should call [POST] to get token balances successfully', () async {
      when(() => appConfig.alchemyBaseUrl).thenReturn(expectedUrl);

      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: expectedUrl),
          data: tokenBalancesDataMock,
          statusCode: 200,
        ),
      );

      final result = await walletRemoteDatasource.getTokenBalances(mockAddress);

      expect(result, isA<TokensListModel>());
      expect(result.jsonrpc, equals('2.0'));
      expect(result.id, equals(1));
    });
    test('should throw RemoteException when got error response', () async {
      when(() => appConfig.alchemyBaseUrl).thenReturn(expectedUrl);
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: expectedUrl),
          data: {
            'error': {'message': 'Invalid params'},
          },
          statusCode: 200,
        ),
      );
      expect(
        () => walletRemoteDatasource.getTokenBalances(mockAddress),
        throwsA(isA<RemoteException>()),
      );
    });
    test('should throw RemoteException when got exception', () async {
      when(() => appConfig.alchemyBaseUrl).thenReturn(expectedUrl);
      when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: expectedUrl),
          response: Response(
            requestOptions: RequestOptions(path: expectedUrl),
            statusCode: 401,
          ),
        ),
      );
      expect(
        () => walletRemoteDatasource.getTokenBalances(mockAddress),
        throwsA(isA<RemoteException>()),
      );
    });
  });
  group('getTokenMetadata', () {
    test('should call [POST] to get token metadata successfully', () async {
      when(() => appConfig.alchemyBaseUrl).thenReturn(expectedUrl);

      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: expectedUrl),
          data: tokenMetadataDataMock,
          statusCode: 200,
        ),
      );
      final result = await walletRemoteDatasource.getTokenMetadata(mockAddress);

      expect(result, isA<TokenMetadataModel>());
      expect(result.jsonrpc, equals('2.0'));
      expect(result.id, equals(1));
      expect(result.result.decimals, equals(18));
      expect(result.result.logo, equals(null));
      expect(result.result.name, equals('R2Credential'));
      expect(result.result.symbol, equals('R2ETH'));
    });
    test('should throw RemoteException when got error response', () async {
      when(() => appConfig.alchemyBaseUrl).thenReturn(expectedUrl);
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: expectedUrl),
          data: {
            'error': {'message': 'Invalid params'},
          },
          statusCode: 200,
        ),
      );
      expect(
        () => walletRemoteDatasource.getTokenMetadata(mockAddress),
        throwsA(isA<RemoteException>()),
      );
    });
    test('should throw RemoteException when got exception', () async {
      when(() => appConfig.alchemyBaseUrl).thenReturn(expectedUrl);
      when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: expectedUrl),
          response: Response(
            requestOptions: RequestOptions(path: expectedUrl),
            statusCode: 401,
          ),
        ),
      );
      expect(
        () => walletRemoteDatasource.getTokenMetadata(mockAddress),
        throwsA(isA<RemoteException>()),
      );
    });
  });
}
