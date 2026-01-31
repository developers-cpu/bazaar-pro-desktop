import 'package:bazarpro/features/users/domain/entities/user_sharing_info.dart';
import 'package:equatable/equatable.dart';


class UserSharingDetails extends Equatable {
  final List<UserSharingInfo> plSharing;
  final List<UserSharingInfo> brokerageSharing;

  const UserSharingDetails({
    required this.plSharing,
    required this.brokerageSharing,
  });

  @override
  List<Object?> get props => [plSharing, brokerageSharing];
}
