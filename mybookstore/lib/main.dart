import 'package:eagle_http/eagle_http.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/app.dart';
import 'package:mybookstore/firebase_options.dart';
import 'package:mybookstore/shared/di/app_providers.dart';
import 'package:mybookstore/shared/navigation/navigator_global.dart';
import 'package:mybookstore/shared/utils/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final eagleHttp = _setupEagleHttp();
  NavigatorGlobal.navigatorKey = GlobalKey<NavigatorState>();

  runApp(
    MultiRepositoryProvider(
      providers: createGlobalRepositoryProviders(eagleHttp),
      child: MultiBlocProvider(
        providers: createAppBlocProviders(),
        child: App(),
      ),
    ),
  );
}

EagleHttp _setupEagleHttp() {
  return EagleHttp(
    baseUrl: Env.apiUrl,
    headers: {
      'Content-Type': 'application/json',
    },
    customError: (error) {
      return EagleError(error: error.message);
    },
  );
}
