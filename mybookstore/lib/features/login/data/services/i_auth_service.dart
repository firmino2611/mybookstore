import 'package:mybookstore/core/entities/user_entity.dart';
import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';

typedef AuthResponse = ({String token, String refreshToken, UserEntity user});

abstract interface class IAuthService {
  Future<Either<AuthResponse, GlobalException>> call(
    String username,
    String password,
  );
}

abstract interface class IAuthValidateTokenService {
  Future<Either<AuthResponse, GlobalException>> call(String token);
}
