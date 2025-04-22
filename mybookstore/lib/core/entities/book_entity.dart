import 'package:mybookstore/core/extensions/map_extensions.dart';

class BookEntity {
  BookEntity({
    required this.cover,
    required this.title,
    required this.author,
    required this.synopsis,
    required this.year,
    required this.rating,
    this.id,
    this.available = true,
  });

  final int? id;
  final String cover;
  final String title;
  final String author;
  final String synopsis;
  final int year;
  final int rating;
  final bool? available;

  BookEntity copyWith({
    int? id,
    String? cover,
    String? title,
    String? author,
    String? synopsis,
    int? year,
    int? rating,
    bool? available,
  }) {
    return BookEntity(
      available: available ?? this.available,
      cover: cover ?? this.cover,
      title: title ?? this.title,
      author: author ?? this.author,
      synopsis: synopsis ?? this.synopsis,
      year: year ?? this.year,
      rating: rating ?? this.rating,
      id: id ?? this.id,
    );
  }
}

class BookEntityFactory {
  static BookEntity fromJson(Map<String, dynamic> json) {
    return BookEntity(
      author: json.get<String>('author'),
      available: json.get<bool>('available'),
      cover: json.get<String?>('cover') ?? '',
      synopsis: json.get<String>('synopsis'),
      title: json.get<String>('title'),
      year: json.get<int>('year'),
      rating: json.get<int>('rating'),
      id: json.get<int?>('id'),
    );
  }
}
