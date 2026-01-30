import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_sharing_info.dart';
import 'user_sharing_event.dart';
import 'user_sharing_state.dart';


class UserSharingBloc extends Bloc<UserSharingEvent, UserSharingState> {
  UserSharingBloc() : super(UserSharingLoading()) {
    on<LoadUserSharingDetails>(_onLoadUserSharingDetails);
  }

  void _onLoadUserSharingDetails(
    LoadUserSharingDetails event,
    Emitter<UserSharingState> emit,
  ) async {
    emit(UserSharingLoading());
    await Future.delayed(const Duration(seconds: 1)); // Simulate API

    // Mock Data based on screenshot
    final plSharing = [
      const UserSharingInfo(person: 'Admin', share: '5000%'),
      const UserSharingInfo(person: 'Master ( RAJ701 )', share: '5000%'),
      const UserSharingInfo(person: 'Client ( marko )', share: '000%'),
    ];

    final brokerageSharing = [
      const UserSharingInfo(person: 'Admin', share: '5000%'),
      const UserSharingInfo(person: 'Master ( RAJ701 )', share: '5000%'),
      const UserSharingInfo(person: 'Client ( marko )', share: '000%'),
    ];

    emit(
      UserSharingLoaded(
        plSharing: plSharing,
        brokerageSharing: brokerageSharing,
      ),
    );
  }
}
