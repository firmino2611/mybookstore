import 'package:eagle_http/eagle_http.dart';
import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';
import 'package:mybookstore/features/books/data/i_delete_book_service.dart';

class DeleteBookService implements IDeleteBookService {
  DeleteBookService({required this.http});

  final EagleHttpAbstract http;

  @override
  Future<Either<void, GlobalException>> call(int bookId, int storeId) async {
    try {
      await http.request(
        'v1/store/$storeId/book/$bookId',
        method: EagleHttpMethod.delete,
      );

      return Either.success(null);
    } catch (e) {
      return Either.failure(ApiError('Erro ao deletar livro', ErrorCodes.api));
    }
  }
}
