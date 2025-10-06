import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3_wallet/core/exception/app_exception.dart';
import 'package:web3_wallet/domain/entities/tokens_entity.dart';

class TokensLocalDatasource {
  static const String _tokensKey = 'erc20_tokens';

  final SharedPreferences _prefs;

  TokensLocalDatasource(this._prefs);

  Future<bool> saveTokens(List<TokensEntity> tokens) async {
    try {
      final tokensData = tokens
          .map(
            (token) => {
              'contractAddress': token.contractAddress,
              'symbol': token.symbol,
              'name': token.name,
              'balance': token.balance,
              'decimals': token.decimals,
            },
          )
          .toList();

      final data = {'tokens': tokensData};

      final success = await _prefs.setString(_tokensKey, jsonEncode(data));

      return success;
    } catch (e) {
      throw LocalStorageException('Error saving tokens to local storage: $e');
    }
  }

  List<TokensEntity>? getTokens() {
    try {
      final tokensData = _prefs.getString(_tokensKey);

      if (tokensData == null) {
        return null;
      }

      final data = jsonDecode(tokensData) as Map<String, dynamic>;
      final tokensList = data['tokens'] as List<dynamic>;

      return tokensList.map((tokenData) {
        final token = tokenData as Map<String, dynamic>;
        return TokensEntity(
          contractAddress: token['contractAddress'] as String,
          symbol: token['symbol'] as String,
          name: token['name'] as String,
          balance: token['balance'] as String,
          decimals: token['decimals'] as int,
        );
      }).toList();
    } catch (e) {
      throw LocalStorageException(
        'Error getting tokens from local storage: $e',
      );
    }
  }

  bool hasTokensData() {
    return _prefs.containsKey(_tokensKey);
  }
}
