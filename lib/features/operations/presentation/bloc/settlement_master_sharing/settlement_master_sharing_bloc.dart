import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_settlement_master_sharing.dart';
import 'settlement_master_sharing_event.dart';
import 'settlement_master_sharing_state.dart';

class SettlementMasterSharingBloc
    extends Bloc<SettlementMasterSharingEvent, SettlementMasterSharingState> {
  final GetSettlementMasterSharing getSettlementMasterSharing;
  SettlementMasterSharingBloc({required this.getSettlementMasterSharing})
    : super(SettlementMasterSharingInitial()) {
    on<LoadMasterSharingDataEvent>(_onLoadData);
    on<SelectMasterEvent>(_onSelectMaster);
  }
  Future<void> _onLoadData(
    LoadMasterSharingDataEvent event,
    Emitter<SettlementMasterSharingState> emit,
  ) async {
    emit(SettlementMasterSharingLoading());
    final result = await getSettlementMasterSharing(
      GetSettlementMasterSharingParams(masterId: event.masterId),
    );
    result.fold(
      (failure) => emit(SettlementMasterSharingError(message: failure.message)),
      (data) => emit(
        SettlementMasterSharingLoaded(
          masters: data.masters,
          entries: data.entries,
          totalRecords: data.totalRecords,
        ),
      ),
    );
  }

  Future<void> _onSelectMaster(
    SelectMasterEvent event,
    Emitter<SettlementMasterSharingState> emit,
  ) async {
    emit(SettlementMasterSharingLoading());
    final result = await getSettlementMasterSharing(
      GetSettlementMasterSharingParams(masterId: event.masterId),
    );
    result.fold(
      (failure) => emit(SettlementMasterSharingError(message: failure.message)),
      (data) => emit(
        SettlementMasterSharingLoaded(
          masters: data.masters,
          entries: data.entries,
          totalRecords: data.totalRecords,
          selectedMasterId: event.masterId,
          selectedMasterName: event.masterName,
        ),
      ),
    );
  }
}