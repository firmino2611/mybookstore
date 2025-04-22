import 'package:flutter/material.dart';
import 'package:mybookstore/shared/constants/routes_name.dart';
import 'package:mybookstore/shared/navigation/navigator_global.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _titleAnimation;
  late Animation<Offset> _logoAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _titleAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 4.2),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );

    _logoAnimation = Tween<Offset>(
      begin: const Offset(0, 10),
      end: const Offset(0, -.5),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.fastOutSlowIn),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () async {
          // final loginController = context.read<LoginController>();
          // final authController = context.read<AuthController>();

          // final result = await loginController.validateToken();

          // if (result) {
          //   authController.setUserLogged(loginController.state.user!);
          //   NavigatorGlobal.get.pushNamed(RoutesName.home);
          // } else {
          NavigatorGlobal.get.pushNamed(RoutesName.login);
          // }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsTheme.primary,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _titleAnimation,
                  child: Text(
                    'BookStore',
                    style: AppTextThemeStyleTheme.bold32.textStyle.copyWith(
                      color: AppColorsTheme.bg,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SlideTransition(
                  position: _logoAnimation,
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset('assets/images/logo-2.png'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
