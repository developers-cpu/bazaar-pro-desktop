import 'package:equatable/equatable.dart';
class UserSharingInfo extends Equatable {
  final String person;
  final String share;
  const UserSharingInfo({required this.person, required this.share});
  @override
  List<Object?> get props => [person, share];
}
