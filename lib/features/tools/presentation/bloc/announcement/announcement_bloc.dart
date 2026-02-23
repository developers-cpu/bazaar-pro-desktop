import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/announcement_entity.dart';
import '../../../domain/usecases/get_announcements_usecase.dart';
part 'announcement_event.dart';
part 'announcement_state.dart';
class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final GetAnnouncementsUseCase getAnnouncements;
  AnnouncementBloc({required this.getAnnouncements})
    : super(AnnouncementLoading()) {
    on<LoadAnnouncements>(_onLoadAnnouncements);
  }
  Future<void> _onLoadAnnouncements(
    LoadAnnouncements event,
    Emitter<AnnouncementState> emit,
  ) async {
    emit(AnnouncementLoading());
    final result = await getAnnouncements(NoParams());
    result.fold(
      (failure) =>
          emit(const AnnouncementError('Failed to load announcements')),
      (announcements) {
        announcements.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        emit(AnnouncementLoaded(announcements));
      },
    );
  }
}
