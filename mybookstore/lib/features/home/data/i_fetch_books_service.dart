import 'package:mybookstore/core/entities/book_entity.dart';
import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';

typedef FilterFetchBooks = ({
  String? title,
  String? author,
  double? rating,
  bool? available,
  int? yearStart,
  int? yearEnd,
});

abstract interface class IFetchBooksService {
  Future<Either<List<BookEntity>, GlobalException>> fetchBooks(
    int storeId, [
    FilterFetchBooks? filter,
  ]);
}
