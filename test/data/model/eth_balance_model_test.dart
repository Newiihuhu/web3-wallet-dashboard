import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/data/models/eth_balance_model.dart';

void main() {
  group('EthBalanceModel', () {
    group('fromJson', () {
      test('should create instance from valid JSON', () {
        final json = {'jsonrpc': '2.0', 'id': 1, 'result': '0x4b36a37aa9e304c'};

        final model = EthBalanceModel.fromJson(json);

        expect(model.jsonrpc, '2.0');
        expect(model.id, 1);
        expect(model.balance, '0x4b36a37aa9e304c');
      });
    });
  });
}
