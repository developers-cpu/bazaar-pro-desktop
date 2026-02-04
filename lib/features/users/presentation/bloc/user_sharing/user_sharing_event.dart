import 'package:equatable/equatable.dart';
abstract class UserSharingEvent extends Equatable {
  const UserSharingEvent();
  @override
  List<Object> get props => [];
}
class LoadUserSharingDetails extends UserSharingEvent {
  final String userId;
  const LoadUserSharingDetails(this.userId);
  @override
  List<Object> get props => [userId];
}
