import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/core/entities/book_entity.dart';
import 'package:mybookstore/features/books/controllers/book_details_state.dart';
import 'package:mybookstore/features/books/data/i_delete_book_service.dart';
import 'package:mybookstore/features/books/data/i_update_book_service.dart';

class BookDetailsController extends Cubit<BookDetailsState> {
  BookDetailsController({
    required IDeleteBookService deleteBookService,
    required IUpdateBookService updateBookService,
  })  : _deleteBookService = deleteBookService,
        _updateBookService = updateBookService,
        super(const BookDetailsState()) {}

  final IDeleteBookService _deleteBookService;
  final IUpdateBookService _updateBookService;

  Future<void> deleteBook(int bookId, int storeId) async {
    emit(state.copyWith(isLoading: true));
    await _deleteBookService.call(bookId, storeId);

    emit(state.copyWith(isLoading: false));
  }

  Future<void> updateBook(BookEntity book, int storeId) async {
    emit(state.copyWith(isLoading: true));
    await _updateBookService.call(book, storeId);

    emit(state.copyWith(isLoading: false));
  }
}
