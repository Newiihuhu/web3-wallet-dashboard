import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3_wallet/core/config/app_config.dart';
import 'package:web3_wallet/data/datasources/local/tokens_local_datasource.dart';
import 'package:web3_wallet/data/datasources/local/wallet_address_local_datasource.dart';
import 'package:web3_wallet/data/datasources/local/wallet_overview_local_datasource.dart';
import 'package:web3_wallet/data/datasources/remote/wallet_remote_datasource.dart';
import 'package:web3_wallet/data/repositories/wallet_address_repository_impl.dart';
import 'package:web3_wallet/data/repositories/wallet_repository_impl.dart';
import 'package:web3_wallet/domain/repositories/wallet_address_repository.dart';
import 'package:web3_wallet/domain/repositories/wallet_repository.dart';
import 'package:web3_wallet/domain/usecases/wallet_address_usecase.dart';
import 'package:web3_wallet/domain/usecases/wallet_usecase.dart';
import 'package:web3_wallet/presentation/bloc/dashboard_bloc.dart';

final GetIt getIt = GetIt.instance;
Future<void> initializeDependencies(AppConfig config) async {
  getIt.registerLazySingleton<AppConfig>(() => config);
  await _registerExternalDependencies();
  await _registerDataSources();
  _registerRepositories();
  _registerUseCases();
  _registerBlocs();
}

Future<void> _registerExternalDependencies() async {
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
    dio.options.sendTimeout = const Duration(seconds: 15);

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        // ignore: avoid_print
        logPrint: (object) => print('[DIO] $object'),
      ),
    );

    return dio;
  });

  getIt.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );
}

Future<void> _registerDataSources() async {
  getIt.registerLazySingleton<WalletRemoteDatasource>(
    () => WalletRemoteDatasource(
      dio: getIt<Dio>(),
      appConfig: getIt<AppConfig>(),
    ),
  );

  final sharedPreferences = await getIt.getAsync<SharedPreferences>();
  getIt.registerLazySingleton<WalletAddressLocalDatasource>(
    () => WalletAddressLocalDatasource(sharedPreferences),
  );
  getIt.registerLazySingleton<WalletOverviewLocalDatasource>(
    () => WalletOverviewLocalDatasource(sharedPreferences),
  );
  getIt.registerLazySingleton<TokensLocalDatasource>(
    () => TokensLocalDatasource(sharedPreferences),
  );
}

void _registerRepositories() {
  getIt.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(
      getIt<WalletRemoteDatasource>(),
      getIt<WalletOverviewLocalDatasource>(),
      getIt<TokensLocalDatasource>(),
    ),
  );
  getIt.registerLazySingleton<WalletAddressRepository>(
    () => WalletAddressRepositoryImpl(getIt<WalletAddressLocalDatasource>()),
  );
}

void _registerUseCases() {
  getIt.registerLazySingleton<WalletUsecase>(
    () => WalletUsecase(getIt<WalletRepository>()),
  );
  getIt.registerLazySingleton<WalletAddressUsecase>(
    () => WalletAddressUsecase(getIt<WalletAddressRepository>()),
  );
}

void _registerBlocs() {
  getIt.registerFactory<DashboardBloc>(
    () => DashboardBloc(getIt<WalletUsecase>(), getIt<WalletAddressUsecase>()),
  );
}

Future<void> resetDependencies() async {
  await getIt.reset();
}
