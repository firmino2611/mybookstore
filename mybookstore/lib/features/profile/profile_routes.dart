import 'package:mybookstore/features/profile/views/profile_page.dart';
import 'package:mybookstore/shared/constants/routes_name.dart';
import 'package:mybookstore/shared/navigation/navigator_global.dart';

final Map<String, WidgetBuilderArgs> profileRoutes = {
  RoutesName.profile: (context, args) => const ProfilePage(),
};
