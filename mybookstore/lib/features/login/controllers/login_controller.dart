import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/core/enums/state_status.dart';
import 'package:mybookstore/core/extensions/map_extensions.dart';
import 'package:mybookstore/features/login/controllers/login_state.dart';
import 'package:mybookstore/features/login/data/services/i_auth_service.dart';
import 'package:mybookstore/shared/constants/local_keys.dart';
import 'package:mybookstore/shared/drivers/i_db_local_driver.dart';

class LoginController extends Cubit<LoginState> {
  LoginController({
    required IAuthService authService,
    required IDbLocalDriver dbLocalDriver,
    required IAuthValidateTokenService authValidateTokenService,
  })  : _authService = authService,
        _dbLocalDriver = dbLocalDriver,
        _authValidateTokenService = authValidateTokenService,
        super(const LoginState());

  final IAuthService _authService;
  final IAuthValidateTokenService _authValidateTokenService;
  final IDbLocalDriver _dbLocalDriver;

  void setUsername(String username) {
    emit(state.copyWith(username: username));
  }

  void setPassword(String password) {
    emit(state.copyWith(password: password));
  }

  Future<bool> validateToken() async {
    final token = await _dbLocalDriver.select(
      collection: LocalKeys.token,
      doc: LocalKeys.token,
    );

    if (token == null) {
      emit(state.copyWith(status: StateStatus.error));
      return false;
    }

    final result = await _authValidateTokenService.call(
      token.get<String>('refreshToken'),
    );

    if (result.isSuccess) {
      final success = result.success;
      await _dbLocalDriver.add(
        collection: LocalKeys.token,
        value: {
          'token': token,
          'refreshToken': success.refreshToken,
        },
        doc: LocalKeys.token,
      );
      emit(
        state.copyWith(
          status: StateStatus.success,
          user: success.user,
        ),
      );
      return true;
    }

    emit(state.copyWith(status: StateStatus.error));
    return false;
  }

  Future<void> login() async {
    emit(state.copyWith(status: StateStatus.loading));

    final result = await _authService.call(
      state.username,
      state.password,
    );

    result.fold(
      (success) async {
        final token = success.token;
        await _dbLocalDriver.add(
          collection: LocalKeys.token,
          value: {
            'token': token,
            'refreshToken': success.refreshToken,
          },
          doc: LocalKeys.token,
        );

        await saveCredentials();
        emit(
          state.copyWith(
            status: StateStatus.success,
            user: success.user,
          ),
        );
      },
      (error) {
        emit(state.copyWith(status: StateStatus.error));
      },
    );
  }

  Future<void> getCredentials() async {
    final credentials = await _dbLocalDriver.select(
      collection: LocalKeys.credentials,
      doc: LocalKeys.credentials,
    );

    if (credentials != null) {
      emit(
        state.copyWith(
          username: credentials.get<String>('username'),
          password: credentials.get<String>('password'),
        ),
      );
    }
  }

  Future<void> saveCredentials() async {
    await _dbLocalDriver.add(
      collection: LocalKeys.credentials,
      value: {'username': state.username, 'password': state.password},
      doc: LocalKeys.credentials,
    );
  }
}
