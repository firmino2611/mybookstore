import 'package:mybookstore/core/entities/book_entity.dart';
import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';

abstract interface class ICreateBookService {
  Future<Either<void, GlobalException>> call(BookEntity book, int storeId);
}
