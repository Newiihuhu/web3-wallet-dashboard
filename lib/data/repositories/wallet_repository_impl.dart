import 'package:web3_wallet/core/utils/formatter.dart';
import 'package:web3_wallet/data/datasources/local/tokens_local_datasource.dart';
import 'package:web3_wallet/data/datasources/local/wallet_overview_local_datasource.dart';
import 'package:web3_wallet/data/datasources/remote/wallet_remote_datasource.dart';
import 'package:web3_wallet/domain/entities/eth_balance_entity.dart';
import 'package:web3_wallet/domain/entities/tokens_entity.dart';
import 'package:web3_wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDatasource _remoteDatasource;
  final WalletOverviewLocalDatasource _localDatasource;
  final TokensLocalDatasource _tokensLocalDatasource;

  WalletRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._tokensLocalDatasource,
  );

  @override
  Future<EthBalanceEntity> getETHBalance(String address) async {
    if (_localDatasource.hasBalanceData()) {
      final localBalance = _localDatasource.getETHBalance();
      if (localBalance != null && localBalance.balance.isNotEmpty) {
        return localBalance;
      }
    }

    final remoteBalance = await _remoteDatasource.getETHBalance(address);
    await _localDatasource.saveETHBalance(remoteBalance);

    return remoteBalance;
  }

  @override
  Future<List<TokensEntity>> getErc20Tokens(String address) async {
    if (_tokensLocalDatasource.hasTokensData()) {
      final localTokens = _tokensLocalDatasource.getTokens();
      if (localTokens != null && localTokens.isNotEmpty) {
        return localTokens;
      }
    }

    final remoteTokens = await _remoteDatasource.getTokenBalances(address);
    final filteredTokens = remoteTokens.result.tokenBalances
        .where((token) => hexToBigInt(token.tokenBalance) != BigInt.zero)
        .toList();

    final List<TokensEntity> tokens = [];

    for (final token in filteredTokens) {
      final tokenMetadata = await _remoteDatasource.getTokenMetadata(
        token.contractAddress,
      );

      tokens.add(
        TokensEntity(
          contractAddress: token.contractAddress,
          symbol: tokenMetadata.result.symbol,
          name: tokenMetadata.result.name,
          balance: token.tokenBalance,
          decimals: tokenMetadata.result.decimals,
        ),
      );
    }

    await _tokensLocalDatasource.saveTokens(tokens);

    return tokens;
  }
}
