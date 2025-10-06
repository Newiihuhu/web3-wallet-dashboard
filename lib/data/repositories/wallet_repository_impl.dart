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
    final cachedBalance = _getCachedETHBalance();
    if (cachedBalance != null) {
      return cachedBalance;
    }

    final remoteBalance = await _remoteDatasource.getETHBalance(address);
    await _localDatasource.saveETHBalance(remoteBalance);

    return remoteBalance;
  }

  EthBalanceEntity? _getCachedETHBalance() {
    if (!_localDatasource.hasBalanceData()) {
      return null;
    }

    final localBalance = _localDatasource.getETHBalance();
    if (localBalance?.balance.isNotEmpty == true) {
      return localBalance;
    }

    return null;
  }

  @override
  Future<List<TokensEntity>> getErc20Tokens(String address) async {
    final cachedTokens = _getCachedTokens();
    if (cachedTokens != null) {
      return cachedTokens;
    }

    final tokens = await _fetchAndProcessTokens(address);

    await _tokensLocalDatasource.saveTokens(tokens);

    return tokens;
  }

  List<TokensEntity>? _getCachedTokens() {
    if (!_tokensLocalDatasource.hasTokensData()) {
      return null;
    }

    final localTokens = _tokensLocalDatasource.getTokens();
    if (localTokens?.isNotEmpty == true) {
      return localTokens;
    }

    return null;
  }

  Future<List<TokensEntity>> _fetchAndProcessTokens(String address) async {
    final remoteTokens = await _remoteDatasource.getTokenBalances(address);
    final filteredTokens = remoteTokens.filterTokens();

    final List<TokensEntity> tokens = [];

    for (final token in filteredTokens) {
      final tokenEntity = await _createTokenEntity(token);
      tokens.add(tokenEntity);
    }

    return tokens;
  }

  Future<TokensEntity> _createTokenEntity(dynamic token) async {
    final tokenMetadata = await _remoteDatasource.getTokenMetadata(
      token.contractAddress,
    );

    return TokensEntity(
      contractAddress: token.contractAddress,
      symbol: tokenMetadata.result.symbol,
      name: tokenMetadata.result.name,
      balance: token.tokenBalance,
      decimals: tokenMetadata.result.decimals,
    );
  }
}
