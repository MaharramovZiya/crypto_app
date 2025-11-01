import 'package:dio/dio.dart';

import '../../core/error/exceptions.dart';
import '../models/crypto_coin_model.dart';

abstract class CryptoRemoteDataSource {
  Future<List<CryptoCoinModel>> getCryptoCoins({
    int page = 1,
    int perPage = 20,
    String order = 'market_cap_desc',
  });
  
  Future<CryptoCoinModel> getCryptoCoinById(String id);
  
  Future<List<CryptoCoinModel>> searchCryptoCoins(String query);
  
  Future<List<CryptoCoinModel>> getTrendingCryptoCoins();
}

class CryptoRemoteDataSourceImpl implements CryptoRemoteDataSource {
  final Dio dio;

  CryptoRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CryptoCoinModel>> getCryptoCoins({
    int page = 1,
    int perPage = 20,
    String order = 'market_cap_desc',
  }) async {
    try {
      final response = await dio.get(
        '/coins/markets',
        queryParameters: {
          'vs_currency': 'usd',
          'order': order,
          'per_page': perPage,
          'page': page,
          'sparkline': true,
          'price_change_percentage': '24h',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => CryptoCoinModel.fromJson(json)).toList();
      } else {
        throw const ServerException(message: 'Failed to load crypto coins');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException(message: 'No internet connection');
      } else {
        throw ServerException(message: e.message ?? 'Unknown error occurred');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CryptoCoinModel> getCryptoCoinById(String id) async {
    try {
      final response = await dio.get(
        '/coins/$id',
        queryParameters: {
          'localization': false,
          'tickers': false,
          'market_data': true,
          'community_data': false,
          'developer_data': false,
          'sparkline': false,
        },
      );

      if (response.statusCode == 200) {
        return CryptoCoinModel.fromJson(response.data);
      } else {
        throw const ServerException(message: 'Failed to load crypto coin');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException(message: 'No internet connection');
      } else {
        throw ServerException(message: e.message ?? 'Unknown error occurred');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CryptoCoinModel>> searchCryptoCoins(String query) async {
    try {
      final response = await dio.get(
        '/search',
        queryParameters: {
          'query': query,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> coins = response.data['coins'];
        return coins.map((json) => CryptoCoinModel.fromJson(json)).toList();
      } else {
        throw const ServerException(message: 'Failed to search crypto coins');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException(message: 'No internet connection');
      } else {
        throw ServerException(message: e.message ?? 'Unknown error occurred');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CryptoCoinModel>> getTrendingCryptoCoins() async {
    try {
      final response = await dio.get('/search/trending');

      if (response.statusCode == 200) {
        final List<dynamic> coins = response.data['coins'];
        return coins.map((json) => CryptoCoinModel.fromJson(json['item'])).toList();
      } else {
        throw const ServerException(message: 'Failed to load trending crypto coins');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException(message: 'No internet connection');
      } else {
        throw ServerException(message: e.message ?? 'Unknown error occurred');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
