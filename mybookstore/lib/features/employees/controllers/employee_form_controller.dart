import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/core/entities/employee_entity.dart';
import 'package:mybookstore/core/enums/state_status.dart';
import 'package:mybookstore/features/employees/controllers/employee_form_state.dart';
import 'package:mybookstore/features/employees/data/i_create_employee_service.dart';
import 'package:mybookstore/features/employees/data/i_update_employee_service.dart';

class EmployeeFormController extends Cubit<EmployeeFormState> {
  EmployeeFormController({
    required ICreateEmployeeService createEmployeeService,
    required IUpdateEmployeeService updateEmployeeService,
  })  : _createEmployeeService = createEmployeeService,
        _updateEmployeeService = updateEmployeeService,
        super(const EmployeeFormState());

  final ICreateEmployeeService _createEmployeeService;
  final IUpdateEmployeeService _updateEmployeeService;

  Future<void> saveEmployee(int storeId) async {
    emit(state.copyWith(status: StateStatus.loading));

    final employee = state.toEmployeeEntity();

    if (employee.id == null) {
      await _createEmployeeService.call(employee, storeId);
    } else {
      await _updateEmployeeService.call(employee, storeId);
    }

    emit(state.copyWith(status: StateStatus.success));
  }

  void initWithEmployee(EmployeeEntity? employee) {
    if (employee != null) {
      emit(EmployeeFormState.fromEmployee(employee));
    } else {
      emit(const EmployeeFormState());
    }
  }

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateUsername(String username) {
    emit(state.copyWith(username: username));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void reset() {
    emit(const EmployeeFormState());
  }
}
