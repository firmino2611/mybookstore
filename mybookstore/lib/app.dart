import 'package:flutter/material.dart';
import 'package:mybookstore/features/books/book_routes.dart';
import 'package:mybookstore/features/employees/employee_routes.dart';
import 'package:mybookstore/features/home/home_routes.dart';
import 'package:mybookstore/features/login/auth_routes.dart';
import 'package:mybookstore/features/profile/profile_routes.dart';
import 'package:mybookstore/shared/constants/routes_name.dart';
import 'package:mybookstore/shared/navigation/navigator_global.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/utils/env.dart';

class App extends StatelessWidget {
  App({super.key});

  final Map<String, WidgetBuilderArgs> baseRoutes = {
    ...authRoutes,
    ...homeRoutes,
    ...employeesRoutes,
    ...bookRoutes,
    ...profileRoutes,
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Book Store',
      navigatorKey: NavigatorGlobal.navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: RoutesName.initial,
      onGenerateRoute: (settings) {
        return GenerateRoute(baseRoutes).generateRoute(
          settings,
          context,
        )!;
      },
      theme: ThemeData(useMaterial3: true),
      builder: (context, child) {
        return Banner(
          message: Env.env,
          location: BannerLocation.topStart,
          color:
              Env.env == 'PROD' ? AppColorsTheme.primary : AppColorsTheme.body,
          child: child!,
        );
      },
    );
  }
}
