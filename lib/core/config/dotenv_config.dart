import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3_wallet/core/config/app_config.dart';

class DotenvConfig implements AppConfig {
  @override
  String get alchemyBaseUrl {
    final key = dotenv.env['ALCHEMY_API_KEY'];
    if (key == null || key.isEmpty) {
      throw StateError('Missing ALCHEMY_API_KEY in .env');
    }
    return 'https://eth-sepolia.g.alchemy.com/v2/$key';
  }
}