import 'package:bazarpro/features/users/domain/usecases/user_sharing_details/get_user_sharing_details_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_sharing_event.dart';
import 'user_sharing_state.dart';
class UserSharingBloc extends Bloc<UserSharingEvent, UserSharingState> {
  final GetUserSharingDetails getUserSharingDetails;
  UserSharingBloc({required this.getUserSharingDetails})
    : super(UserSharingInitial()) {
    on<LoadUserSharingDetails>(_onLoadDetails);
  }
  void _onLoadDetails(
    LoadUserSharingDetails event,
    Emitter<UserSharingState> emit,
  ) async {
    emit(UserSharingLoading());
    final result = await getUserSharingDetails(event.userId);
    result.fold(
      (failure) => emit(UserSharingError(failure.message)),
      (details) => emit(
        UserSharingLoaded(
          plSharing: details.plSharing,
          brokerageSharing: details.brokerageSharing,
        ),
      ),
    );
  }
}
