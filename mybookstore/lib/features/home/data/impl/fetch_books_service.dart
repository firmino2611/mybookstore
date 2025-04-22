import 'package:eagle_http/eagle_http.dart';
import 'package:mybookstore/core/entities/book_entity.dart';
import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';
import 'package:mybookstore/core/extensions/map_extensions.dart';
import 'package:mybookstore/features/home/data/i_fetch_books_service.dart';

class FetchBooksService implements IFetchBooksService {
  FetchBooksService({required this.http});

  final EagleHttpAbstract http;

  @override
  Future<Either<List<BookEntity>, GlobalException>> fetchBooks(
    int storeId, [
    FilterFetchBooks? filter,
  ]) async {
    try {
      final response = await http.request(
        'v1/store/$storeId/book',
        method: EagleHttpMethod.get,
        options: EagleRequest(
          queryParameters: {
            'title': filter?.title,
            'author': filter?.author,
            'rating': filter?.rating?.ceil().toString(),
            'available': filter?.available,
            'year-start': filter?.yearStart?.toString(),
            'year-finish': filter?.yearEnd?.toString(),
          }.removeNulls(),
        ),
      );

      if (response?.data is List) {
        return Either.success(
          (response?.data as List)
              .map((e) => BookEntityFactory.fromJson(e))
              .toList(),
        );
      }
      return Either.failure(ApiError('Erro ao fazer login', ErrorCodes.api));
    } catch (e) {
      return Either.failure(ApiError(e.toString(), ErrorCodes.api));
    }
  }
}
