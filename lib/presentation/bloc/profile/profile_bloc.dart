import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfileData extends ProfileEvent {}

class RefreshProfileData extends ProfileEvent {}

// States
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> profileData;

  const ProfileLoaded({required this.profileData});

  @override
  List<Object> get props => [profileData];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileData>(_onLoadProfileData);
    on<RefreshProfileData>(_onRefreshProfileData);
  }

  Future<void> _onLoadProfileData(
    LoadProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    emit(ProfileLoaded(
      profileData: {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'phone': '+1 234 567 8900',
        'joinDate': '2024-01-01',
        'totalInvested': 5000.0,
        'totalProfit': 1250.0,
      },
    ));
  }

  Future<void> _onRefreshProfileData(
    RefreshProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    emit(ProfileLoaded(
      profileData: {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'phone': '+1 234 567 8900',
        'joinDate': '2024-01-01',
        'totalInvested': 5000.0,
        'totalProfit': 1250.0,
      },
    ));
  }
}

