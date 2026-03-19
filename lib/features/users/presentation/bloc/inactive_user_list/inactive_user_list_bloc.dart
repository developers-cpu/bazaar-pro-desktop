import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/user/get_users.dart';
import '../../../domain/usecases/user/get_users_with_filters.dart';
import '../../../domain/usecases/user/get_user_types.dart';
import '../../../domain/usecases/user/get_user_statuses.dart';
import '../../../domain/usecases/user/export_users_to_pdf.dart';
import '../../../domain/usecases/user/export_users_to_excel.dart';
import 'inactive_user_list_event.dart';
import 'inactive_user_list_state.dart';

class InactiveUserListBloc
    extends Bloc<InactiveUserListEvent, InactiveUserListState> {
  final GetUsers getUsers;
  final GetUsersWithFilters getUsersWithFilters;
  final GetUserTypes getUserTypes;
  final GetUserStatuses getUserStatuses;
  final ExportUsersToPdf exportUsersToPdf;
  final ExportUsersToExcel exportUsersToExcel;
  InactiveUserListBloc({
    required this.getUsers,
    required this.getUsersWithFilters,
    required this.getUserTypes,
    required this.getUserStatuses,
    required this.exportUsersToPdf,
    required this.exportUsersToExcel,
  }) : super(const InactiveUserListInitial()) {
    on<LoadInactiveUsersEvent>(_onLoadUsers);
    on<FilterInactiveByUserTypeEvent>(_onFilterByUserType);
    on<FilterInactiveByUserStatusEvent>(_onFilterByUserStatus);
    on<ApplyInactiveFiltersEvent>(_onApplyFilters);
    on<ResetInactiveFiltersEvent>(_onResetFilters);
    on<SortInactiveByColumnEvent>(_onSortByColumn);
    on<ExportInactiveToPdfEvent>(_onExportToPdf);
    on<ExportInactiveToExcelEvent>(_onExportToExcel);
    on<SelectInactiveUserEvent>(_onSelectUser);
  }
  Future<void> _onLoadUsers(
    LoadInactiveUsersEvent event,
    Emitter<InactiveUserListState> emit,
  ) async {
    emit(const InactiveUserListLoading());
    try {
      final result = await getUsersWithFilters(
        UserFilterParams(userStatus: 'Inactive'),
      );
      final types = getUserTypes();
      final statuses = getUserStatuses();
      result.fold(
        (failure) => emit(InactiveUserListError(failure.message)),
        (users) => emit(
          InactiveUserListLoaded(
            allUsers: users,
            filteredUsers: users,
            userTypes: types,
            userStatuses: statuses,
            selectedUserStatus: 'Inactive',
            totalRecords: users.length,
          ),
        ),
      );
    } catch (e) {
      emit(InactiveUserListError(e.toString()));
    }
  }

  Future<void> _onFilterByUserType(
    FilterInactiveByUserTypeEvent event,
    Emitter<InactiveUserListState> emit,
  ) async {
    if (state is InactiveUserListLoaded) {
      final currentState = state as InactiveUserListLoaded;
      final result = await getUsersWithFilters(
        UserFilterParams(
          userType: event.userType,
          userStatus: currentState.selectedUserStatus ?? 'Inactive',
        ),
      );
      result.fold(
        (failure) => emit(InactiveUserListError(failure.message)),
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
    FilterInactiveByUserStatusEvent event,
    Emitter<InactiveUserListState> emit,
  ) async {
    if (state is InactiveUserListLoaded) {
      final currentState = state as InactiveUserListLoaded;
      final result = await getUsersWithFilters(
        UserFilterParams(
          userType: currentState.selectedUserType,
          userStatus: event.userStatus,
        ),
      );
      result.fold(
        (failure) => emit(InactiveUserListError(failure.message)),
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
    ApplyInactiveFiltersEvent event,
    Emitter<InactiveUserListState> emit,
  ) async {
    if (state is InactiveUserListLoaded) {
      final currentState = state as InactiveUserListLoaded;
      final result = await getUsersWithFilters(
        UserFilterParams(
          userType: event.userType,
          userStatus: event.userStatus,
        ),
      );
      result.fold(
        (failure) => emit(InactiveUserListError(failure.message)),
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
    ResetInactiveFiltersEvent event,
    Emitter<InactiveUserListState> emit,
  ) async {
    if (state is InactiveUserListLoaded) {
      final currentState = state as InactiveUserListLoaded;
      final result = await getUsersWithFilters(
        UserFilterParams(userStatus: 'Inactive'),
      );
      result.fold(
        (failure) => emit(InactiveUserListError(failure.message)),
        (users) => emit(
          InactiveUserListLoaded(
            allUsers: users,
            filteredUsers: users,
            userTypes: currentState.userTypes,
            userStatuses: currentState.userStatuses,
            selectedUserStatus: 'Inactive',
            totalRecords: users.length,
          ),
        ),
      );
    }
  }

  void _onSortByColumn(
    SortInactiveByColumnEvent event,
    Emitter<InactiveUserListState> emit,
  ) {
    if (state is InactiveUserListLoaded) {
      final currentState = state as InactiveUserListLoaded;
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
    ExportInactiveToPdfEvent event,
    Emitter<InactiveUserListState> emit,
  ) async {
    if (state is InactiveUserListLoaded) {
      final currentState = state as InactiveUserListLoaded;
      emit(const InactiveUserListExporting('pdf'));
      final result = await exportUsersToPdf(
        ExportUsersParams(users: currentState.filteredUsers),
      );
      result.fold(
        (failure) {
          emit(InactiveUserListError(failure.message));
          emit(currentState);
        },
        (filePath) {
          emit(
            InactiveUserListExportSuccess(
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
    ExportInactiveToExcelEvent event,
    Emitter<InactiveUserListState> emit,
  ) async {
    if (state is InactiveUserListLoaded) {
      final currentState = state as InactiveUserListLoaded;
      emit(const InactiveUserListExporting('excel'));
      final result = await exportUsersToExcel(
        ExportUsersParams(users: currentState.filteredUsers),
      );
      result.fold(
        (failure) {
          emit(InactiveUserListError(failure.message));
          emit(currentState);
        },
        (filePath) {
          emit(
            InactiveUserListExportSuccess(
              message: 'Excel exported successfully',
              filePath: filePath,
            ),
          );
          emit(currentState);
        },
      );
    }
  }

  void _onSelectUser(
    SelectInactiveUserEvent event,
    Emitter<InactiveUserListState> emit,
  ) {
    if (state is InactiveUserListLoaded) {
      final currentState = state as InactiveUserListLoaded;
      emit(currentState.copyWith(selectedUserId: event.userId));
    }
  }
}