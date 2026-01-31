import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/user/get_users.dart';
import '../../../domain/usecases/user/get_users_with_filters.dart';
import '../../../domain/usecases/user/get_user_types.dart';
import '../../../domain/usecases/user/get_user_statuses.dart';
import '../../../domain/usecases/user/export_users_to_pdf.dart';
import '../../../domain/usecases/user/export_users_to_excel.dart';
import 'user_list_event.dart';
import 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final GetUsers getUsers;
  final GetUsersWithFilters getUsersWithFilters;
  final GetUserTypes getUserTypes;
  final GetUserStatuses getUserStatuses;
  final ExportUsersToPdf exportUsersToPdf;
  final ExportUsersToExcel exportUsersToExcel;

  UserListBloc({
    required this.getUsers,
    required this.getUsersWithFilters,
    required this.getUserTypes,
    required this.getUserStatuses,
    required this.exportUsersToPdf,
    required this.exportUsersToExcel,
  }) : super(const UserListInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<FilterByUserTypeEvent>(_onFilterByUserType);
    on<FilterByUserStatusEvent>(_onFilterByUserStatus);
    on<ApplyFiltersEvent>(_onApplyFilters);
    on<ResetFiltersEvent>(_onResetFilters);
    on<SortByColumnEvent>(_onSortByColumn);
    on<ExportToPdfEvent>(_onExportToPdf);
    on<ExportToExcelEvent>(_onExportToExcel);
    on<SelectUserEvent>(_onSelectUser);
  }

  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter<UserListState> emit,
  ) async {
    emit(const UserListLoading());

    try {
      final result = await getUsers(NoParams());
      final types = getUserTypes();
      final statuses = getUserStatuses();

      result.fold(
        (failure) => emit(UserListError(failure.message)),
        (users) => emit(
          UserListLoaded(
            allUsers: users,
            filteredUsers: users,
            userTypes: types,
            userStatuses: statuses,
            totalRecords: users.length,
          ),
        ),
      );
    } catch (e) {
      emit(UserListError(e.toString()));
    }
  }

  Future<void> _onFilterByUserType(
    FilterByUserTypeEvent event,
    Emitter<UserListState> emit,
  ) async {
    if (state is UserListLoaded) {
      final currentState = state as UserListLoaded;

      final result = await getUsersWithFilters(
        UserFilterParams(
          userType: event.userType,
          userStatus: currentState.selectedUserStatus,
        ),
      );

      result.fold(
        (failure) => emit(UserListError(failure.message)),
        (filtered) => emit(
          currentState.copyWith(
            selectedUserType: event.userType,
            filteredUsers: filtered,
            totalRecords: filtered.length,
            clearUserType: event.userType == null || event.userType!.isEmpty,
          ),
        ),
      );
    }
  }

  Future<void> _onFilterByUserStatus(
    FilterByUserStatusEvent event,
    Emitter<UserListState> emit,
  ) async {
    if (state is UserListLoaded) {
      final currentState = state as UserListLoaded;

      final result = await getUsersWithFilters(
        UserFilterParams(
          userType: currentState.selectedUserType,
          userStatus: event.userStatus,
        ),
      );

      result.fold(
        (failure) => emit(UserListError(failure.message)),
        (filtered) => emit(
          currentState.copyWith(
            selectedUserStatus: event.userStatus,
            filteredUsers: filtered,
            totalRecords: filtered.length,
            clearUserStatus:
                event.userStatus == null || event.userStatus!.isEmpty,
          ),
        ),
      );
    }
  }

  Future<void> _onApplyFilters(
    ApplyFiltersEvent event,
    Emitter<UserListState> emit,
  ) async {
    if (state is UserListLoaded) {
      final currentState = state as UserListLoaded;

      final result = await getUsersWithFilters(
        UserFilterParams(
          userType: event.userType,
          userStatus: event.userStatus,
        ),
      );

      result.fold(
        (failure) => emit(UserListError(failure.message)),
        (filtered) => emit(
          currentState.copyWith(
            selectedUserType: event.userType,
            selectedUserStatus: event.userStatus,
            filteredUsers: filtered,
            totalRecords: filtered.length,
          ),
        ),
      );
    }
  }

  Future<void> _onResetFilters(
    ResetFiltersEvent event,
    Emitter<UserListState> emit,
  ) async {
    if (state is UserListLoaded) {
      final currentState = state as UserListLoaded;

      final result = await getUsers(NoParams());

      result.fold(
        (failure) => emit(UserListError(failure.message)),
        (users) => emit(
          UserListLoaded(
            allUsers: users,
            filteredUsers: users,
            userTypes: currentState.userTypes,
            userStatuses: currentState.userStatuses,
            totalRecords: users.length,
          ),
        ),
      );
    }
  }

  void _onSortByColumn(SortByColumnEvent event, Emitter<UserListState> emit) {
    if (state is UserListLoaded) {
      final currentState = state as UserListLoaded;
      final sorted = List<User>.from(currentState.filteredUsers);

      sorted.sort((a, b) {
        int comparison = 0;
        switch (event.columnId) {
          case 'userName':
            comparison = a.userName.compareTo(b.userName);
            break;
          case 'parentUser':
            comparison = a.parentUser.compareTo(b.parentUser);
            break;
          case 'type':
            comparison = a.type.compareTo(b.type);
            break;
          case 'name':
            comparison = a.name.compareTo(b.name);
            break;
          case 'plPercent':
            comparison = a.plPercent.compareTo(b.plPercent);
            break;
          case 'brkPercent':
            comparison = a.brkPercent.compareTo(b.brkPercent);
            break;
          case 'leverage':
            comparison = a.leverage.compareTo(b.leverage);
            break;
          case 'credit':
            comparison = a.credit.compareTo(b.credit);
            break;
          case 'pl':
            comparison = a.pl.compareTo(b.pl);
            break;
          case 'equity':
            comparison = a.equity.compareTo(b.equity);
            break;
          case 'totalMargin':
            comparison = a.totalMargin.compareTo(b.totalMargin);
            break;
          case 'usedMargin':
            comparison = a.usedMargin.compareTo(b.usedMargin);
            break;
          case 'freeMargin':
            comparison = a.freeMargin.compareTo(b.freeMargin);
            break;
          case 'createdDate':
            comparison = a.createdDate.compareTo(b.createdDate);
            break;
          case 'lastLoginDateTime':
            final aLogin = a.lastLoginDateTime ?? DateTime(1970);
            final bLogin = b.lastLoginDateTime ?? DateTime(1970);
            comparison = aLogin.compareTo(bLogin);
            break;
          case 'deviceType':
            comparison = (a.deviceType ?? '').compareTo(b.deviceType ?? '');
            break;
          case 'ipAddress':
            comparison = (a.ipAddress ?? '').compareTo(b.ipAddress ?? '');
            break;
        }
        return event.ascending ? comparison : -comparison;
      });

      emit(
        currentState.copyWith(
          filteredUsers: sorted,
          sortColumn: event.columnId,
          sortAscending: event.ascending,
        ),
      );
    }
  }

  Future<void> _onExportToPdf(
    ExportToPdfEvent event,
    Emitter<UserListState> emit,
  ) async {
    if (state is UserListLoaded) {
      final currentState = state as UserListLoaded;

      emit(const UserListExporting('pdf'));

      final result = await exportUsersToPdf(
        ExportUsersParams(users: currentState.filteredUsers),
      );

      result.fold(
        (failure) {
          emit(UserListError(failure.message));
          emit(currentState);
        },
        (filePath) {
          emit(
            UserListExportSuccess(
              message: 'PDF exported successfully',
              filePath: filePath,
            ),
          );
          emit(currentState);
        },
      );
    }
  }

  Future<void> _onExportToExcel(
    ExportToExcelEvent event,
    Emitter<UserListState> emit,
  ) async {
    if (state is UserListLoaded) {
      final currentState = state as UserListLoaded;

      emit(const UserListExporting('excel'));

      final result = await exportUsersToExcel(
        ExportUsersParams(users: currentState.filteredUsers),
      );

      result.fold(
        (failure) {
          emit(UserListError(failure.message));
          emit(currentState);
        },
        (filePath) {
          emit(
            UserListExportSuccess(
              message: 'Excel exported successfully',
              filePath: filePath,
            ),
          );
          emit(currentState);
        },
      );
    }
  }

  void _onSelectUser(SelectUserEvent event, Emitter<UserListState> emit) {
    if (state is UserListLoaded) {
      final currentState = state as UserListLoaded;
      emit(currentState.copyWith(selectedUserId: event.userId));
    }
  }
}
