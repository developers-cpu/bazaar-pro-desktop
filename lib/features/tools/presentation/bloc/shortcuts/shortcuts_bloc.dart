import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_shortcuts_usecase.dart';
import 'shortcuts_event.dart';
import 'shortcuts_state.dart';

class ShortcutsBloc extends Bloc<ShortcutsEvent, ShortcutsState> {
  final GetShortcutsUseCase getShortcuts;
  ShortcutsBloc({required this.getShortcuts}) : super(ShortcutsInitial()) {
    on<GetShortcutsEvent>(_onGetShortcuts);
  }
  Future<void> _onGetShortcuts(
    GetShortcutsEvent event,
    Emitter<ShortcutsState> emit,
  ) async {
    emit(ShortcutsLoading());
    final result = await getShortcuts(NoParams());
    result.fold(
      (failure) => emit(const ShortcutsError('Failed to load shortcuts')),
      (shortcuts) => emit(ShortcutsLoaded(shortcuts)),
    );
  }
}
