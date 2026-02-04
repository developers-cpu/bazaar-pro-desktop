import 'package:bazarpro/features/market_watch/presentation/bloc/watchlist/watch_list_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_strings.dart';
import 'watchlist_state.dart';
class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc() : super(const WatchlistInitial()) {
    on<LoadWatchlistsEvent>(_onLoadWatchlists);
    on<AddWatchlistEvent>(_onAddWatchlist);
    on<RemoveWatchlistEvent>(_onRemoveWatchlist);
    on<SelectWatchlistEvent>(_onSelectWatchlist);
    on<RenameWatchlistEvent>(_onRenameWatchlist);
  }
  void _onLoadWatchlists(
      LoadWatchlistsEvent event,
      Emitter<WatchlistState> emit,
      ) {
    emit(const WatchlistLoaded(
      watchlists: [
        AppStrings.watchlist1,
        AppStrings.watchlist2,
        AppStrings.watchlist3,
      ],
      selectedIndex: -1,
    ));
  }
  void _onAddWatchlist(
      AddWatchlistEvent event,
      Emitter<WatchlistState> emit,
      ) {
    if (state is WatchlistLoaded) {
      final currentState = state as WatchlistLoaded;
      final nextNumber = currentState.watchlists.length + 1;
      final newWatchlistName = '${AppStrings.watchlist} $nextNumber';
      final updatedWatchlists = List<String>.from(currentState.watchlists)
        ..add(newWatchlistName);
      emit(currentState.copyWith(
        watchlists: updatedWatchlists,
      ));
    }
  }
  Future<void> _onRemoveWatchlist(
      RemoveWatchlistEvent event,
      Emitter<WatchlistState> emit,
      ) async {
    if (state is WatchlistLoaded) {
      final currentState = state as WatchlistLoaded;
      if (currentState.watchlists.length <= 1) {
        emit(WatchlistError(message: AppStrings.atLeastOneWatchlistRequired));
        await Future.delayed(const Duration(milliseconds: 100));
        emit(currentState);
        return;
      }
      final updatedWatchlists = List<String>.from(currentState.watchlists)
        ..removeAt(event.index);
      int newSelectedIndex = currentState.selectedIndex;
      if (currentState.selectedIndex == event.index) {
        newSelectedIndex = -1;
      } else if (currentState.selectedIndex > event.index) {
        newSelectedIndex = currentState.selectedIndex - 1;
      }
      emit(currentState.copyWith(
        watchlists: updatedWatchlists,
        selectedIndex: newSelectedIndex,
      ));
    }
  }
  void _onSelectWatchlist(
      SelectWatchlistEvent event,
      Emitter<WatchlistState> emit,
      ) {
    if (state is WatchlistLoaded) {
      final currentState = state as WatchlistLoaded;
      emit(currentState.copyWith(
        selectedIndex: event.index,
      ));
    }
  }
  void _onRenameWatchlist(
      RenameWatchlistEvent event,
      Emitter<WatchlistState> emit,
      ) {
    if (state is WatchlistLoaded) {
      final currentState = state as WatchlistLoaded;
      if (event.index >= 0 && event.index < currentState.watchlists.length) {
        final updatedWatchlists = List<String>.from(currentState.watchlists);
        updatedWatchlists[event.index] = event.newName;
        emit(currentState.copyWith(
          watchlists: updatedWatchlists,
        ));
      }
    }
  }
}
