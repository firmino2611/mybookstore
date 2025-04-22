import 'package:eagle_http/eagle_http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/features/books/controllers/book_details_controller.dart';
import 'package:mybookstore/features/books/controllers/book_form_controller.dart';
import 'package:mybookstore/features/books/data/impl/create_book_service.dart';
import 'package:mybookstore/features/books/data/impl/delete_book_service.dart';
import 'package:mybookstore/features/books/data/impl/update_book_service.dart';
import 'package:mybookstore/features/employees/controllers/employee_form_controller.dart';
import 'package:mybookstore/features/employees/controllers/employees_controller.dart';
import 'package:mybookstore/features/employees/data/impl/create_employee_service.dart';
import 'package:mybookstore/features/employees/data/impl/delete_employee_service.dart';
import 'package:mybookstore/features/employees/data/impl/fetch_employee_service.dart';
import 'package:mybookstore/features/employees/data/impl/update_employee_service.dart';
import 'package:mybookstore/features/home/controllers/home_content_controller.dart';
import 'package:mybookstore/features/home/data/impl/fetch_books_service.dart';
import 'package:mybookstore/features/login/controllers/login_controller.dart';
import 'package:mybookstore/features/login/controllers/store/create_store_controller.dart';
import 'package:mybookstore/features/login/data/services/impl/auth_service.dart';
import 'package:mybookstore/features/login/data/services/impl/auth_validate_token_service.dart';
import 'package:mybookstore/features/login/data/services/impl/create_store_service.dart';
import 'package:mybookstore/shared/controllers/auth_controller.dart';
import 'package:mybookstore/shared/drivers/i_db_local_driver.dart';
import 'package:mybookstore/shared/drivers/impl/local_store_drive.dart';

List<RepositoryProvider> createGlobalRepositoryProviders(EagleHttp eagleHttp) {
  return [
    RepositoryProvider<EagleHttp>(create: (_) => eagleHttp),
    RepositoryProvider<IDbLocalDriver>(create: (_) => LocalStoreDriver()),
  ];
}

List<BlocProvider> createAppBlocProviders() {
  return [
    ...createSharedProviders(),
    ...createLoginProviders(),
    ...createHomeProviders(),
    ...createEmployeesProviders(),
    ...createBooksProviders(),
  ];
}

List<BlocProvider> createSharedProviders() {
  return [
    BlocProvider<AuthController>(create: (_) => AuthController()),
  ];
}

List<BlocProvider> createLoginProviders() {
  return [
    BlocProvider<LoginController>(
      create: (context) => LoginController(
        authService: AuthService(http: context.read<EagleHttp>()),
        dbLocalDriver: context.read<IDbLocalDriver>(),
        authValidateTokenService: AuthValidateTokenService(
          http: context.read<EagleHttp>(),
        ),
      ),
    ),
    BlocProvider<CreateStoreController>(
      create: (context) => CreateStoreController(
        createStoreService: CreateStoreService(
          http: context.read<EagleHttp>(),
        ),
      ),
    ),
  ];
}

List<BlocProvider> createHomeProviders() {
  return [
    BlocProvider<HomeContentController>(
      create: (context) => HomeContentController(
        fetchBooksService: FetchBooksService(
          http: context.read<EagleHttp>(),
        ),
      ),
    ),
  ];
}

List<BlocProvider> createEmployeesProviders() {
  return [
    BlocProvider<EmployeesController>(
      create: (context) => EmployeesController(
        fetchEmployeesService: FetchEmployeesService(
          http: context.read<EagleHttp>(),
        ),
        deleteEmployeeService: DeleteEmployeeService(
          http: context.read<EagleHttp>(),
        ),
      ),
    ),
    BlocProvider<EmployeeFormController>(
      create: (context) => EmployeeFormController(
        createEmployeeService: CreateEmployeeService(
          http: context.read<EagleHttp>(),
        ),
        updateEmployeeService: UpdateEmployeeService(
          http: context.read<EagleHttp>(),
        ),
      ),
    ),
  ];
}

List<BlocProvider> createBooksProviders() {
  return [
    BlocProvider<BookDetailsController>(
      create: (context) => BookDetailsController(
        deleteBookService: DeleteBookService(
          http: context.read<EagleHttp>(),
        ),
        updateBookService: UpdateBookService(
          http: context.read<EagleHttp>(),
        ),
      ),
    ),
    BlocProvider<BookFormController>(
      create: (context) => BookFormController(
        createBookService: CreateBookService(
          http: context.read<EagleHttp>(),
        ),
        updateBookService: UpdateBookService(
          http: context.read<EagleHttp>(),
        ),
      ),
    ),
  ];
}
