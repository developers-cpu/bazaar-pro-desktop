import 'package:bazarpro/features/users/domain/entities/user_sharing_info.dart';
import 'package:equatable/equatable.dart';
abstract class UserSharingState extends Equatable {
  const UserSharingState();
  @override
  List<Object> get props => [];
}
class UserSharingInitial extends UserSharingState {}
class UserSharingLoading extends UserSharingState {}
class UserSharingLoaded extends UserSharingState {
  final List<UserSharingInfo> plSharing;
  final List<UserSharingInfo> brokerageSharing;
  const UserSharingLoaded({
    required this.plSharing,
    required this.brokerageSharing,
  });
  @override
  List<Object> get props => [plSharing, brokerageSharing];
}
class UserSharingError extends UserSharingState {
  final String message;
  const UserSharingError(this.message);
  @override
  List<Object> get props => [message];
}
