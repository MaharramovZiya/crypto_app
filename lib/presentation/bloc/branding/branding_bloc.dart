import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/crypto_coin.dart';
import '../../../domain/usecases/get_crypto_coins.dart';
import '../../../core/error/failures.dart';

// Events
abstract class BrandingEvent extends Equatable {
  const BrandingEvent();

  @override
  List<Object> get props => [];
}

class LoadCryptoCoins extends BrandingEvent {
  final int page;
  final int perPage;
  final String order;

  const LoadCryptoCoins({
    this.page = 1,
    this.perPage = 20,
    this.order = 'market_cap_desc',
  });

  @override
  List<Object> get props => [page, perPage, order];
}

class RefreshCryptoCoins extends BrandingEvent {}

// States
abstract class BrandingState extends Equatable {
  const BrandingState();

  @override
  List<Object> get props => [];
}

class BrandingInitial extends BrandingState {}

class BrandingLoading extends BrandingState {
  final List<CryptoCoin> cryptoCoins;

  const BrandingLoading({this.cryptoCoins = const []});

  @override
  List<Object> get props => [cryptoCoins];
}

class BrandingLoaded extends BrandingState {
  final List<CryptoCoin> cryptoCoins;
  final bool isLoadingMore;

  const BrandingLoaded({
    required this.cryptoCoins,
    this.isLoadingMore = false,
  });

  @override
  List<Object> get props => [cryptoCoins, isLoadingMore];
}

class BrandingError extends BrandingState {
  final String message;
  final List<CryptoCoin> cryptoCoins;

  const BrandingError({
    required this.message,
    this.cryptoCoins = const [],
  });

  @override
  List<Object> get props => [message, cryptoCoins];
}

// BLoC
class BrandingBloc extends Bloc<BrandingEvent, BrandingState> {
  final GetCryptoCoins _getCryptoCoins;

  BrandingBloc({
    required GetCryptoCoins getCryptoCoins,
  })  : _getCryptoCoins = getCryptoCoins,
        super(BrandingInitial()) {
    on<LoadCryptoCoins>(_onLoadCryptoCoins);
    on<RefreshCryptoCoins>(_onRefreshCryptoCoins);
  }

  Future<void> _onLoadCryptoCoins(
    LoadCryptoCoins event,
    Emitter<BrandingState> emit,
  ) async {
    if (state is BrandingLoaded) {
      emit(BrandingLoaded(
        cryptoCoins: (state as BrandingLoaded).cryptoCoins,
        isLoadingMore: true,
      ));
    } else {
      emit(BrandingLoading());
    }

    final params = GetCryptoCoinsParams(
      page: event.page,
      perPage: event.perPage,
      order: event.order,
    );
    
    final result = await _getCryptoCoins(params);
    
    result.fold(
      (failure) => emit(BrandingError(message: _getFailureMessage(failure))),
      (cryptoCoins) {
        if (state is BrandingLoaded) {
          final currentCoins = (state as BrandingLoaded).cryptoCoins;
          emit(BrandingLoaded(
            cryptoCoins: [...currentCoins, ...cryptoCoins],
            isLoadingMore: false,
          ));
        } else {
          emit(BrandingLoaded(
            cryptoCoins: cryptoCoins,
            isLoadingMore: false,
          ));
        }
      },
    );
  }

  Future<void> _onRefreshCryptoCoins(
    RefreshCryptoCoins event,
    Emitter<BrandingState> emit,
  ) async {
    emit(BrandingLoading());
    
    final params = GetCryptoCoinsParams(
      page: 1,
      perPage: 20,
      order: 'market_cap_desc',
    );
    
    final result = await _getCryptoCoins(params);
    
    result.fold(
      (failure) => emit(BrandingError(message: _getFailureMessage(failure))),
      (cryptoCoins) => emit(BrandingLoaded(
        cryptoCoins: cryptoCoins,
        isLoadingMore: false,
      )),
    );
  }

  String _getFailureMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return failure.message;
    } else if (failure is ValidationFailure) {
      return failure.message;
    } else {
      return 'An unexpected error occurred';
    }
  }
}
