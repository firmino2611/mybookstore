import 'package:eagle_http/eagle_http.dart';
import 'package:mybookstore/core/entities/store_entity.dart';
import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';
import 'package:mybookstore/features/login/data/services/i_create_store_service.dart';

class CreateStoreService implements ICreateStoreService {
  CreateStoreService({required this.http});

  final EagleHttpAbstract http;

  @override
  Future<Either<StoreEntity, GlobalException>> call(StoreEntity store) async {
    try {
      final response = await http.request(
        'v1/store',
        method: EagleHttpMethod.post,
        options: EagleRequest(
          body: {
            'name': store.name,
            'slogan': store.slogan,
            'admin': {
              'name': store.admin?.name,
              'username': store.admin?.username,
              'password': store.admin?.password,
            },
          },
        ),
      );

      if (response?.data is Map) {
        return Either.success(StoreEntityFactory.fromJson(response?.data));
      }

      return Either.failure(ApiError('Erro ao criar loja', ErrorCodes.api));
    } catch (e) {
      return Either.failure(ApiError(e.toString(), ErrorCodes.api));
    }
  }
}
