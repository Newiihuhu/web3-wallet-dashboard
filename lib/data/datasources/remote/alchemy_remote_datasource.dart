import 'package:dio/dio.dart';
import 'package:web3_wallet_dashboard/data/models/eth_balance_model.dart';

class AlchemyRemoteDatasource {
  final Dio dio;

  AlchemyRemoteDatasource({required this.dio});

  Future<EthBalanceModel> getETHBalance(String address) async {
    final response = await dio.post(
      'https://eth-sepolia.g.alchemy.com/v2/OiXmTrcDyoreJODhL1iyi',
      data: {
        'jsonrpc': '2.0',
        'method': 'eth_getBalance',
        'params': [address, 'latest'],
        'id': 1,
      },
    );
    return EthBalanceModel.fromJson(response.data);
  }
}