import 'package:equatable/equatable.dart';
import 'package:mybookstore/core/entities/user_entity.dart';

class AuthState extends Equatable {
  const AuthState({this.userLogged});

  final UserEntity? userLogged;

  AuthState copyWith({UserEntity? userLogged}) {
    return AuthState(userLogged: userLogged ?? this.userLogged);
  }

  @override
  List<Object?> get props => [userLogged];
}
