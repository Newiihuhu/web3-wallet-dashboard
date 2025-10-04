import 'package:shared_preferences/shared_preferences.dart';

class WalletAddressLocalDatasource {
  static const String _walletAddressKey = 'wallet_address';

  final SharedPreferences _prefs;

  WalletAddressLocalDatasource(this._prefs);

  Future<bool> saveWalletAddress(String address) async {
    return await _prefs.setString(_walletAddressKey, address);
  }

  String? getWalletAddress() {
    return _prefs.getString(_walletAddressKey);
  }

  bool hasWalletAddress() {
    return _prefs.containsKey(_walletAddressKey);
  }
}
