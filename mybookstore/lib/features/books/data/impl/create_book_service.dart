import 'package:eagle_http/eagle_http.dart';
import 'package:mybookstore/core/entities/book_entity.dart';
import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';
import 'package:mybookstore/features/books/data/i_create_book_service.dart';

class CreateBookService implements ICreateBookService {
  CreateBookService({required this.http});

  final EagleHttpAbstract http;

  @override
  Future<Either<void, GlobalException>> call(
    BookEntity book,
    int storeId,
  ) async {
    try {
      await http.request(
        'v1/store/$storeId/book',
        method: EagleHttpMethod.post,
        options: EagleRequest(
          body: {
            'title': book.title,
            'author': book.author,
            'synopsis': book.synopsis,
            'year': book.year,
            'rating': book.rating,
          },
        ),
      );

      return Either.success(null);
    } catch (e) {
      return Either.failure(ApiError('Erro ao criar livro', ErrorCodes.api));
    }
  }
}
