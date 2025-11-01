import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class TradingEvent extends Equatable {
  const TradingEvent();

  @override
  List<Object> get props => [];
}

class LoadTradingData extends TradingEvent {}

class RefreshTradingData extends TradingEvent {}

// States
abstract class TradingState extends Equatable {
  const TradingState();

  @override
  List<Object> get props => [];
}

class TradingInitial extends TradingState {}

class TradingLoading extends TradingState {}

class TradingLoaded extends TradingState {
  final Map<String, dynamic> tradingData;

  const TradingLoaded({required this.tradingData});

  @override
  List<Object> get props => [tradingData];
}

class TradingError extends TradingState {
  final String message;

  const TradingError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class TradingBloc extends Bloc<TradingEvent, TradingState> {
  TradingBloc() : super(TradingInitial()) {
    on<LoadTradingData>(_onLoadTradingData);
    on<RefreshTradingData>(_onRefreshTradingData);
  }

  Future<void> _onLoadTradingData(
    LoadTradingData event,
    Emitter<TradingState> emit,
  ) async {
    emit(TradingLoading());
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    emit(TradingLoaded(
      tradingData: {
        'balance': 10000.0,
        'profit': 250.0,
        'profitPercentage': 2.5,
        'activeTrades': 5,
      },
    ));
  }

  Future<void> _onRefreshTradingData(
    RefreshTradingData event,
    Emitter<TradingState> emit,
  ) async {
    emit(TradingLoading());
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    emit(TradingLoaded(
      tradingData: {
        'balance': 10000.0,
        'profit': 250.0,
        'profitPercentage': 2.5,
        'activeTrades': 5,
      },
    ));
  }
}

