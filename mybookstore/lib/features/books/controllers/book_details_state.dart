import 'package:equatable/equatable.dart';
import 'package:mybookstore/core/entities/book_entity.dart';

class BookDetailsState extends Equatable {
  const BookDetailsState({this.book, this.isLoading = false});

  final BookEntity? book;
  final bool isLoading;

  BookDetailsState copyWith({BookEntity? book, bool? isLoading}) {
    return BookDetailsState(
      book: book ?? this.book,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [book, isLoading];
}
