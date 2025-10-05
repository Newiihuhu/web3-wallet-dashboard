import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet_dashboard/core/exception/app_exception.dart';
import 'package:web3_wallet_dashboard/data/datasources/remote/wallet_remote_datasource.dart';
import 'package:web3_wallet_dashboard/data/models/eth_balance_model.dart';

import '../../model/__mock__/eth_balance_data_mock.dart';
import '__mock__/app_config_mock.dart';
import '__mock__/dio_mock.dart';


void main() {
  late MockDio dio;
  late WalletRemoteDatasource walletRemoteDatasource;
  late MockAppConfig appConfig;

  setUp(() {
    dio = MockDio();
    appConfig = MockAppConfig();
    walletRemoteDatasource = WalletRemoteDatasource(
      dio: dio,
      appConfig: appConfig,
    );
  });

  group('getETHBalance', () {
    const expectedUrl = 'https://eth-sepolia.g.alchemy.com/v2/FAKE_KEY';
    const mockAddress = '0x1234567890abcdef';

    setUpAll(() {
      registerFallbackValue(RequestOptions(path: expectedUrl));
    });

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
    test('should throw JsonRpcException when got error response', () async {
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
        throwsA(isA<JsonRpcException>()),
      );
    });

    test('should throw AuthenticationException on 401 response', () async {
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
        throwsA(isA<AuthenticationException>()),
      );
    });
    test('should throw NetworkException on network error', () async {
      when(() => appConfig.alchemyBaseUrl).thenReturn(expectedUrl);
      when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: expectedUrl),
        ),
      );
      expect(
        () => walletRemoteDatasource.getETHBalance(mockAddress),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
