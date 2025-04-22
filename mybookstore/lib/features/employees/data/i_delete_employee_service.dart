import 'package:mybookstore/core/errors/either.dart';
import 'package:mybookstore/core/errors/errors.dart';

abstract interface class IDeleteEmployeeService {
  Future<Either<void, GlobalException>> call(int employeeId, int storeId);
}
