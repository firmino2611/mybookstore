import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/core/enums/state_status.dart';
import 'package:mybookstore/features/login/controllers/store/create_store_controller.dart';
import 'package:mybookstore/features/login/controllers/store/create_store_state.dart';
import 'package:mybookstore/shared/components/app_button.dart';
import 'package:mybookstore/shared/components/custom_input.dart';
import 'package:mybookstore/shared/navigation/navigator_global.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_icons_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';
import 'package:mybookstore/shared/utils/validators.dart';

class CreateStorePage extends StatefulWidget {
  const CreateStorePage({super.key});

  @override
  State<CreateStorePage> createState() => _CreateStorePageState();
}

class _CreateStorePageState extends State<CreateStorePage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CreateStoreController>();

    return Scaffold(
      backgroundColor: AppColorsTheme.bg,
      appBar: AppBar(
        backgroundColor: AppColorsTheme.bg,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Cadastrar loja',
              textAlign: TextAlign.start,
              style: AppTextThemeStyleTheme.bold24.textStyle.copyWith(
                color: AppColorsTheme.headerWeak,
              ),
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: AppColorsTheme.primary,
            child: IconButton(
              onPressed: () => NavigatorGlobal.get.pop(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColorsTheme.bg,
                size: 16,
              ),
            ),
          ),
        ),
      ),
      body: BlocConsumer<CreateStoreController, CreateStoreState>(
        listener: (context, state) {
          if (state.status == StateStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erro ao criar loja'),
                backgroundColor: AppColorsTheme.danger,
              ),
            );
          }
          if (state.status == StateStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Loja criada com sucesso'),
                backgroundColor: AppColorsTheme.primary,
              ),
            );
            NavigatorGlobal.get.pop();
          }
        },
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: Image.asset(
                        'assets/images/logo-1.png',
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                    AppInput(
                      hint: 'Nome da loja',
                      onChanged: controller.setName,
                      validator: const FieldValidator([
                        ValidatorType.isRequired,
                      ]),
                    ),
                    const SizedBox(height: 16),
                    AppInput(
                      hint: 'Slogan da loja',
                      onChanged: controller.setSlogan,
                      validator: const FieldValidator([
                        ValidatorType.isRequired,
                      ]),
                    ),
                    const SizedBox(height: 16),
                    AppInput(
                      hint: 'Nome do administrador',
                      onChanged: controller.setAdminName,
                      validator: const FieldValidator([
                        ValidatorType.isRequired,
                      ]),
                    ),
                    const SizedBox(height: 16),
                    AppInput(
                      hint: 'Usuário do administrador',
                      onChanged: controller.setAdminUsername,
                      validator: const FieldValidator([
                        ValidatorType.isRequired,
                      ]),
                    ),
                    const SizedBox(height: 16),
                    AppInput(
                      controller: _passwordController,
                      hint: 'Senha',
                      icon: AppIconsTheme.hide,
                      obscureText: true,
                      onChanged: controller.setAdminPassword,
                      validator: const FieldValidator([
                        ValidatorType.isRequired,
                        ValidatorType.isStrongPassword,
                      ]),
                    ),
                    const SizedBox(height: 16),
                    AppInput(
                      controller: _passwordConfirmationController,
                      hint: 'Repetir senha',
                      icon: AppIconsTheme.hide,
                      obscureText: true,
                      onChanged: controller.setAdminPasswordConfirmation,
                      validator: (value) {
                        final requiredError = ValidatorActions.isRequired(
                          value,
                        );
                        if (requiredError != null) {
                          return requiredError;
                        }

                        return ValidatorActions.isPasswordMatch(
                          value,
                          _passwordController.text,
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      text: 'Salvar',
                      isLoading: state.status == StateStatus.loading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.createStore();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
