import 'package:web3_wallet/domain/entities/eth_balance_entity.dart';

class EthBalanceModel extends EthBalanceEntity {
  final String jsonrpc;
  final int id;

  EthBalanceModel({
    required super.balance,
    required this.jsonrpc,
    required this.id,
  });

  factory EthBalanceModel.fromJson(Map<String, dynamic> json) {
    return EthBalanceModel(
      jsonrpc: json['jsonrpc'] as String,
      id: json['id'] as int,
      balance: json['result'],
    );
  }
}
