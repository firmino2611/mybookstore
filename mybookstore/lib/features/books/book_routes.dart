import 'package:mybookstore/core/entities/book_entity.dart';
import 'package:mybookstore/features/books/views/book_details_page.dart';
import 'package:mybookstore/features/books/views/book_form_page.dart';
import 'package:mybookstore/shared/constants/routes_name.dart';
import 'package:mybookstore/shared/navigation/navigator_global.dart';

final Map<String, WidgetBuilderArgs> bookRoutes = {
  RoutesName.bookDetails: (context, args) {
    return BookDetailsPage(book: args as BookEntity);
  },
  RoutesName.bookForm: (context, args) {
    return BookFormPage(book: args as BookEntity?);
  },
};
