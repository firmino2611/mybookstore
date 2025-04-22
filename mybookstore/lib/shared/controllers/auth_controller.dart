import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/core/entities/user_entity.dart';
import 'package:mybookstore/shared/controllers/auth_state.dart';

class AuthController extends Cubit<AuthState> {
  AuthController() : super(const AuthState());

  void setUserLogged(UserEntity user) {
    emit(state.copyWith(userLogged: user));
  }

  UserEntity? getUserLogged() {
    return state.userLogged;
  }
}
