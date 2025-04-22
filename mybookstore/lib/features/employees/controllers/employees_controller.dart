import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/core/enums/state_status.dart';
import 'package:mybookstore/features/employees/controllers/employees_state.dart';
import 'package:mybookstore/features/employees/data/i_delete_employee_service.dart';
import 'package:mybookstore/features/employees/data/i_fetch_employees_service.dart';

class EmployeesController extends Cubit<EmployeesState> {
  EmployeesController({
    required IFetchEmployeesService fetchEmployeesService,
    required IDeleteEmployeeService deleteEmployeeService,
  })  : _fetchEmployeesService = fetchEmployeesService,
        _deleteEmployeeService = deleteEmployeeService,
        super(const EmployeesState());

  final IFetchEmployeesService _fetchEmployeesService;
  final IDeleteEmployeeService _deleteEmployeeService;

  Future<void> fetchEmployees(int storeId) async {
    emit(state.copyWith(status: StateStatus.loading));

    final result = await _fetchEmployeesService.call(storeId);

    if (result.isSuccess) {
      emit(
        state.copyWith(status: StateStatus.success, employees: result.success),
      );
      return;
    }

    emit(state.copyWith(status: StateStatus.error));
  }

  Future<void> deleteEmployee(int employeeId, int storeId) async {
    emit(state.copyWith(status: StateStatus.loading));

    final result = await _deleteEmployeeService.call(employeeId, storeId);

    if (result.isFailure) {
      emit(state.copyWith(status: StateStatus.error));
      return;
    }

    await fetchEmployees(storeId);
  }
}
