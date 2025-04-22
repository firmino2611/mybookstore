import 'package:equatable/equatable.dart';
import 'package:mybookstore/core/entities/employee_entity.dart';
import 'package:mybookstore/core/enums/state_status.dart';

class EmployeesState extends Equatable {
  const EmployeesState({this.employees, this.status = StateStatus.initial});

  final List<EmployeeEntity>? employees;
  final StateStatus status;

  EmployeesState copyWith({
    List<EmployeeEntity>? employees,
    StateStatus? status,
  }) {
    return EmployeesState(
      employees: employees ?? this.employees,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [employees, status];
}
