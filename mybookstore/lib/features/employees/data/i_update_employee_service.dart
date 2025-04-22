import 'package:mybookstore/core/entities/employee_entity.dart';
import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';

abstract interface class IUpdateEmployeeService {
  Future<Either<void, GlobalException>> call(
    EmployeeEntity employee,
    int storeId,
  );
}
