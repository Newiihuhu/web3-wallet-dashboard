import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3_wallet/core/exception/app_exception.dart';
import 'package:web3_wallet/domain/entities/eth_balance_entity.dart';

class WalletOverviewLocalDatasource {
  static const String _ethBalanceKey = 'eth_balance';

  final SharedPreferences _prefs;

  WalletOverviewLocalDatasource(this._prefs);

  Future<bool> saveETHBalance(EthBalanceEntity model) async {
    try {
      final balanceData = {'balance': model.balance};

      final success = await _prefs.setString(
        _ethBalanceKey,
        jsonEncode(balanceData),
      );

      return success;
    } catch (e) {
      throw LocalStorageException(
        'Error saving ETH balance to local storage: $e',
      );
    }
  }

  EthBalanceEntity? getETHBalance() {
    try {
      final balanceData = _prefs.getString(_ethBalanceKey);

      if (balanceData == null) {
        return null;
      }

      final data = jsonDecode(balanceData) as Map<String, dynamic>;
      return EthBalanceEntity(balance: data['balance'] as String);
    } catch (e) {
      throw LocalStorageException(
        'Error getting ETH balance from local storage: $e',
      );
    }
  }

  bool hasBalanceData() {
    return _prefs.containsKey(_ethBalanceKey);
  }
}
