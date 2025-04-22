import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/core/enums/state_status.dart';
import 'package:mybookstore/features/home/controllers/home_content_controller.dart';
import 'package:mybookstore/features/home/controllers/home_content_state.dart';
import 'package:mybookstore/features/home/views/widgets/book_card.dart';
import 'package:mybookstore/shared/components/app_button.dart';
import 'package:mybookstore/shared/components/app_icon.dart';
import 'package:mybookstore/shared/components/app_rating.dart';
import 'package:mybookstore/shared/components/app_slider.dart';
import 'package:mybookstore/shared/components/app_switch.dart';
import 'package:mybookstore/shared/components/custom_input.dart';
import 'package:mybookstore/shared/constants/routes_name.dart';
import 'package:mybookstore/shared/controllers/auth_controller.dart';
import 'package:mybookstore/shared/navigation/navigator_global.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_icons_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';
import 'package:mybookstore/shared/utils/events_analitycs.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key, this.showFilters = true, this.title});

  final bool showFilters;
  final String? title;

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthController>();
    final homeContentController = context.read<HomeContentController>();

    homeContentController.fetchBooks(
      authController.getUserLogged()?.store?.id ?? 0,
    );

    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showFilters) ...[
                  Image.asset(
                    'assets/images/logo-3.png',
                    width: 55,
                    height: 55,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Olá, ${authController.getUserLogged()?.name} 👋🏼',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextThemeStyleTheme.bold32.textStyle.copyWith(
                      color: AppColorsTheme.headerWeak,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      const SizedBox(width: 1),
                      Expanded(
                        child: AppInput(
                          hint: 'Pesquisar',
                          icon: AppIconsTheme.search,
                          onChanged: homeContentController.setSearchQuery,
                        ),
                      ),
                      const SizedBox(width: 16),
                      BlocBuilder<HomeContentController, HomeContentState>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return FilterModal(onApply: _onApply);
                                },
                              );
                            },
                            child: Stack(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 4,
                                  ),
                                  child: AppIcon(
                                    AppIconsTheme.filter,
                                    width: 32,
                                    color: AppColorsTheme.headerWeak,
                                  ),
                                ),
                                if (homeContentController.filtersHasApplied())
                                  const Positioned(
                                    right: 0,
                                    child: Icon(
                                      Icons.circle,
                                      size: 20,
                                      color: AppColorsTheme.primary,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
                if (!widget.showFilters)
                  Text(
                    widget.title ?? 'Livros',
                    style: AppTextThemeStyleTheme.bold32.textStyle.copyWith(
                      color: AppColorsTheme.headerWeak,
                    ),
                  ),
                SizedBox(height: widget.showFilters ? 40 : 12),
                if (widget.showFilters)
                  Text(
                    'Todos os livros',
                    style: AppTextThemeStyleTheme.semibold20.textStyle.copyWith(
                      color: AppColorsTheme.headerWeak,
                    ),
                  ),
                BlocBuilder<HomeContentController, HomeContentState>(
                  buildWhen: (previous, current) {
                    return previous.searchQuery != current.searchQuery ||
                        previous.status != current.status;
                  },
                  builder: (context, state) {
                    if (state.status == StateStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColorsTheme.primary,
                        ),
                      );
                    }

                    if (state.status == StateStatus.error) {
                      return const Text('Erro ao carregar livros');
                    }

                    if (homeContentController.searchBooks().isEmpty) {
                      return Text(
                        'Nenhum livro encontrado',
                        style: AppTextThemeStyleTheme.regular14.textStyle,
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.55,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 24,
                      ),
                      itemCount: homeContentController.searchBooks().length,
                      itemBuilder: (context, index) {
                        final book = homeContentController.searchBooks()[index];
                        return GestureDetector(
                          onTap: () {
                            EventAnalitycs.logEvent(
                              'click_book',
                              args: {
                                'id': book.id.toString(),
                                'title': book.title,
                              },
                            );
                            NavigatorGlobal.get.pushNamed(
                              RoutesName.bookDetails,
                              arguments: book,
                            );
                          },
                          child: BookCard(book: book),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        if (!widget.showFilters && authController.getUserLogged()!.isAdmin)
          Positioned(
            bottom: 24,
            right: 0,
            child: FloatingActionButton(
              onPressed: () {
                NavigatorGlobal.get.pushNamed(RoutesName.bookForm);
              },
              elevation: 0,
              backgroundColor: AppColorsTheme.primary,
              child: const Icon(Icons.add, color: AppColorsTheme.bg),
            ),
          ),
      ],
    );
  }

  void _onApply() {
    final authController = context.read<AuthController>();
    final homeContentController = context.read<HomeContentController>();

    homeContentController.fetchBooks(
      authController.getUserLogged()?.store?.id ?? 0,
    );
    Navigator.pop(context);
  }
}

class FilterModal extends StatefulWidget {
  const FilterModal({required this.onApply, super.key});

  final VoidCallback onApply;

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  int? rating;
  bool? available;
  int? yearStart;
  int? yearEnd;

  @override
  void initState() {
    super.initState();
    final controller = context.read<HomeContentController>();
    final state = controller.state;

    titleController.text = state.titleFilter;
    authorController.text = state.authorFilter;
    rating = state.ratingFilter;
    available = state.availableFilter;
    yearStart = state.yearStartFilter;
    yearEnd = state.yearEndFilter;
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<HomeContentController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Filtrar',
                    textAlign: TextAlign.center,
                    style: AppTextThemeStyleTheme.bold20.textStyle.copyWith(
                      color: AppColorsTheme.headerWeak,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 32),
            AppInput(
              hint: 'Pesquisar por título',
              controller: titleController,
              onChanged: controller.setTitleFilter,
            ),
            const SizedBox(height: 16),
            AppInput(
              hint: 'Pesquisar por autor',
              controller: authorController,
              onChanged: controller.setAuthorFilter,
            ),
            const SizedBox(height: 45),
            CustomRangeSlider(
              initialStart: yearStart ?? 1990,
              initialEnd: yearEnd ?? 2025,
              onChanged: (start, end) {
                setState(() {
                  yearStart = start;
                  yearEnd = end;
                });
                controller.setYearRange(start, end);
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Avaliação',
                    style: AppTextThemeStyleTheme.regular14.textStyle.copyWith(
                      color: AppColorsTheme.label,
                    ),
                  ),
                ),
                AppRating(
                  initialRating: rating ?? 0,
                  onRatingChanged: (value) {
                    setState(() {
                      rating = value;
                    });
                    controller.setRatingFilter(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Status',
                    style: AppTextThemeStyleTheme.regular14.textStyle.copyWith(
                      color: AppColorsTheme.label,
                    ),
                  ),
                ),
                AppSwitch(
                  label: 'Estoque',
                  value: available ?? true,
                  onChanged: (value) {
                    setState(() {
                      available = value;
                    });
                    controller.setAvailableFilter(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              spacing: 12,
              children: [
                if (controller.filtersHasApplied())
                  Flexible(
                    child: AppButton(
                      text: 'Limpar',
                      onPressed: () {
                        controller.resetFilters();
                        widget.onApply();
                      },
                      backgroundColor: AppColorsTheme.bg,
                      textColor: AppColorsTheme.headerWeak,
                    ),
                  ),
                Flexible(
                  child: AppButton(text: 'Aplicar', onPressed: widget.onApply),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
