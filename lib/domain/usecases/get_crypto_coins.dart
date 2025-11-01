import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/crypto_coin.dart';
import '../repositories/crypto_repository.dart';

class GetCryptoCoins implements UseCase<List<CryptoCoin>, GetCryptoCoinsParams> {
  final CryptoRepository repository;

  GetCryptoCoins(this.repository);

  @override
  Future<Either<Failure, List<CryptoCoin>>> call(GetCryptoCoinsParams params) async {
    return await repository.getCryptoCoins(
      page: params.page,
      perPage: params.perPage,
      order: params.order,
    );
  }
}

class GetCryptoCoinsParams extends Equatable {
  final int page;
  final int perPage;
  final String order;

  const GetCryptoCoinsParams({
    required this.page,
    required this.perPage,
    required this.order,
  });

  @override
  List<Object> get props => [page, perPage, order];
}
