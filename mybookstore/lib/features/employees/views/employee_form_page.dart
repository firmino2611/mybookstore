import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/core/entities/employee_entity.dart';
import 'package:mybookstore/core/enums/state_status.dart';
import 'package:mybookstore/features/employees/controllers/employee_form_controller.dart';
import 'package:mybookstore/features/employees/controllers/employee_form_state.dart';
import 'package:mybookstore/features/employees/controllers/employees_controller.dart';
import 'package:mybookstore/shared/components/app_button.dart';
import 'package:mybookstore/shared/components/custom_input.dart';
import 'package:mybookstore/shared/controllers/auth_controller.dart';
import 'package:mybookstore/shared/navigation/navigator_global.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_icons_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';
import 'package:mybookstore/shared/utils/validators.dart';

class EmployeeFormPage extends StatefulWidget {
  const EmployeeFormPage({super.key, this.employee});

  final EmployeeEntity? employee;

  @override
  State<EmployeeFormPage> createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late final EmployeeFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<EmployeeFormController>();
    _controller.initWithEmployee(widget.employee);

    _updateTextFieldsFromState(_controller.state);
  }

  void _updateTextFieldsFromState(EmployeeFormState state) {
    _nameController.text = state.name ?? '';
    _usernameController.text = state.username ?? '';
    _passwordController.text = state.password ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthController>();

    return BlocConsumer<EmployeeFormController, EmployeeFormState>(
      listener: (context, state) {
        if (state.status == StateStatus.success) {
          NavigatorGlobal.get.pop();
          if (widget.employee != null) {
            NavigatorGlobal.get.pop();
          }
          context.read<EmployeesController>().fetchEmployees(
                authController.getUserLogged()!.store!.id!,
              );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColorsTheme.bg,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColorsTheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${widget.employee == null ? 'Novo' : 'Editar'} funcionário',
                          style: AppTextThemeStyleTheme.bold20.textStyle
                              .copyWith(color: AppColorsTheme.headerWeak),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColorsTheme.primary,
                          child: Text(
                            widget.employee?.name
                                    .substring(0, 2)
                                    .toUpperCase() ??
                                '',
                            style: AppTextThemeStyleTheme.bold18.textStyle
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 30),
                        AppInput(
                          controller: _nameController,
                          onChanged: _controller.updateName,
                          hint: 'Nome',
                          validator: const FieldValidator([
                            ValidatorType.isRequired,
                          ]),
                        ),
                        const SizedBox(height: 16),
                        AppInput(
                          controller: _usernameController,
                          onChanged: _controller.updateUsername,
                          hint: 'Usuário',
                          validator: const FieldValidator([
                            ValidatorType.isRequired,
                          ]),
                        ),
                        const SizedBox(height: 16),
                        AppInput(
                          controller: _passwordController,
                          onChanged: _controller.updatePassword,
                          hint: 'Senha',
                          obscureText: true,
                          icon: AppIconsTheme.hide,
                          validator: const FieldValidator([
                            ValidatorType.isRequired,
                            ValidatorType.isStrongPassword,
                          ]),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: AppButton(
                      text: 'Salvar',
                      onPressed: state.isValid
                          ? () => _saveEmployee(authController)
                          : null,
                      isLoading: state.status == StateStatus.loading,
                      backgroundColor: state.isValid
                          ? AppColorsTheme.primary
                          : AppColorsTheme.label.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _saveEmployee(AuthController authController) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _controller.saveEmployee(authController.getUserLogged()!.store!.id!);
    }
  }
}
