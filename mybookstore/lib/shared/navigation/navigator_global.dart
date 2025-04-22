import 'package:flutter/material.dart';
import 'package:mybookstore/shared/navigation/page_transition.dart';

typedef WidgetBuilderArgs = Widget Function(BuildContext context, Object? args);

class NavigatorGlobal {
  NavigatorGlobal._();

  static final _instance = NavigatorGlobal._();
  static GlobalKey<NavigatorState>? _navigatorKey;

  static NavigatorGlobal get get => _instance;

  static set navigatorKey(GlobalKey<NavigatorState> key) {
    _navigatorKey = key;
  }

  static GlobalKey<NavigatorState> get navigatorKey {
    _navigatorKey ??= GlobalKey<NavigatorState>();
    return _navigatorKey!;
  }

  NavigatorState? get state => _navigatorKey?.currentState;

  Future<T?> pushNamed<T>(String route, {Object? arguments}) async {
    return state?.pushNamed<T>(route, arguments: arguments);
  }

  Future<T?> pushReplacementNamed<T, TO>(
    String route, {
    Object? arguments,
    TO? result,
  }) async {
    return state?.pushReplacementNamed<T, TO>(
      route,
      arguments: arguments,
      result: result,
    );
  }

  void pop<T>([T? result]) {
    return state?.pop(result);
  }

  T? args<T>(BuildContext context) =>
      ModalRoute.of(context)?.settings.arguments as T?;
}

class GenerateRoute {
  GenerateRoute(this.routes);

  final Map<String, WidgetBuilderArgs> routes;

  Route<dynamic>? generateRoute(RouteSettings settings, BuildContext context) {
    final routerName = settings.name;
    final routerArgs = settings.arguments;

    final navigateTo = routes[routerName];
    if (navigateTo == null) {
      return null;
    }

    return PageTransition(
      child: navigateTo(context, routerArgs),
      type: PageTransitionType.rightToLeft,
      settings: settings,
    );
  }
}
