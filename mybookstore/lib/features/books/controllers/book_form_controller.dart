import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/core/entities/book_entity.dart';
import 'package:mybookstore/core/enums/state_status.dart';
import 'package:mybookstore/features/books/controllers/book_form_state.dart';
import 'package:mybookstore/features/books/data/i_create_book_service.dart';
import 'package:mybookstore/features/books/data/i_update_book_service.dart';

class BookFormController extends Cubit<BookFormState> {
  BookFormController({
    required ICreateBookService createBookService,
    required IUpdateBookService updateBookService,
  })  : _createBookService = createBookService,
        _updateBookService = updateBookService,
        super(const BookFormState());

  final ICreateBookService _createBookService;
  final IUpdateBookService _updateBookService;

  Future<void> saveBook(int storeId) async {
    emit(state.copyWith(status: StateStatus.loading));

    final book = state.toBookEntity();

    if (book.id == null) {
      await _createBookService.call(book, storeId);
    } else {
      await _updateBookService.call(book, storeId);
    }

    emit(state.copyWith(status: StateStatus.success));
  }

  void updateCurrentTab(int tab) {
    emit(state.copyWith(currentTab: tab));
  }

  void initWithBook(BookEntity? book) {
    if (book != null) {
      emit(BookFormState.fromBook(book));
    } else {
      emit(const BookFormState());
    }
  }

  void updateTitle(String title) {
    emit(state.copyWith(title: title));
  }

  void updateAuthor(String author) {
    emit(state.copyWith(author: author));
  }

  void updateSynopsis(String synopsis) {
    emit(state.copyWith(synopsis: synopsis));
  }

  void updatePublishDate(String publishDate) {
    emit(state.copyWith(publishDate: publishDate));
  }

  void updateRating(int rating) {
    emit(state.copyWith(rating: rating));
  }

  void updateAvailability(bool available) {
    emit(state.copyWith(available: available));
  }

  void updateCover(String coverPath) {
    emit(state.copyWith(cover: coverPath));
  }

  void reset() {
    emit(const BookFormState());
  }
}
