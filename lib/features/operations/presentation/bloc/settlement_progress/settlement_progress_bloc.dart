import 'package:flutter_bloc/flutter_bloc.dart';
import 'settlement_progress_event.dart';
import 'settlement_progress_state.dart';
import '../../../domain/usecases/settlement_progress/import_bhav_copy_usecase.dart';
import '../../../domain/usecases/settlement_progress/submit_bhav_copy_usecase.dart';
import '../../../domain/usecases/settlement_progress/get_settlement_data_usecase.dart';
class SettlementProgressBloc
    extends Bloc<SettlementProgressEvent, SettlementProgressState> {
  final ImportBhavCopyUseCase importBhavCopy;
  final SubmitBhavCopyUseCase submitBhavCopy;
  final GetSettlementDataUseCase getSettlementData;
  String currentExchange = 'NSE';
  SettlementProgressBloc({
    required this.importBhavCopy,
    required this.submitBhavCopy,
    required this.getSettlementData,
  }) : super(SettlementProgressInitial()) {
    on<ChangeExchangeEvent>(_onChangeExchange);
    on<ImportFileEvent>(_onImportFile);
    on<SubmitBhavCopyEvent>(_onSubmitBhavCopy);
    on<LoadSettlementDataEvent>(_onLoadSettlementData);
  }
  void _onChangeExchange(
    ChangeExchangeEvent event,
    Emitter<SettlementProgressState> emit,
  ) {
    currentExchange = event.exchange;
    emit(SettlementProgressInitial());
  }
  Future<void> _onImportFile(
    ImportFileEvent event,
    Emitter<SettlementProgressState> emit,
  ) async {
    emit(const SettlementProgressLoading(message: 'Parsing file...'));
    final result = await importBhavCopy(event.filePath);
    result.fold(
      (failure) => emit(SettlementProgressError(failure.message)),
      (data) => emit(BhavCopyPreviewReady(data)),
    );
  }
  Future<void> _onSubmitBhavCopy(
    SubmitBhavCopyEvent event,
    Emitter<SettlementProgressState> emit,
  ) async {
    emit(SettlementProgressUpdating());
    final result = await submitBhavCopy(event.data);
    result.fold((failure) => emit(SettlementProgressError(failure.message)), (
      _,
    ) {
      emit(SettlementCompleted());
    });
  }
  Future<void> _onLoadSettlementData(
    LoadSettlementDataEvent event,
    Emitter<SettlementProgressState> emit,
  ) async {
    emit(const SettlementProgressLoading());
    final result = await getSettlementData(currentExchange);
    result.fold(
      (failure) => emit(SettlementProgressError(failure.message)),
      (data) => emit(
        SettlementDataLoaded(
          settlementData: data,
          activeExchange: currentExchange,
        ),
      ),
    );
  }
}
