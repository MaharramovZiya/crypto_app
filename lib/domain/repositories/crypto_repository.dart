import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/crypto_coin.dart';

abstract class CryptoRepository {
  Future<Either<Failure, List<CryptoCoin>>> getCryptoCoins({
    int page = 1,
    int perPage = 20,
    String order = 'market_cap_desc',
  });
  
  Future<Either<Failure, CryptoCoin>> getCryptoCoinById(String id);
  
  Future<Either<Failure, List<CryptoCoin>>> searchCryptoCoins(String query);
  
  Future<Either<Failure, List<CryptoCoin>>> getTrendingCryptoCoins();
}
