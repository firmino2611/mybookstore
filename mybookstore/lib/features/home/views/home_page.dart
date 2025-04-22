import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/features/employees/views/employees_page.dart';
import 'package:mybookstore/features/home/views/contents/home_content.dart';
import 'package:mybookstore/features/profile/views/profile_page.dart';
import 'package:mybookstore/shared/components/app_bottom_navigation.dart';
import 'package:mybookstore/shared/controllers/auth_controller.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_icons_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _pageController = PageController();

  List<AppBottomNavigationItem> _navItems() {
    final authController = context.read<AuthController>();
    return [
      const AppBottomNavigationItem(icon: AppIconsTheme.home, label: 'Home'),
      if (authController.getUserLogged()!.isAdmin) ...[
        const AppBottomNavigationItem(
          icon: AppIconsTheme.search,
          label: 'Funcionários',
        ),
        const AppBottomNavigationItem(
          icon: AppIconsTheme.books,
          label: 'Livros',
        ),
      ],
      if (authController.getUserLogged()!.isEmployee)
        const AppBottomNavigationItem(
          icon: AppIconsTheme.bookmark,
          label: 'Salvos',
        ),
      const AppBottomNavigationItem(
        icon: AppIconsTheme.profile,
        label: 'Perfil',
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Aqui você pode implementar a navegação entre diferentes telas
    // com base no índice selecionado
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userLogged = context.read<AuthController>().getUserLogged();
    return Scaffold(
      backgroundColor: AppColorsTheme.bg,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: PageView(
          children: [
            if (userLogged!.isAdmin) ...[
              const HomeContent(),
              const EmployeesPage(),
              const HomeContent(showFilters: false),
              const ProfilePage(),
            ],
            if (userLogged.isEmployee) ...[
              const HomeContent(),
              const HomeContent(showFilters: false, title: 'Livros salvos'),
              const ProfilePage(),
            ],
          ],
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: _navItems(),
      ),
    );
  }
}

class EmployeesContent extends StatefulWidget {
  const EmployeesContent({super.key});

  @override
  State<EmployeesContent> createState() => _EmployeesContentState();
}

class _EmployeesContentState extends State<EmployeesContent> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
