import 'package:mybookstore/features/home/views/home_page.dart';
import 'package:mybookstore/shared/constants/routes_name.dart';
import 'package:mybookstore/shared/navigation/navigator_global.dart';

final Map<String, WidgetBuilderArgs> homeRoutes = {
  RoutesName.home: (context, args) => const HomePage(),
};
