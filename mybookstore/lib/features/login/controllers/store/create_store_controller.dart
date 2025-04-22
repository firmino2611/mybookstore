import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/core/entities/store_entity.dart';
import 'package:mybookstore/core/entities/user_entity.dart';
import 'package:mybookstore/core/enums/state_status.dart';
import 'package:mybookstore/features/login/controllers/store/create_store_state.dart';
import 'package:mybookstore/features/login/data/services/i_create_store_service.dart';

class CreateStoreController extends Cubit<CreateStoreState> {
  CreateStoreController({required ICreateStoreService createStoreService})
      : _createStoreService = createStoreService,
        super(const CreateStoreState());

  final ICreateStoreService _createStoreService;

  Future<void> createStore() async {
    final store = StoreEntity(
      name: state.name!,
      slogan: state.slogan!,
      admin: UserEntity(
        name: state.adminName!,
        username: state.adminUsername!,
        password: state.adminPassword!,
      ),
    );

    emit(state.copyWith(status: StateStatus.loading));

    final result = await _createStoreService.call(store);

    result.fold(
      (success) => emit(state.copyWith(status: StateStatus.success)),
      (failure) => emit(state.copyWith(status: StateStatus.error)),
    );
  }

  void setName(String name) {
    emit(state.copyWith(name: name));
  }

  void setSlogan(String slogan) {
    emit(state.copyWith(slogan: slogan));
  }

  void setAdminName(String adminName) {
    emit(state.copyWith(adminName: adminName));
  }

  void setAdminUsername(String adminUsername) {
    emit(state.copyWith(adminUsername: adminUsername));
  }

  void setAdminPassword(String adminPassword) {
    emit(state.copyWith(adminPassword: adminPassword));
  }

  void setAdminPasswordConfirmation(String adminPasswordConfirmation) {
    emit(state.copyWith(adminPasswordConfirmation: adminPasswordConfirmation));
  }
}
