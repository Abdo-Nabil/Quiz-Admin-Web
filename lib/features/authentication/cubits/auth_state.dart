part of 'auth_cubit.dart';

@immutable
abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthStartLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthEndLoadingStateWithError extends AuthState {
  final String msg;
  AuthEndLoadingStateWithError(this.msg);
  @override
  List<Object?> get props => [msg];
}

class AuthEndLoadingToHomeScreen extends AuthState {
  @override
  List<Object?> get props => [];
}
