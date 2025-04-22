// ignore_for_file: require_trailing_commas

import 'package:eagle_http/eagle_http.dart';
import 'package:mybookstore/core/entities/user_entity.dart';
import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';
import 'package:mybookstore/features/login/data/services/i_auth_service.dart';

class AuthValidateTokenService implements IAuthValidateTokenService {
  AuthValidateTokenService({required this.http});

  final EagleHttpAbstract http;

  @override
  Future<Either<AuthResponse, GlobalException>> call(String token) async {
    try {
      final response = await http.request(
        'v1/auth/validateToken',
        method: EagleHttpMethod.post,
        options: EagleRequest(body: {'refreshToken': token}),
      );

      if (response?.data is Map) {
        http.setHeaders({'Authorization': 'Bearer ${response?.data['token']}'});
        return Either.success((
          token: response?.data['token'],
          refreshToken: response?.data['refreshToken'],
          user: UserEntityFactory.fromJson(response?.data),
        ));
      }

      return Either.failure(ApiError('Erro ao fazer login', ErrorCodes.api));
    } catch (e) {
      return Either.failure(ApiError(e.toString(), ErrorCodes.api));
    }
  }
}
