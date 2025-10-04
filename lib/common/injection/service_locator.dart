import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3_wallet_dashboard/data/datasources/local/wallet_address_local_datasource.dart';
import 'package:web3_wallet_dashboard/data/datasources/remote/alchemy_remote_datasource.dart';
import 'package:web3_wallet_dashboard/data/repositories/wallet_address_repository_impl.dart';
import 'package:web3_wallet_dashboard/data/repositories/wallet_overview_repository_impl.dart';
import 'package:web3_wallet_dashboard/domain/repositories/wallet_address_repository.dart';
import 'package:web3_wallet_dashboard/domain/repositories/wallet_overview_repository.dart';
import 'package:web3_wallet_dashboard/domain/usecases/wallet_address_usecase.dart';
import 'package:web3_wallet_dashboard/domain/usecases/wallet_overview_usecase.dart';
import 'package:web3_wallet_dashboard/presentation/bloc/dashboard_bloc.dart';

/// Global GetIt instance for dependency injection
final GetIt getIt = GetIt.instance;
Future<void> initializeDependencies() async {
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
  getIt.registerLazySingleton<AlchemyRemoteDatasource>(
    () => AlchemyRemoteDatasource(dio: getIt<Dio>()),
  );

  final sharedPreferences = await getIt.getAsync<SharedPreferences>();
  getIt.registerLazySingleton<WalletAddressLocalDatasource>(
    () => WalletAddressLocalDatasource(sharedPreferences),
  );
}

void _registerRepositories() {
  getIt.registerLazySingleton<WalletOverviewRepository>(
    () => WalletOverviewRepositoryImpl(getIt<AlchemyRemoteDatasource>()),
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
