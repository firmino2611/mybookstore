import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/core/enums/state_status.dart';
import 'package:mybookstore/features/login/controllers/login_controller.dart';
import 'package:mybookstore/features/login/controllers/login_state.dart';
import 'package:mybookstore/shared/components/app_button.dart';
import 'package:mybookstore/shared/components/custom_input.dart';
import 'package:mybookstore/shared/constants/routes_name.dart';
import 'package:mybookstore/shared/controllers/auth_controller.dart';
import 'package:mybookstore/shared/navigation/navigator_global.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_icons_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginController = BlocProvider.of<LoginController>(context);
    final authController = BlocProvider.of<AuthController>(context);

    loginController.getCredentials().then((_) {
      _usernameController.text = loginController.state.username;
      _passwordController.text = loginController.state.password;
    });

    return Scaffold(
      backgroundColor: AppColorsTheme.bg,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocConsumer<LoginController, LoginState>(
          listener: (context, state) {
            if (state.status == StateStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erro ao fazer login'),
                  backgroundColor: AppColorsTheme.danger,
                ),
              );
            }
            if (state.status == StateStatus.success) {
              authController.setUserLogged(state.user!);
              NavigatorGlobal.get.pushNamed(RoutesName.home);
            }
          },
          listenWhen: (previous, current) {
            return previous.status != current.status;
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 18,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 64.0),
                  child: Image.asset(
                    'assets/images/logo-1.png',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                AppInput(
                  controller: _usernameController,
                  label: 'Username',
                  onChanged: loginController.setUsername,
                ),
                AppInput(
                  controller: _passwordController,
                  label: 'Senha',
                  icon: AppIconsTheme.hide,
                  onChanged: loginController.setPassword,
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 64.0),
                  child: AppButton(
                    onPressed: loginController.login,
                    text: 'Entrar',
                    isLoading: state.status == StateStatus.loading,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: AppButton(
                    onPressed: () {
                      NavigatorGlobal.get.pushNamed(
                        RoutesName.createStore,
                      );
                    },
                    backgroundColor: AppColorsTheme.bg,
                    textColor: AppColorsTheme.primary,
                    text: 'Cadastre sua loja',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
