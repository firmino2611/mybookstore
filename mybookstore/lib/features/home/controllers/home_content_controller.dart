import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/core/entities/book_entity.dart';
import 'package:mybookstore/core/enums/state_status.dart';
import 'package:mybookstore/features/home/controllers/home_content_state.dart';
import 'package:mybookstore/features/home/data/i_fetch_books_service.dart';

class HomeContentController extends Cubit<HomeContentState> {
  HomeContentController({required IFetchBooksService fetchBooksService})
      : _fetchBooksService = fetchBooksService,
        super(const HomeContentState());

  final IFetchBooksService _fetchBooksService;

  Future<void> fetchBooks(int storeId) async {
    emit(state.copyWith(status: StateStatus.loading));

    final filter = (
      title: state.titleFilter.isNotEmpty ? state.titleFilter : null,
      author: state.authorFilter.isNotEmpty ? state.authorFilter : null,
      rating:
          state.ratingFilter != null ? state.ratingFilter!.toDouble() : null,
      available: state.availableFilter,
      yearStart: state.yearStartFilter,
      yearEnd: state.yearEndFilter,
    );

    final result = await _fetchBooksService.fetchBooks(storeId, filter);

    if (result.isSuccess) {
      emit(state.copyWith(status: StateStatus.success, books: result.success));
      return;
    }

    emit(state.copyWith(status: StateStatus.error));
  }

  List<BookEntity> searchBooks() {
    if (state.searchQuery?.isEmpty ?? true) {
      return state.books;
    }

    return state.books.where((book) {
      return book.title.toLowerCase().contains(
            state.searchQuery?.toLowerCase() ?? '',
          );
    }).toList();
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setTitleFilter(String title) {
    emit(state.copyWith(titleFilter: title));
  }

  void setAuthorFilter(String author) {
    emit(state.copyWith(authorFilter: author));
  }

  void setRatingFilter(int rating) {
    emit(state.copyWith(ratingFilter: rating));
  }

  void setYearRange(int start, int end) {
    emit(state.copyWith(yearStartFilter: start, yearEndFilter: end));
  }

  void setAvailableFilter(bool available) {
    emit(state.copyWith(availableFilter: available));
  }

  bool filtersHasApplied() {
    return state.titleFilter.isNotEmpty ||
        state.authorFilter.isNotEmpty ||
        state.ratingFilter != null ||
        state.yearStartFilter != null ||
        state.yearEndFilter != null ||
        state.availableFilter != null;
  }

  void resetFilters() {
    emit(HomeContentState(books: state.books));
  }
}
