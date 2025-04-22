import 'package:firebase_analytics/firebase_analytics.dart';

abstract class EventAnalitycs {
  static Future<void> logEvent(
    String event, {
    Map<String, Object>? args,
  }) async {
    final analitycs = FirebaseAnalytics.instance;
    await analitycs.logEvent(name: event, parameters: args);
  }

  static Future<void> onScreenView(String screen) async {
    final analitycs = FirebaseAnalytics.instance;
    await analitycs.logScreenView(screenName: screen);
  }
}
