import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3_wallet_dashboard/data/datasources/local/local_storage_datasource.dart';
import 'package:web3_wallet_dashboard/data/datasources/remote/alchemy_remote_datasource.dart';
import 'package:web3_wallet_dashboard/data/repositories/web3_wallet_repository_impl.dart';
import 'package:web3_wallet_dashboard/domain/repositories/web3_wallet_repository.dart';
import 'package:web3_wallet_dashboard/domain/usecases/web3_wallet_usecase.dart';
import 'package:web3_wallet_dashboard/presentation/bloc/dashboard_bloc.dart';

/// Global GetIt instance for dependency injection
final GetIt getIt = GetIt.instance;
Future<void> initializeDependencies() async {
  await _registerExternalDependencies();
  _registerDataSources();
  _registerRepositories();
  _registerUseCases();
  _registerBlocs();
}

Future<void> _registerExternalDependencies() async {
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        // logPrint: (object) => debugPrint(object.toString()),
      ),
    );

    return dio;
  });

  getIt.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );
}

void _registerDataSources() {
  getIt.registerLazySingleton<AlchemyRemoteDatasource>(
    () => AlchemyRemoteDatasource(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<LocalStorageDatasource>(
    () => LocalStorageDatasource(getIt<SharedPreferences>()),
  );
}

void _registerRepositories() {
  getIt.registerLazySingleton<Web3WalletRepository>(
    () => Web3WalletRepositoryImpl(
      getIt<AlchemyRemoteDatasource>(),
      getIt<LocalStorageDatasource>(),
    ),
  );
}

void _registerUseCases() {
  getIt.registerLazySingleton<Web3WalletUsecase>(
    () => Web3WalletUsecase(getIt<Web3WalletRepository>()),
  );
}

void _registerBlocs() {
  getIt.registerFactory<DashboardBloc>(
    () => DashboardBloc(getIt<Web3WalletUsecase>()),
  );
}

Future<void> resetDependencies() async {
  await getIt.reset();
}

/// Usage Examples:
/// 
/// 1. Get a singleton instance:
/// ```dart
/// final dio = getIt<Dio>();
/// final repository = getIt<Web3WalletRepository>();
/// ```
/// 
/// 2. Get a factory instance (creates new instance each time):
/// ```dart
/// final bloc = getIt<DashboardBloc>();
/// ```
/// 
/// 3. Check if a dependency is registered:
/// ```dart
/// if (getIt.isRegistered<Dio>()) {
///   final dio = getIt<Dio>();
/// }
/// ```
/// 
/// 4. Get dependencies in a widget:
/// ```dart
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     final bloc = getIt<DashboardBloc>();
///     return BlocProvider.value(
///       value: bloc,
///       child: // your widget tree
///     );
///   }
/// }
/// ```
