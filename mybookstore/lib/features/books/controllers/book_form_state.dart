import 'package:equatable/equatable.dart';
import 'package:mybookstore/core/entities/book_entity.dart';
import 'package:mybookstore/core/enums/state_status.dart';

class BookFormState extends Equatable {
  const BookFormState({
    this.id,
    this.title = '',
    this.author = '',
    this.synopsis = '',
    this.publishDate = '',
    this.rating = 0,
    this.available = true,
    this.status = StateStatus.initial,
    this.errorMessage,
    this.isEditing = false,
    this.bookId,
    this.currentTab = 0,
    this.cover = 'assets/images/book-placeholder.png',
  });

  factory BookFormState.fromBook(BookEntity book) {
    return BookFormState(
      id: book.id,
      title: book.title,
      author: book.author,
      synopsis: book.synopsis,
      publishDate: book.year.toString(),
      rating: book.rating,
      available: book.available ?? true,
      isEditing: true,
      bookId: book.id,
      cover: book.cover,
    );
  }
  final String title;
  final String author;
  final String synopsis;
  final String publishDate;
  final int rating;
  final int? bookId;
  final int? id;

  final bool available;
  final StateStatus status;
  final String? errorMessage;
  final bool isEditing;
  final String cover;
  final int currentTab;

  BookFormState copyWith({
    String? title,
    String? author,
    String? synopsis,
    String? publishDate,
    int? rating,
    bool? available,
    StateStatus? status,
    String? errorMessage,
    bool? isEditing,
    int? bookId,
    String? cover,
    int? currentTab,
  }) {
    return BookFormState(
      title: title ?? this.title,
      author: author ?? this.author,
      synopsis: synopsis ?? this.synopsis,
      publishDate: publishDate ?? this.publishDate,
      rating: rating ?? this.rating,
      available: available ?? this.available,
      status: status ?? this.status,
      errorMessage: errorMessage,
      isEditing: isEditing ?? this.isEditing,
      bookId: bookId ?? this.bookId,
      cover: cover ?? this.cover,
      currentTab: currentTab ?? this.currentTab,
    );
  }

  BookEntity toBookEntity() {
    return BookEntity(
      id: bookId,
      title: title,
      author: author,
      synopsis: synopsis,
      year: int.tryParse(publishDate.split('/').last) ?? DateTime.now().year,
      rating: rating,
      available: available,
      cover: cover,
    );
  }

  bool get isValid {
    return title.isNotEmpty &&
        author.isNotEmpty &&
        synopsis.isNotEmpty &&
        publishDate.isNotEmpty;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        synopsis,
        publishDate,
        rating,
        cover,
        available,
        status,
        errorMessage,
        isEditing,
        bookId,
        currentTab,
      ];
}
