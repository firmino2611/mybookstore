import 'package:equatable/equatable.dart';
import 'package:mybookstore/core/entities/book_entity.dart';
import 'package:mybookstore/core/enums/state_status.dart';

class HomeContentState extends Equatable {
  const HomeContentState({
    this.books = const [],
    this.status = StateStatus.initial,
    this.searchQuery = '',
    this.titleFilter = '',
    this.authorFilter = '',
    this.ratingFilter,
    this.yearStartFilter,
    this.yearEndFilter,
    this.availableFilter,
  });

  final List<BookEntity> books;
  final StateStatus status;
  final String? searchQuery;
  final String titleFilter;
  final String authorFilter;
  final int? ratingFilter;
  final int? yearStartFilter;
  final int? yearEndFilter;
  final bool? availableFilter;

  HomeContentState copyWith({
    List<BookEntity>? books,
    StateStatus? status,
    String? searchQuery,
    String? titleFilter,
    String? authorFilter,
    int? ratingFilter,
    int? yearStartFilter,
    int? yearEndFilter,
    bool? availableFilter,
  }) {
    return HomeContentState(
      books: books ?? this.books,
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      titleFilter: titleFilter ?? this.titleFilter,
      authorFilter: authorFilter ?? this.authorFilter,
      ratingFilter: ratingFilter ?? this.ratingFilter,
      yearStartFilter: yearStartFilter ?? this.yearStartFilter,
      yearEndFilter: yearEndFilter ?? this.yearEndFilter,
      availableFilter: availableFilter ?? this.availableFilter,
    );
  }

  @override
  List<Object?> get props => [
        books,
        status,
        searchQuery,
        titleFilter,
        authorFilter,
        ratingFilter,
        yearStartFilter,
        yearEndFilter,
        availableFilter,
      ];
}
