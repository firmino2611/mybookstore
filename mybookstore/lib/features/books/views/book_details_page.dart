import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/core/entities/book_entity.dart';
import 'package:mybookstore/features/books/controllers/book_details_controller.dart';
import 'package:mybookstore/features/books/controllers/book_details_state.dart';
import 'package:mybookstore/features/home/controllers/home_content_controller.dart';
import 'package:mybookstore/shared/components/app_button.dart';
import 'package:mybookstore/shared/components/app_dialogs.dart';
import 'package:mybookstore/shared/components/app_rating.dart';
import 'package:mybookstore/shared/components/app_switch.dart';
import 'package:mybookstore/shared/constants/routes_name.dart';
import 'package:mybookstore/shared/controllers/auth_controller.dart';
import 'package:mybookstore/shared/navigation/navigator_global.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_icons_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';

class BookDetailsPage extends StatefulWidget {
  const BookDetailsPage({required this.book, Key? key}) : super(key: key);

  final BookEntity book;

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    _isAvailable = widget.book.available ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final bookDetailsController = context.read<BookDetailsController>();
    final authController = context.read<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            backgroundColor: AppColorsTheme.primary,
            radius: 18,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 16,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Container(
                    height: 220,
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/book-placeholder.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.book.title,
                    style: AppTextThemeStyleTheme.bold24.textStyle.copyWith(
                      color: AppColorsTheme.headerWeak,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    widget.book.author,
                    style: AppTextThemeStyleTheme.regular14.textStyle.copyWith(
                      color: AppColorsTheme.body,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sinópse',
                      style: AppTextThemeStyleTheme.semibold16.textStyle
                          .copyWith(color: AppColorsTheme.headerWeak),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.book.synopsis,
                      textAlign: TextAlign.start,
                      style: AppTextThemeStyleTheme.regular14.textStyle
                          .copyWith(color: AppColorsTheme.body),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Publicado em',
                        style: AppTextThemeStyleTheme.semibold14.textStyle
                            .copyWith(color: AppColorsTheme.headerWeak),
                      ),
                      Text(
                        widget.book.year.toString(),
                        style: AppTextThemeStyleTheme.regular14.textStyle
                            .copyWith(color: AppColorsTheme.body),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Avaliação',
                        style: AppTextThemeStyleTheme.regular14.textStyle
                            .copyWith(color: AppColorsTheme.headerWeak),
                      ),
                      AppRating(
                        initialRating: widget.book.rating,
                        readOnly: true,
                        onRatingChanged: (_) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text(
                      //   'Estoque',
                      //   style: AppTextThemeStyleTheme.semibold14.textStyle
                      //       .copyWith(color: AppColorsTheme.headerWeak),
                      // ),
                      AppSwitch(
                        value: _isAvailable,
                        label: 'Estoque',
                        readOnly: authController.getUserLogged()!.isAdmin,
                        onChanged: (value) {
                          setState(() {
                            _isAvailable = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                spacing: 12,
                children: [
                  if (authController.getUserLogged()!.isEmployee)
                    BlocBuilder<BookDetailsController, BookDetailsState>(
                      builder: (context, state) {
                        return AppButton(
                          text: 'Salvar',
                          icon: AppIconsTheme.bookmark,
                          isLoading: state.isLoading,
                          onPressed: () async {
                            await bookDetailsController.updateBook(
                              widget.book.copyWith(available: _isAvailable),
                              authController.getUserLogged()!.store!.id!,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Livro salvo com sucesso'),
                                backgroundColor: AppColorsTheme.primary,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  if (authController.getUserLogged()!.isAdmin) ...[
                    AppButton(
                      text: 'Editar',
                      onPressed: () {
                        NavigatorGlobal.get.pushNamed(
                          RoutesName.bookForm,
                          arguments: widget.book,
                        );
                      },
                    ),
                    AppButton(
                      text: 'Excluir',
                      backgroundColor: AppColorsTheme.bg,
                      textColor: AppColorsTheme.primary,
                      onPressed: () async {
                        final confirm =
                            await AppDialogs.showDeleteConfirmationDialog(
                          context: context,
                          entityName: 'livro',
                          name: widget.book.title,
                        );

                        if (confirm == true) {
                          final user = authController.getUserLogged();
                          await bookDetailsController.deleteBook(
                            widget.book.id!,
                            user!.store!.id!,
                          );
                          context.read<HomeContentController>().fetchBooks(
                                user.store!.id!,
                              );
                          Navigator.pop(context, 'deleted');
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
