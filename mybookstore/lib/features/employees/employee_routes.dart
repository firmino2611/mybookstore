import 'package:mybookstore/core/entities/employee_entity.dart';
import 'package:mybookstore/features/employees/views/employee_form_page.dart';
import 'package:mybookstore/features/employees/views/employees_page.dart';
import 'package:mybookstore/shared/constants/routes_name.dart';
import 'package:mybookstore/shared/navigation/navigator_global.dart';

final Map<String, WidgetBuilderArgs> employeesRoutes = {
  RoutesName.employees: (context, args) => const EmployeesPage(),
  RoutesName.employeeForm: (context, args) {
    return EmployeeFormPage(employee: args as EmployeeEntity?);
  },
};
