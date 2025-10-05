import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3_wallet_dashboard/core/config/app_config.dart';
import 'package:web3_wallet_dashboard/data/datasources/local/wallet_address_local_datasource.dart';
import 'package:web3_wallet_dashboard/data/datasources/local/wallet_overview_local_datasource.dart';
import 'package:web3_wallet_dashboard/data/datasources/remote/wallet_remote_datasource.dart';
import 'package:web3_wallet_dashboard/data/repositories/wallet_address_repository_impl.dart';
import 'package:web3_wallet_dashboard/data/repositories/wallet_overview_repository_impl.dart';
import 'package:web3_wallet_dashboard/domain/repositories/wallet_address_repository.dart';
import 'package:web3_wallet_dashboard/domain/repositories/wallet_overview_repository.dart';
import 'package:web3_wallet_dashboard/domain/usecases/wallet_address_usecase.dart';
import 'package:web3_wallet_dashboard/domain/usecases/wallet_overview_usecase.dart';
import 'package:web3_wallet_dashboard/presentation/bloc/dashboard_bloc.dart';

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
}

void _registerRepositories() {
  getIt.registerLazySingleton<WalletOverviewRepository>(
    () => WalletOverviewRepositoryImpl(
      getIt<WalletRemoteDatasource>(),
      getIt<WalletOverviewLocalDatasource>(),
    ),
  );
  getIt.registerLazySingleton<WalletAddressRepository>(
    () => WalletAddressRepositoryImpl(getIt<WalletAddressLocalDatasource>()),
  );
}

void _registerUseCases() {
  getIt.registerLazySingleton<WalletOverviewUsecase>(
    () => WalletOverviewUsecase(getIt<WalletOverviewRepository>()),
  );
  getIt.registerLazySingleton<WalletAddressUsecase>(
    () => WalletAddressUsecase(getIt<WalletAddressRepository>()),
  );
}

void _registerBlocs() {
  getIt.registerFactory<DashboardBloc>(
    () => DashboardBloc(
      getIt<WalletOverviewUsecase>(),
      getIt<WalletAddressUsecase>(),
    ),
  );
}

Future<void> resetDependencies() async {
  await getIt.reset();
}
