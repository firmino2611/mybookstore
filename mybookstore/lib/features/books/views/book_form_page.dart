import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/core/entities/book_entity.dart';
import 'package:mybookstore/core/enums/state_status.dart';
import 'package:mybookstore/features/books/controllers/book_form_controller.dart';
import 'package:mybookstore/features/books/controllers/book_form_state.dart';
import 'package:mybookstore/features/books/views/content/book_design.dart';
import 'package:mybookstore/features/home/controllers/home_content_controller.dart';
import 'package:mybookstore/shared/components/app_button.dart';
import 'package:mybookstore/shared/components/app_rating.dart';
import 'package:mybookstore/shared/components/app_switch.dart';
import 'package:mybookstore/shared/components/book_tab_selector.dart';
import 'package:mybookstore/shared/components/custom_input.dart';
import 'package:mybookstore/shared/controllers/auth_controller.dart';
import 'package:mybookstore/shared/navigation/navigator_global.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';

class BookFormPage extends StatefulWidget {
  const BookFormPage({Key? key, this.book}) : super(key: key);
  final BookEntity? book;

  @override
  State<BookFormPage> createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _synopsisController = TextEditingController();
  final _publicationDateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late final BookFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<BookFormController>();
    _controller.initWithBook(widget.book);

    _updateTextFieldsFromState(_controller.state);
  }

  void _updateTextFieldsFromState(BookFormState state) {
    _titleController.text = state.title;
    _authorController.text = state.author;
    _synopsisController.text = state.synopsis;
    _publicationDateController.text = state.publishDate;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthController>();
    final homeController = context.read<HomeContentController>();

    return BlocConsumer<BookFormController, BookFormState>(
      listener: (context, state) {
        if (state.status == StateStatus.success) {
          NavigatorGlobal.get.pop();
          if (widget.book != null) {
            NavigatorGlobal.get.pop();
          }

          homeController.fetchBooks(
            authController.getUserLogged()!.store!.id!,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColorsTheme.bg,
          appBar: AppBar(
            backgroundColor: AppColorsTheme.bg,
            elevation: 0,
            title: Row(
              children: [
                Text(
                  '${widget.book != null ? 'Editar' : 'Cadastrar'} livro',
                  textAlign: TextAlign.start,
                  style: AppTextThemeStyleTheme.bold24.textStyle.copyWith(
                    color: AppColorsTheme.headerWeak,
                  ),
                ),
              ],
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: CircleAvatar(
                backgroundColor: AppColorsTheme.primary,
                child: IconButton(
                  onPressed: () => NavigatorGlobal.get.pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColorsTheme.bg,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          spacing: 16,
                          children: [
                            BookTabSelector(
                              onTabSelected: _controller.updateCurrentTab,
                            ),
                            const SizedBox(height: 24),
                            if (state.currentTab == 0) ...[
                              Image.asset(
                                'assets/images/book-placeholder.png',
                                width: 150,
                              ),
                              const SizedBox(height: 24),
                              AppInput(
                                controller: _titleController,
                                onChanged: _controller.updateTitle,
                                label: 'Título',
                              ),
                              AppInput(
                                controller: _authorController,
                                onChanged: _controller.updateAuthor,
                                label: 'Autor',
                              ),
                              AppInput(
                                controller: _synopsisController,
                                onChanged: _controller.updateSynopsis,
                                label: 'Sinópse',
                                maxLines: 4,
                              ),
                              AppInput(
                                controller: _publicationDateController,
                                onChanged: _controller.updatePublishDate,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (int.tryParse(value ?? '') == null) {
                                    return 'Ano inválido';
                                  }
                                  if (value?.length != 4) {
                                    return 'Ano inválido';
                                  }
                                  return null;
                                },
                                label: 'Ano',
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Avaliação',
                                      style: AppTextThemeStyleTheme
                                          .regular14.textStyle
                                          .copyWith(
                                        color: AppColorsTheme.label,
                                      ),
                                    ),
                                  ),
                                  AppRating(
                                    initialRating: state.rating,
                                    onRatingChanged: (rating) {
                                      _controller.updateRating(rating);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Status',
                                    style: AppTextThemeStyleTheme
                                        .regular14.textStyle
                                        .copyWith(color: AppColorsTheme.label),
                                  ),
                                  AppSwitch(
                                    value: state.available,
                                    label: 'Estoque',
                                    onChanged: (value) {
                                      _controller.updateAvailability(value);
                                    },
                                  ),
                                ],
                              ),
                            ],
                            if (state.currentTab == 1) const BookDesign(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: AppButton(
                      text: 'Salvar',
                      onPressed: state.isValid ? _saveBook : null,
                      isLoading: state.status == StateStatus.loading,
                      backgroundColor: state.isValid
                          ? AppColorsTheme.primary
                          : AppColorsTheme.label.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _saveBook() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authController = context.read<AuthController>();
      await _controller.saveBook(authController.getUserLogged()!.store!.id!);
    }
  }
}
