import 'package:dio/dio.dart';
import 'package:web3_wallet/core/config/app_config.dart';
import 'package:web3_wallet/core/constants/wallet_constants.dart';
import 'package:web3_wallet/core/exception/app_exception.dart';
import 'package:web3_wallet/data/models/eth_balance_model.dart';

class WalletRemoteDatasource {
  final Dio dio;
  final AppConfig appConfig;
  WalletRemoteDatasource({required this.dio, required this.appConfig});

  Future<EthBalanceModel> getETHBalance(String address) async {
    try {
      final response = await dio.post(
        appConfig.alchemyBaseUrl,
        data: {
          'jsonrpc': '2.0',
          'method': 'eth_getBalance',
          'params': [address, 'latest'],
          'id': 1,
        },
      );

      final data = response.data as Map<String, dynamic>;
      if (data.containsKey('error')) {
        final error = data['error'] as Map<String, dynamic>;
        throw JsonRpcException(error['message'] as String);
      }
      return EthBalanceModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthenticationException(WalletConstants.authenticationException);
      }
      throw NetworkException(WalletConstants.networkException);
    }
  }
}
