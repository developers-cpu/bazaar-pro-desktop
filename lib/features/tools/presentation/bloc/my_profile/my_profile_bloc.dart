import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_my_profile_usecase.dart';
import 'my_profile_event.dart';
import 'my_profile_state.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  final GetMyProfileUseCase getMyProfile;

  MyProfileBloc({required this.getMyProfile}) : super(MyProfileInitial()) {
    on<LoadMyProfileEvent>(_onLoadMyProfile);
  }

  Future<void> _onLoadMyProfile(
    LoadMyProfileEvent event,
    Emitter<MyProfileState> emit,
  ) async {
    emit(MyProfileLoading());
    final result = await getMyProfile(NoParams());
    result.fold(
      (failure) => emit(MyProfileError(failure.message)),
      (profile) => emit(MyProfileLoaded(profile)),
    );
  }
}
