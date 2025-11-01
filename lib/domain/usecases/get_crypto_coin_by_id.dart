import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/crypto_coin.dart';
import '../repositories/crypto_repository.dart';

class GetCryptoCoinById implements UseCase<CryptoCoin, GetCryptoCoinByIdParams> {
  final CryptoRepository repository;

  GetCryptoCoinById(this.repository);

  @override
  Future<Either<Failure, CryptoCoin>> call(GetCryptoCoinByIdParams params) async {
    return await repository.getCryptoCoinById(params.id);
  }
}

class GetCryptoCoinByIdParams extends Equatable {
  final String id;

  const GetCryptoCoinByIdParams({required this.id});

  @override
  List<Object> get props => [id];
}

