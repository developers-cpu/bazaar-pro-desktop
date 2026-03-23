import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/user/get_nested_users_usecase.dart';
import 'nested_users_event.dart';
import 'nested_users_state.dart';

class NestedUsersBloc extends Bloc<NestedUsersEvent, NestedUsersState> {
  final GetNestedUsers getNestedUsers;
  NestedUsersBloc({required this.getNestedUsers})
    : super(NestedUsersInitial()) {
    on<LoadNestedUsers>(_onLoadNestedUsers);
  }
  Future<void> _onLoadNestedUsers(
    LoadNestedUsers event,
    Emitter<NestedUsersState> emit,
  ) async {
    emit(NestedUsersLoading());
    final result = await getNestedUsers(event.parentUserId);
    result.fold(
      (failure) => emit(NestedUsersError(failure.message)),
      (users) => emit(NestedUsersLoaded(users: users)),
    );
  }
}
