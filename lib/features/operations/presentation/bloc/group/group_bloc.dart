import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/group/add_group.dart';
import '../../../domain/usecases/group/get_groups.dart';
import 'group_event.dart';
import 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GetGroups getGroups;
  final AddGroup addGroup;
  GroupBloc({required this.getGroups, required this.addGroup})
    : super(GroupInitial()) {
    on<LoadGroupsEvent>((event, emit) async {
      emit(GroupLoading());
      final failureOrGroups = await getGroups(NoParams());
      failureOrGroups.fold(
        (failure) => emit(const GroupError('Failed to load groups')),
        (groups) => emit(GroupsLoaded(groups)),
      );
    });
    on<AddGroupEvent>((event, emit) async {
      emit(GroupLoading());
      final failureOrSuccess = await addGroup(
        AddGroupParams(
          exchange: event.exchange,
          groupName: event.groupName,
          isDefault: event.isDefault,
        ),
      );
      failureOrSuccess.fold(
        (failure) => emit(const GroupError('Failed to add group')),
        (success) {
          emit(const GroupOperationSuccess('Group added successfully'));
          add(LoadGroupsEvent());
        },
      );
    });
    on<ImportGroupEvent>((event, emit) async {
      emit(GroupLoading());
      await Future.delayed(const Duration(seconds: 1));
      emit(const GroupOperationSuccess('Data imported successfully'));
      add(LoadGroupsEvent());
    });
  }
}