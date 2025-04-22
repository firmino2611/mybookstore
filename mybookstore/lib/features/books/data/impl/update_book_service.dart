import 'package:eagle_http/eagle_http.dart';
import 'package:mybookstore/core/entities/book_entity.dart';
import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';
import 'package:mybookstore/features/books/data/i_update_book_service.dart';

class UpdateBookService implements IUpdateBookService {
  UpdateBookService({required this.http});

  final EagleHttpAbstract http;

  @override
  Future<Either<void, GlobalException>> call(
    BookEntity book,
    int storeId,
  ) async {
    try {
      await http.request(
        'v1/store/$storeId/book/${book.id}',
        method: EagleHttpMethod.put,
        options: EagleRequest(
          body: {
            'title': book.title,
            'author': book.author,
            'synopsis': book.synopsis,
            'year': book.year,
            'rating': book.rating,
            'available': book.available,
          },
        ),
      );

      return Either.success(null);
    } catch (e) {
      return Either.failure(ApiError('Erro ao criar livro', ErrorCodes.api));
    }
  }
}
