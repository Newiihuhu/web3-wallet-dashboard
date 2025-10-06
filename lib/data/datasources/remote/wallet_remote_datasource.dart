import 'package:dio/dio.dart';
import 'package:web3_wallet/core/config/app_config.dart';
import 'package:web3_wallet/core/exception/app_exception.dart';
import 'package:web3_wallet/data/models/eth_balance_model.dart';
import 'package:web3_wallet/data/models/token_metadata_model.dart';
import 'package:web3_wallet/data/models/tokens_list_model.dart';

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
        throw RemoteException(error['message'] as String);
      }
      return EthBalanceModel.fromJson(response.data);
    } catch (e) {
      throw RemoteException(e.toString());
    }
  }

  Future<TokensListModel> getTokenBalances(String address) async {
    try {
      final response = await dio.post(
        appConfig.alchemyBaseUrl,
        data: {
          'jsonrpc': '2.0',
          'method': 'alchemy_getTokenBalances',
          'params': [address, 'erc20'],
          'id': 1,
        },
      );
      final data = response.data as Map<String, dynamic>;
      if (data.containsKey('error')) {
        final error = data['error'] as Map<String, dynamic>;
        throw RemoteException(error['message'] as String);
      }
      return TokensListModel.fromJson(response.data);
    } catch (e) {
      throw RemoteException(e.toString());
    }
  }

  Future<TokenMetadataModel> getTokenMetadata(String address) async {
    try {
      final response = await dio.post(
        appConfig.alchemyBaseUrl,
        data: {
          'jsonrpc': '2.0',
          'method': 'alchemy_getTokenMetadata',
          'params': [address],
          'id': 1,
        },
      );
      final data = response.data as Map<String, dynamic>;
      if (data.containsKey('error')) {
        final error = data['error'] as Map<String, dynamic>;
        throw RemoteException(error['message'] as String);
      }
      return TokenMetadataModel.fromJson(response.data);
    } catch (e) {
      throw RemoteException(e.toString());
    }
  }
}
