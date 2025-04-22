import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/core/entities/employee_entity.dart';
import 'package:mybookstore/core/enums/state_status.dart';
import 'package:mybookstore/features/employees/controllers/employees_controller.dart';
import 'package:mybookstore/features/employees/controllers/employees_state.dart';
import 'package:mybookstore/shared/components/app_dialogs.dart';
import 'package:mybookstore/shared/components/app_icon.dart';
import 'package:mybookstore/shared/constants/routes_name.dart';
import 'package:mybookstore/shared/controllers/auth_controller.dart';
import 'package:mybookstore/shared/navigation/navigator_global.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_icons_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthController>();
    final employeesController = context.read<EmployeesController>();

    employeesController.fetchEmployees(
      authController.getUserLogged()!.store!.id!,
    );

    return Scaffold(
      backgroundColor: AppColorsTheme.bg,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Funcionários',
                    style: AppTextThemeStyleTheme.bold32.textStyle.copyWith(
                      color: AppColorsTheme.headerWeak,
                    ),
                  ),
                ),
                BlocBuilder<EmployeesController, EmployeesState>(
                  builder: (context, state) {
                    if (state.status == StateStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.status == StateStatus.error) {
                      return const Center(
                        child: Text('Erro ao buscar funcionários'),
                      );
                    }

                    if (state.employees == null || state.employees!.isEmpty) {
                      return const Text('Nenhum funcionário encontrado');
                    }

                    return Expanded(
                      child: ListView.separated(
                        itemCount: state.employees?.length ?? 0,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return EmployeeCard(
                            employee: state.employees![index],
                            storeId: authController.getUserLogged()!.store!.id!,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            right: 0,
            child: FloatingActionButton(
              onPressed: () {
                NavigatorGlobal.get.pushNamed(RoutesName.employeeForm);
              },
              child: const Icon(Icons.add, color: Colors.white),
              backgroundColor: AppColorsTheme.primary,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    required this.employee,
    required this.storeId,
    super.key,
  });

  final EmployeeEntity employee;
  final int storeId;

  @override
  Widget build(BuildContext context) {
    final employeesController = context.read<EmployeesController>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColorsTheme.bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColorsTheme.primary,
            child: Text(
              employee.name.substring(0, 2).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              employee.name,
              style: AppTextThemeStyleTheme.semibold14.textStyle.copyWith(
                color: AppColorsTheme.body,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              NavigatorGlobal.get.pushNamed(
                RoutesName.employeeForm,
                arguments: employee,
              );
            },
            child: const AppIcon(
              AppIconsTheme.edit,
              color: AppColorsTheme.headerWeak,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () async {
              final confirm = await AppDialogs.showDeleteConfirmationDialog(
                context: context,
                entityName: 'funcionário',
                name: employee.name,
              );

              if (confirm == true) {
                await employeesController.deleteEmployee(employee.id!, storeId);
              }
            },
            child: const AppIcon(
              AppIconsTheme.delete,
              color: AppColorsTheme.headerWeak,
            ),
          ),
        ],
      ),
    );
  }
}
