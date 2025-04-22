import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';

abstract interface class IDeleteBookService {
  Future<Either<void, GlobalException>> call(int bookId, int storeId);
}
