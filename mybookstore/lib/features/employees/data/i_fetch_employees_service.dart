import 'package:mybookstore/core/entities/employee_entity.dart';
import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';

abstract interface class IFetchEmployeesService {
  Future<Either<List<EmployeeEntity>, GlobalException>> call(int storeId);
}
