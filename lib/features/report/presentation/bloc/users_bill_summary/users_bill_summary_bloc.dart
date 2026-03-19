import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/users_bill_summary/get_bill_summary_data.dart';
import '../../../domain/usecases/users_bill_summary/get_users.dart';
import 'users_bill_summary_event.dart';
import 'users_bill_summary_state.dart';

class UsersBillSummaryBloc
    extends Bloc<UsersBillSummaryEvent, UsersBillSummaryState> {
  final GetUsers getUsers;
  final GetBillSummaryData getBillSummaryData;
  UsersBillSummaryBloc({
    required this.getUsers,
    required this.getBillSummaryData,
  }) : super(UsersBillSummaryInitial()) {
    on<GetUsersListEvent>(_onGetUsersList);
    on<GetUserBillSummaryEvent>(_onGetUserBillSummary);
  }
  Future<void> _onGetUsersList(
    GetUsersListEvent event,
    Emitter<UsersBillSummaryState> emit,
  ) async {
    emit(UsersBillSummaryLoading());
    final result = await getUsers();
    result.fold(
      (failure) => emit(const UsersBillSummaryError('Failed to load users')),
      (users) {
        emit(UsersBillSummaryUsersLoaded(users));
        if (users.isNotEmpty) {
          add(GetUserBillSummaryEvent(users.first));
        }
      },
    );
  }

  Future<void> _onGetUserBillSummary(
    GetUserBillSummaryEvent event,
    Emitter<UsersBillSummaryState> emit,
  ) async {
    final currentState = state;
    List<String> users = [];
    if (currentState is UsersBillSummaryUsersLoaded) {
      users = currentState.users;
    } else if (currentState is UsersBillSummaryDataLoaded) {
      users = currentState.users;
    }
    emit(UsersBillSummaryLoading(users: users));
    final result = await getBillSummaryData(event.userId);
    result.fold(
      (failure) => emit(const UsersBillSummaryError('Failed to load summary')),
      (data) => emit(
        UsersBillSummaryDataLoaded(
          users: users,
          summaryData: data,
          selectedUser: event.userId,
        ),
      ),
    );
  }
}