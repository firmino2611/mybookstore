import 'package:mybookstore/core/entities/store_entity.dart';
import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';

abstract interface class ICreateStoreService {
  Future<Either<StoreEntity, GlobalException>> call(StoreEntity store);
}
