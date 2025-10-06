import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3_wallet/core/exception/app_exception.dart';

class WalletAddressLocalDatasource {
  static const String _walletAddressKey = 'wallet_address';

  final SharedPreferences _prefs;

  WalletAddressLocalDatasource(this._prefs);

  Future<bool> saveWalletAddress(String address) async {
    try {
      return await _prefs.setString(_walletAddressKey, address);
    } catch (e) {
      throw LocalStorageException(
        'Error saving wallet address to local storage: $e',
      );
    }
  }

  String? getWalletAddress() {
    try {
      return _prefs.getString(_walletAddressKey);
    } catch (e) {
      throw LocalStorageException(
        'Error getting wallet address from local storage: $e',
      );
    }
  }

  bool hasWalletAddress() {
    return _prefs.containsKey(_walletAddressKey);
  }
}
