import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3_wallet_dashboard/domain/entities/eth_balance_entity.dart';

class WalletOverviewLocalDatasource {
  static const String _ethBalanceKey = 'eth_balance';

  final SharedPreferences _prefs;

  WalletOverviewLocalDatasource(this._prefs);

  Future<bool> saveETHBalance(EthBalanceEntity model) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;

      final balanceData = {
        'balance': model.balance,
        'lastUpdated': now,
        'isFromRemote': model.isFromRemote,
      };

      final success = await _prefs.setString(
        _ethBalanceKey,
        jsonEncode(balanceData),
      );

      return success;
    } catch (e) {
      return false;
    }
  }

  EthBalanceEntity? getETHBalance() {
    try {
      final balanceData = _prefs.getString(_ethBalanceKey);

      if (balanceData == null) {
        return null;
      }

      final data = jsonDecode(balanceData) as Map<String, dynamic>;
      return EthBalanceEntity(
        balance: data['balance'] as String,
        lastUpdated: DateTime.fromMillisecondsSinceEpoch(
          data['lastUpdated'] as int,
        ),
        isFromRemote: data['isFromRemote'] as bool,
      );
    } catch (e) {
      return null;
    }
  }

  bool isBalanceDataFresh() {
    final balanceData = _prefs.getString(_ethBalanceKey);
    if (balanceData == null) {
      return false;
    }

    final data = jsonDecode(balanceData) as Map<String, dynamic>;
    final lastUpdated = data['lastUpdated'] as int;

    final now = DateTime.now().millisecondsSinceEpoch;
    final cacheAge = now - lastUpdated;
    const fiveMinutesInMs = 5 * 60 * 1000;

    return cacheAge < fiveMinutesInMs;
  }

  bool hasBalanceData() {
    return _prefs.containsKey(_ethBalanceKey);
  }
}
