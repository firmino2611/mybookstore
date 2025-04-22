import 'package:equatable/equatable.dart';
import 'package:mybookstore/core/entities/user_entity.dart';
import 'package:mybookstore/core/enums/state_status.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = StateStatus.initial,
    this.username = '',
    this.password = '',
    this.user,
  });

  final StateStatus status;

  final UserEntity? user;

  final String username;
  final String password;

  LoginState copyWith({
    StateStatus? status,
    String? username,
    String? password,
    UserEntity? user,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, username, password, user];
}
