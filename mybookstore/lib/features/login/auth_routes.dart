import 'package:mybookstore/features/login/views/create_store_page.dart';
import 'package:mybookstore/features/login/views/login_page.dart';
import 'package:mybookstore/features/login/views/splash_page.dart'
    show SplashPage;
import 'package:mybookstore/shared/constants/routes_name.dart';
import 'package:mybookstore/shared/navigation/navigator_global.dart';

final Map<String, WidgetBuilderArgs> authRoutes = {
  RoutesName.initial: (context, args) => const SplashPage(),
  RoutesName.login: (context, args) => const LoginPage(),
  RoutesName.createStore: (context, args) => const CreateStorePage(),
};
