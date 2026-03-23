import 'package:equatable/equatable.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();
  @override
  List<Object?> get props => [];
}

class LoadGroupsEvent extends GroupEvent {}

class AddGroupEvent extends GroupEvent {
  final String exchange;
  final String groupName;
  final bool isDefault;
  const AddGroupEvent({
    required this.exchange,
    required this.groupName,
    required this.isDefault,
  });
  @override
  List<Object?> get props => [exchange, groupName, isDefault];
}

class ImportGroupEvent extends GroupEvent {
  final String filePath;
  const ImportGroupEvent({required this.filePath});
  @override
  List<Object?> get props => [filePath];
}
