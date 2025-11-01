import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

import '../data/datasources/crypto_remote_datasource.dart';
import '../data/repositories/crypto_repository_impl.dart';
import '../domain/repositories/crypto_repository.dart';
import '../domain/usecases/get_crypto_coins.dart';
import '../services/api_service.dart';
import 'configuration.dart';

final GetIt injector = GetIt.instance;

Future<void> initializeDependencies() async {
  // Configuration
  injector.registerSingleton<Configuration>(Configuration.instance);
  
  // Dio
  injector.registerSingleton<Dio>(_createDio());
  
  // Services
  injector.registerSingleton<ApiService>(ApiService(injector<Dio>()));
  
  // Data Sources
  injector.registerLazySingleton<CryptoRemoteDataSource>(
    () => CryptoRemoteDataSourceImpl(dio: injector<Dio>()),
  );
  
  // Repositories
  injector.registerLazySingleton<CryptoRepository>(
    () => CryptoRepositoryImpl(remoteDataSource: injector<CryptoRemoteDataSource>()),
  );
  
  // Use Cases
  injector.registerLazySingleton(() => GetCryptoCoins(injector<CryptoRepository>()));
}

Dio _createDio() {
  final dio = Dio();
  final config = Configuration.instance;
  
  // Base options
  dio.options = BaseOptions(
    baseUrl: config.baseUrl,
    connectTimeout: Duration(milliseconds: config.connectTimeout),
    receiveTimeout: Duration(milliseconds: config.receiveTimeout),
    sendTimeout: Duration(milliseconds: config.sendTimeout),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );
  
  // API Key Interceptor
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      options.queryParameters['x_cg_demo_api_key'] = config.apiKey;
      handler.next(options);
    },
  ));
  
  // Interceptors
  if (config.enableLogging) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
    ));
  }
  
  // Error interceptor
  dio.interceptors.add(InterceptorsWrapper(
    onError: (error, handler) {
      if (config.enableLogging) {
        if (kDebugMode) {
          print('Dio Error: ${error.message}');
        }
        if (kDebugMode) {
          print('Dio Error Type: ${error.type}');
        }
        if (kDebugMode) {
          print('Dio Error Response: ${error.response?.data}');
        }
      }
      handler.next(error);
    },
  ));
  
  return dio;
}
